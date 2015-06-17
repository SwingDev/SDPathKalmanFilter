//
// Created by Marek Matulski on 10/06/15.
// Copyright (c) 2015 BladePolska. All rights reserved.
//

#import "SDKalmanFilter.h"
#import "SDMatrix.h"


@implementation SDKalmanFilter {

}

- (instancetype)initWithStateDimension:(NSUInteger)stateDimension observationDimension:(NSUInteger)observationDimension {
    self = [super init];
    if (self) {
        _stateDimension = (stateDimension > 0 ? stateDimension : 1);

        _observationDimension = (observationDimension > 0 ? observationDimension : 1);


        _stateTransition = [SDMatrix matrixWithNumberOfRows:_stateDimension numberOfColumns:_stateDimension];
        [_stateTransition makeIdentity];

        _observationModel = [SDMatrix matrixWithNumberOfRows:_observationDimension numberOfColumns:_stateDimension];

        _processNoiseCovariance = [SDMatrix matrixWithNumberOfRows:_stateDimension numberOfColumns:_stateDimension];

        _observationNoiseCovariance = [SDMatrix matrixWithNumberOfRows:_observationDimension numberOfColumns:_observationDimension];

        _observationModel = [SDMatrix matrixWithNumberOfRows:_observationDimension numberOfColumns:1];

        _predictedState = [SDMatrix matrixWithNumberOfRows:_stateDimension numberOfColumns:1];

        _predictedEstimateCovariance = [SDMatrix matrixWithNumberOfRows:_stateDimension numberOfColumns:_stateDimension];

        _innovation = [SDMatrix matrixWithNumberOfRows:_observationDimension numberOfColumns:1];

        _innovationCovariance = [SDMatrix matrixWithNumberOfRows:_observationDimension numberOfColumns:_observationDimension];

        _inverseInnovationCovariance = [SDMatrix matrixWithNumberOfRows:_observationDimension numberOfColumns:_observationDimension];

        _optimanlGain = [SDMatrix matrixWithNumberOfRows:_stateDimension numberOfColumns:_observationDimension];

        _stateEstimate = [SDMatrix matrixWithNumberOfRows:_stateDimension numberOfColumns:1];

        _estimateCovariance = [SDMatrix matrixWithNumberOfRows:_stateDimension numberOfColumns:_stateDimension];


        _verticalScratch = [SDMatrix matrixWithNumberOfRows:_stateDimension numberOfColumns:_observationDimension];

        _smallSquareScratch = [SDMatrix matrixWithNumberOfRows:_observationDimension numberOfColumns:_observationDimension];

        _bigSquareScratch = [SDMatrix matrixWithNumberOfRows:_stateDimension numberOfColumns:_stateDimension];
    }

    return self;
}

+ (instancetype)filterWithStateDimension:(NSUInteger)stateDimension observationDimension:(NSUInteger)observationDimension {
    return [[self alloc] initWithStateDimension:stateDimension observationDimension:observationDimension];
}

- (void)update {
    [self predicate];
    [self estimate];
}

- (void)predicate {

    /* Predict the state */
    self.predictedState = [self.stateTransition multiplyWithMatrix:self.stateEstimate];

    /* Predict the state estimate covariance */
}

- (void)estimate {

}

@end