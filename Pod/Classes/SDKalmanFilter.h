//
// Created by Marek Matulski on 10/06/15.
// Copyright (c) 2015 BladePolska. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDMatrix;


@interface SDKalmanFilter : NSObject

@property (nonatomic, readonly) NSUInteger stateDimension;

@property (nonatomic, readonly) NSUInteger observationDimension;

@property (nonatomic, strong) SDMatrix *stateTransition;

@property (nonatomic, strong) SDMatrix *observationModel;

@property (nonatomic, strong) SDMatrix *processNoiseCovariance;

@property (nonatomic, strong) SDMatrix *observationNoiseCovariance;

@property (nonatomic, strong) SDMatrix *observation;

@property (nonatomic, strong) SDMatrix *predictedState;

@property (nonatomic, strong) SDMatrix *predictedEstimateCovariance;

@property (nonatomic, strong) SDMatrix *innovation;

@property (nonatomic, strong) SDMatrix *innovationCovariance;

@property (nonatomic, strong) SDMatrix *inverseInnovationCovariance;

@property (nonatomic, strong) SDMatrix *optimanlGain;

@property (nonatomic, strong) SDMatrix *stateEstimate;

@property (nonatomic, strong) SDMatrix *estimateCovariance;

@property (nonatomic, strong) SDMatrix *verticalScratch;

@property (nonatomic, strong) SDMatrix *smallSquareScratch;

@property (nonatomic, strong) SDMatrix *bigSquareScratch;

- (instancetype)initWithStateDimension:(NSUInteger)stateDimension observationDimension:(NSUInteger)observationDimension;

+ (instancetype)filterWithStateDimension:(NSUInteger)stateDimension observationDimension:(NSUInteger)observationDimension;

@end