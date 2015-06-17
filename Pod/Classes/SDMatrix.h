//
// Created by Marek Matulski on 09/06/15.
// Copyright (c) 2015 BladePolska. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SDMatrix : NSObject <NSCopying>

/**
 * Number of rows in matrix.
 */
@property (nonatomic) NSUInteger numberOfRows;

/**
* Number of columns in matrix.
*/
@property (nonatomic) NSUInteger numberOfColumns;

/**
* Initializes SDMatrix with number of rows and columns.
*
* @param numberOfRows NSUInteger number of rows in created matrix.
* @param numberOfColumns NSUInteger number of columns in created matrix.
*
* @return the newly initialized SDMatrix.
*/
- (instancetype)initWithNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns;

/**
* Initializes SDMatrix with array of doubles.
*
* @param inputData array of doubles to put into matrix.
* @param numberOfRows NSUInteger number of rows in created matrix.
* @param numberOfColumns NSUInteger number of columns in created matrix.
*
* @return the newly initialized SDMatrix.
*/
- (instancetype)initWithData:(double *)inputData withNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns;

/**
* Returns new SDMatrix with number of rows and columns.
*
* @param numberOfRows NSUInteger number of rows in created matrix.
* @param numberOfColumns NSUInteger number of columns in created matrix.
*
* @return the newly created SDMatrix.
*/
+ (instancetype)matrixWithNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns;

/**
* Returns new SDMatrix with array of doubles.
*
* @param inputData array of doubles to put into matrix.
* @param numberOfRows NSUInteger number of rows in created matrix.
* @param numberOfColumns NSUInteger number of columns in created matrix.
*
* @return the newly created SDMatrix.
*/
+ (instancetype)matrixWithData:(double *)inputData withNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns;

#pragma mark - accessing items

/**
* Returns matrix item at specified row and column.
*
* @param row NSUInteger row number.
* @param column NSUInteger column number.
*
* @return double value of item at pointed row and column
*/
- (double)valueAtRow:(NSUInteger)row column:(NSUInteger)column;

/**
* Changes value of matrix item at specified row and column.
*
* @param value double new value for setting.
* @param row NSUInteger row number.
* @param column NSUInteger column number.
*/
- (void)setValue:(double)value atRow:(NSUInteger)row andColumn:(NSUInteger)column;

#pragma mark - modifications

/**
* Updates all matrix items to make this matrix identity matrix.
*/
- (void)makeIdentity;

#pragma mark - operations

/**
* Creates new SDMatrix as a result of multiplication of this matrix with anotherMatrix.
*
* @param anotherMatrix SDMatrix.
*
* @return SDMatrix result of multiplication of this matrix with anotherMatrix.
*/
- (SDMatrix *)matrixByMultiplicationWithMatrix:(SDMatrix *)anotherMatrix;

/**
* Creates new SDMatrix as a result of multiplication of this matrix with transposed anotherMatrix.
*
* @param anotherMatrix SDMatrix.
*
* @return SDMatrix result of multiplication of this matrix with transposed anotherMatrix.
*/
- (SDMatrix *)matrixByMultiplicationWithTransposedMatrix:(SDMatrix *)anotherMatrix;

/**
* Adds matrix.
*
* @param anotherMatrix SDMatrix matrix to add.
*
* @return BOOL - true if addition was performed successfully, otherwise false.
*/
- (BOOL)addMatrix:(SDMatrix *)matrix;

/**
* Creates new SDMatrix as a result of addition of another matrix to this matrix.
*
* @param anotherMatrix SDMatrix matrix to add.
*
* @return SDMatrix result of addition of another matrix to this matrix.
*/
- (SDMatrix *)matrixByAdditionOfMatrix:(SDMatrix *)matrix;

/**
* Scales all matrix items with double value.
*
* @param factor double all matrix items will be multiplied with this value.
*/
- (void)scale:(double)factor;

/**
* Checks if all matrix elements are equal to adequate elements of another matrix.
*
* @param anotherMatrix SDMatrix to compare.
*/
- (BOOL)isEqualToMatrix:(SDMatrix *)anotherMatrix;

@end