//
// Created by Marek Matulski on 10/06/15.
// Copyright (c) 2015 BladePolska. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDMatrix;


@interface SDKalmanFilter : NSObject

@property (nonatomic, readonly) NSUInteger stateDimension;

@property (nonatomic, readonly) NSUInteger observationDimension;

@property (strong, nonatomic) SDMatrix *stateTransition;

@property (strong, nonatomic) SDMatrix *observationModel;

@property (strong, nonatomic) SDMatrix *processNoiseCovariance;

@property (strong, nonatomic) SDMatrix *observationNoiseCovariance;

@property (strong, nonatomic) SDMatrix *observation;

@property (strong, nonatomic) SDMatrix *predictedState;

@property (strong, nonatomic) SDMatrix *predictedEstimateCovariance;

@property (strong, nonatomic) SDMatrix *innovation;

@property (strong, nonatomic) SDMatrix *innovationCovariance;

@property (strong, nonatomic) SDMatrix *inverseInnovationCovariance;

@property (strong, nonatomic) SDMatrix *optimanlGain;

@property (strong, nonatomic) SDMatrix *stateEstimate;

@property (strong, nonatomic) SDMatrix *estimateCovariance;

@property (strong, nonatomic) SDMatrix *verticalScratch;

@property (strong, nonatomic) SDMatrix *smallSquareScratch;

@property (strong, nonatomic) SDMatrix *bigSquareScratch;

- (instancetype)initWithStateDimension:(NSUInteger)stateDimension observationDimension:(NSUInteger)observationDimension;

+ (instancetype)filterWithStateDimension:(NSUInteger)stateDimension observationDimension:(NSUInteger)observationDimension;

@end