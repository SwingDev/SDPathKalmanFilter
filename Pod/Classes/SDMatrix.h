//
// Created by Marek Matulski on 09/06/15.
// Copyright (c) 2015 BladePolska. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SDMatrix : NSObject

@property (nonatomic) NSUInteger numberOfRows;      //N
@property (nonatomic) NSUInteger numberOfColumns;   //M

- (instancetype)initWithNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns;

+ (instancetype)matrixWithNumberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns;

- (void)makeIdentity;

@end