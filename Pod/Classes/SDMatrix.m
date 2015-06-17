//
// Created by Marek Matulski on 09/06/15.
// Copyright (c) 2015 BladePolska. All rights reserved.
//

#import "SDMatrix.h"
#import <Accelerate/Accelerate.h>

@interface SDMatrix ()

@property(nonatomic) double *data;

@end

@implementation SDMatrix {

}

- (instancetype)initWithNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns {
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

+ (instancetype)matrixWithNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns {
    return [[self alloc] initWithNumberOfRows:numberOfRows numberOfColumns:numberOfColumns];
}

+ (instancetype)identityMatrixWithNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns {
    SDMatrix *result = [[self alloc] initWithNumberOfRows:numberOfRows numberOfColumns:numberOfColumns];
    [result makeIdentity];
    return result;
}

- (instancetype)initWithData:(double*)inputData withNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns {
    self = [super init];
    if (self) {
        self.numberOfRows = numberOfRows;
        self.numberOfColumns = numberOfColumns;

        NSUInteger size = self.numberOfRows * self.numberOfColumns * sizeof(double);
        double *data = malloc(size);
        memcpy(data, inputData, size);
        self.data = data;
    }

    return self;
}

+ (instancetype)matrixWithData:(double*)inputData withNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns {
    return [[self alloc] initWithData:inputData withNumberOfRows:numberOfRows numberOfColumns:numberOfColumns];
}

- (double)valueAtRow:(NSUInteger)row column:(NSUInteger)column {
    [self checkIfIsNotOutOfBoundsIfRow:row andColumn:column];
    return _data[row * self.numberOfColumns + column];
}

- (void)setValue:(double)value n:(NSUInteger)n m:(NSUInteger)m{
    [self checkIfIsNotOutOfBoundsIfRow:n andColumn:m];
    _data[n * self.numberOfColumns + m] = value;
}

- (void)checkIfIsNotOutOfBoundsIfRow:(NSUInteger)n andColumn:(NSUInteger)m {
    if(n >= _numberOfRows){
        @throw [NSException exceptionWithName:@"IndexOutOfBoundException" reason:[NSString stringWithFormat:@"there is no such many rows (%zd >= %zd)", n, _numberOfRows]
                                     userInfo:nil];
    }

    if(m >= _numberOfColumns){
        @throw [NSException exceptionWithName:@"IndexOutOfBoundException" reason:[NSString stringWithFormat:@"there is no such many columns (%zd >= %zd)", m, _numberOfColumns]
                                     userInfo:nil];
    }
}

- (void)makeIdentity {
    for(NSUInteger n = 0; n < self.numberOfRows; n++){
        for(NSUInteger m = 0; m < self.numberOfColumns; m++){
            self.data[n * self.numberOfColumns + m] = m == n ? 1.0 : 0.0;
        }
    }
}

- (SDMatrix *)multiplyWithMatrix:(SDMatrix *)anotherMatrix {

    int m = (int)self.numberOfRows;
    int k = (int)self.numberOfColumns;
    int n = (int)anotherMatrix.numberOfColumns;

    SDMatrix *resultMatrix = [SDMatrix matrixWithNumberOfRows:self.numberOfRows numberOfColumns:anotherMatrix.numberOfColumns];
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
            m, n, k, 1, _data, k, anotherMatrix.data, n, 1,
            resultMatrix.data, n);
    return resultMatrix;
}

- (BOOL)isEqual:(id)other {
    if (other == self){
        return YES;
    }

    if (!other || ![[other class] isEqual:[self class]]){
        return NO;
    }

    return [self isEqualToMatrix:(SDMatrix *)other];
}

- (BOOL)isEqualToMatrix:(SDMatrix *)matrix
{
    if(self.numberOfRows != matrix.numberOfRows){
        return NO;
    }

    if(self.numberOfColumns != matrix.numberOfColumns){
        return NO;
    }

    for(NSUInteger n = 0; n < self.numberOfRows; n++){
        for(NSUInteger m = 0; m < self.numberOfColumns; m++){
            if([self valueAtRow:n column:m] != [matrix valueAtRow:n column:m]){
                return NO;
            }
        }
    }

    return YES;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];

    [description appendString:@">"];
    [description appendFormat:@"\n[%lu, %lu]", (unsigned long)self.numberOfRows, self.numberOfColumns];

    for(NSUInteger n = 0; n < self.numberOfRows; n++){
        for(NSUInteger m = 0; m < self.numberOfColumns; m++){
            [description appendFormat:@"%.3f\t", [self valueAtRow:n column:m]];
        }

        [description appendString:@"\n\t"];
    }

    return description;
}


- (void)dealloc {
    if(_data){
        free(_data);
    }
}


@end