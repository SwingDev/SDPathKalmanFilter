//
//  SDPathKalmanFilterTests.m
//  SDPathKalmanFilterTests
//
//  Created by Marek Matulski on 06/16/2015.
//  Copyright (c) 2015 Marek Matulski. All rights reserved.
//

@import XCTest;

#import <SDPathKalmanFilter/SDMatrix.h>

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMatrixMultiplicationWhereARowsCountIsEqualBColumnsCount
{
    double dataForMatrixA[6] = {
                                4, -3,
                               -6,  8,
                                2, -5
    };

    double dataForMatrixB[6] = {
            -8,  7,  1,
             5,  -3, 9
    };

    double dataForExpectedMatrix[9] = {
            -47,  37,  -23,
             88, -66,   66,
            -41,  29,  -43
    };

    SDMatrix *matrixA = [SDMatrix matrixWithData:dataForMatrixA withNumberOfRows:3 numberOfColumns:2];
    SDMatrix *matrixB = [SDMatrix matrixWithData:dataForMatrixB withNumberOfRows:2 numberOfColumns:3];
    SDMatrix *matrixExpected = [SDMatrix matrixWithData:dataForExpectedMatrix withNumberOfRows:3 numberOfColumns:3];

    SDMatrix *matrixC = [matrixA multiplyWithMatrix:matrixB];

    XCTAssertEqualObjects(matrixC, matrixExpected, @"Multiplication result matrix is not equal to expected one");
}

- (void)testMatrixMultiplicationWhereARowsCountIsDifferentThanBColumnsCount
{
    double dataForMatrixA[6] = {
            1, -2,
            -3,  4,
            5, -6
    };

    double dataForMatrixB[4] = {
            -4,  2,
            -2,  3
    };

    double dataForExpectedMatrix[6] = {
            0,  -4,
            4, 6,
            -8,  -8
    };

    SDMatrix *matrixA = [SDMatrix matrixWithData:dataForMatrixA withNumberOfRows:3 numberOfColumns:2];
    SDMatrix *matrixB = [SDMatrix matrixWithData:dataForMatrixB withNumberOfRows:2 numberOfColumns:2];
    SDMatrix *matrixExpected = [SDMatrix matrixWithData:dataForExpectedMatrix withNumberOfRows:3 numberOfColumns:2];

    SDMatrix *matrixC = [matrixA multiplyWithMatrix:matrixB];

    XCTAssertEqualObjects(matrixC, matrixExpected, @"Multiplication result matrix is not equal to expected one");
}

@end
