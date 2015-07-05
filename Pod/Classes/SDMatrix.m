//
// Created by Marek Matulski on 09/06/15.
// Copyright (c) 2015 BladePolska. All rights reserved.
//

#import "SDMatrix.h"
#import <Accelerate/Accelerate.h>

@interface SDMatrix ()

@property(nonatomic, readonly) double *data;

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
        _data = data;
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
        _data = data;
    }

    return self;
}

+ (instancetype)matrixWithData:(double*)inputData withNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns {
    return [[self alloc] initWithData:inputData withNumberOfRows:numberOfRows numberOfColumns:numberOfColumns];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[SDMatrix alloc] initWithData:self.data withNumberOfRows:self.numberOfRows numberOfColumns:self.numberOfColumns];
}

#pragma mark - accessing items

- (double)valueAtRow:(NSUInteger)row column:(NSUInteger)column {
    if([self isOutOfBoundsIfRow:row andColumn:column]){
        return 0;
    }

    return self.data[row * self.numberOfColumns + column];
}

- (void)setValue:(double)value atRow:(NSUInteger)row andColumn:(NSUInteger)column {
    if(![self isOutOfBoundsIfRow:row andColumn:column]) {
        self.data[row * self.numberOfColumns + column] = value;
    }
}

- (BOOL)isOutOfBoundsIfRow:(NSUInteger)n andColumn:(NSUInteger)m {
    return n >= self.numberOfRows || m >= self.numberOfColumns;
}

#pragma mark - modifications

- (void)makeIdentity {
    for(NSUInteger n = 0; n < self.numberOfRows; n++){
        for(NSUInteger m = 0; m < self.numberOfColumns; m++){
            self.data[n * self.numberOfColumns + m] = m == n ? 1.0 : 0.0;
        }
    }
}

#pragma mark - operations

- (SDMatrix *)matrixByMultiplicationWithMatrix:(SDMatrix *)anotherMatrix {

    if(self.numberOfColumns != anotherMatrix.numberOfRows){
        return nil;
    }

    int m = (int)self.numberOfRows;
    int k = (int)self.numberOfColumns;
    int n = (int)anotherMatrix.numberOfColumns;

    SDMatrix *resultMatrix = [SDMatrix matrixWithNumberOfRows:self.numberOfRows numberOfColumns:anotherMatrix.numberOfColumns];
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
            m, n, k, 1, self.data, k, anotherMatrix.data, n, 1,
            resultMatrix.data, n);
    return resultMatrix;
}

- (SDMatrix *)matrixByMultiplicationWithTransposedMatrix:(SDMatrix *)anotherMatrix {

    if(self.numberOfColumns != anotherMatrix.numberOfColumns){
        return nil;
    }

    int m = (int)self.numberOfRows;
    int k = (int)self.numberOfColumns;
    int n = (int)anotherMatrix.numberOfRows;

    SDMatrix *resultMatrix = [SDMatrix matrixWithNumberOfRows:self.numberOfRows numberOfColumns:anotherMatrix.numberOfRows];
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasTrans,
            m, n, k, 1, self.data, k, anotherMatrix.data, (int)anotherMatrix.numberOfColumns, 1,
            resultMatrix.data, n);
    return resultMatrix;
}

- (void)scale:(double)factor
{
    cblas_dscal(self.numberOfRows * self.numberOfColumns, factor, self.data, 1);
}

- (BOOL)addMatrix:(SDMatrix *)matrixToAdd {
    if(self.numberOfRows != matrixToAdd.numberOfRows || self.numberOfColumns != matrixToAdd.numberOfColumns){
        return NO;
    }

    cblas_daxpy(self.numberOfRows * self.numberOfColumns, 1, matrixToAdd.data, 1, self.data, 1);
    return YES;
}

- (SDMatrix *)matrixByAdditionOfMatrix:(SDMatrix *)matrixToAdd {
    SDMatrix *matrix = [self copy];
    if([matrix addMatrix:matrixToAdd]){
        return matrix;
    }

    return nil;
}

- (BOOL)subtractMatrix:(SDMatrix *)matrixToSubtract {
    if(self.numberOfRows != matrixToSubtract.numberOfRows || self.numberOfColumns != matrixToSubtract.numberOfColumns){
        return NO;
    }

    cblas_daxpy(self.numberOfRows * self.numberOfColumns, -1, matrixToSubtract.data, 1, self.data, 1);
    return YES;
}

- (SDMatrix *)matrixBySubtractionOfMatrix:(SDMatrix *)matrixToSubtract {
    SDMatrix *matrix = [self copy];
    if([matrix subtractMatrix:matrixToSubtract]){
        return matrix;
    }

    return nil;
}

- (BOOL)invertMatrix {
    if(self.numberOfRows != self.numberOfColumns){
        return NO;
    }

    int N = (int)self.numberOfRows;
    NSUInteger pivotSize = self.numberOfRows * sizeof(int);
    NSUInteger workspaceSize = self.numberOfRows * sizeof(double);
    int *pivot = malloc(pivotSize);
    double *workspace = malloc(workspaceSize);

    int error = 0;

    /*  LU factorisation */
    dgetrf_(&N, &N, self.data, &N, pivot, &error);

    if (error != 0) {
        free(pivot);
        free(workspace);
        return NO;
    }

    /*  matrix inversion */
    dgetri_(&N, self.data, &N, pivot, workspace, &N, &error);

    if (error != 0) {
        free(pivot);
        free(workspace);
        return NO;
    }

    free(pivot);
    free(workspace);
    return YES;
}

- (SDMatrix *)matrixByInvertion {
    SDMatrix *matrix = [self copy];
    if([matrix invertMatrix]){
        return matrix;
    }

    return nil;
}


#pragma mark - Compare

- (BOOL)isEqual:(id)other {
    if (other == self){
        return YES;
    }

    if (!other || ![[other class] isEqual:[self class]]){
        return NO;
    }

    return [self isEqualToMatrix:(SDMatrix *)other];
}

- (BOOL)isEqualToMatrix:(SDMatrix *)anotherMatrix
{
    return [self isEqualToMatrix:anotherMatrix withPrecision:0];
}

- (BOOL)isEqualToMatrix:(SDMatrix *)anotherMatrix withPrecision:(double)precision
{
    if(self.numberOfRows != anotherMatrix.numberOfRows){
        return NO;
    }

    if(self.numberOfColumns != anotherMatrix.numberOfColumns){
        return NO;
    }

    for(NSUInteger n = 0; n < self.numberOfRows; n++){
        for(NSUInteger m = 0; m < self.numberOfColumns; m++){
            double diff = [self valueAtRow:n column:m] - [anotherMatrix valueAtRow:n column:m];
            if(fabs(diff) > precision){
                return NO;
            }
        }
    }

    return YES;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];

    [description appendString:@">"];
    [description appendFormat:@"\n[%lu, %lu]", (unsigned long)self.numberOfRows, (unsigned long)self.numberOfColumns];

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