//
// Created by Marek Matulski on 09/06/15.
// Copyright (c) 2015 BladePolska. All rights reserved.
//

#import "SDMatrix.h"


@interface SDMatrix ()

@property(nonatomic) double *data;

@end

@implementation SDMatrix {

}

- (instancetype)initWithNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns
{
    self = [super init];
    if (self) {
        self.numberOfRows = numberOfRows > 1 ? numberOfRows : 1;
        self.numberOfColumns = numberOfColumns > 1 ? numberOfColumns : 1;

        NSUInteger size = self.numberOfRows * self.numberOfColumns * sizeof(double);
        double *data = malloc(size);
        memset(data, 0, size);
        self.data = data;
    }

    return self;
}

+ (instancetype)matrixWithNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns
{
    return [[self alloc] initWithNumberOfRows:numberOfRows numberOfColumns:numberOfColumns];
}

+ (instancetype)identityMatrixWithNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns
{
    SDMatrix *result = [[self alloc] initWithNumberOfRows:numberOfRows numberOfColumns:numberOfColumns];
    [result makeIdentity];
    return result;
}

- (double)n:(NSUInteger)n m:(NSUInteger)m
{
    [self checkIfIsNotOutOfBoundsIfRow:n andColumn:m];
    return _data[n * self.numberOfColumns + m];
}

- (void)setValue:(double)value n:(NSUInteger)n m:(NSUInteger)m
{
    [self checkIfIsNotOutOfBoundsIfRow:n andColumn:m];
    _data[n * self.numberOfColumns + m] = value;
}

- (void)checkIfIsNotOutOfBoundsIfRow:(NSUInteger)n andColumn:(NSUInteger)m
{
    if(n >= _numberOfRows){
        @throw [NSException exceptionWithName:@"IndexOutOfBoundException" reason:[NSString stringWithFormat:@"there is no such many rows (%zd >= %zd)", n, _numberOfRows]
                                     userInfo:nil];
    }

    if(m >= _numberOfColumns){
        @throw [NSException exceptionWithName:@"IndexOutOfBoundException" reason:[NSString stringWithFormat:@"there is no such many columns (%zd >= %zd)", m, _numberOfColumns]
                                     userInfo:nil];
    }
}

- (void)makeIdentity
{
    for(NSUInteger n = 0; n < _numberOfRows; n++){
        for(NSUInteger m = 0; m <_numberOfColumns; m++){
            _data[n * self.numberOfColumns + m] = m == n ? 1.0 : 0.0;
        }
    }
}

- (void)dealloc
{
    if(_data){
        free(_data);
    }
}


@end