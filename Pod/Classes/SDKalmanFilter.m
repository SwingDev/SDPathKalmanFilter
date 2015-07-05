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

        _observation = [SDMatrix matrixWithNumberOfRows:_observationDimension numberOfColumns:1];

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
    self.predictedState = [self.stateTransition matrixByMultiplicationWithMatrix:self.stateEstimate];

    /* Predict the state estimate covariance */
    self.bigSquareScratch = [self.stateTransition matrixByMultiplicationWithMatrix:self.estimateCovariance];
    self.predictedEstimateCovariance = [self.bigSquareScratch matrixByMultiplicationWithTransposedMatrix:self.stateTransition];
    [self.predictedEstimateCovariance addMatrix:self.processNoiseCovariance];
}

- (void)estimate {

    /* Calculate innovation */
    self.innovation = [self.observationModel matrixByMultiplicationWithMatrix:self.predictedState];
    self.innovation = [self.observation matrixBySubtractionOfMatrix:self.innovation];

    /* Calculate innovation covariance */
    self.verticalScratch = [self.predictedEstimateCovariance matrixByMultiplicationWithTransposedMatrix:self.observationModel];
    self.innovationCovariance = [self.observationModel matrixByMultiplicationWithMatrix:self.verticalScratch];
    [self.innovationCovariance addMatrix:self.observationNoiseCovariance];

    /* Invert the innovation covariance.*/
    self.inverseInnovationCovariance = [self.innovationCovariance matrixByInvertion];

    /* Calculate the optimal Kalman gain.*/
    self.optimanlGain = [self.verticalScratch matrixByMultiplicationWithMatrix:self.inverseInnovationCovariance];
    self.stateEstimate = [self.optimanlGain matrixByMultiplicationWithMatrix:self.innovation];
    [self.stateEstimate addMatrix:self.predictedState];

    /* Estimate the state covariance */
    self.bigSquareScratch = [self.optimanlGain matrixByMultiplicationWithMatrix:self.observationModel];

    SDMatrix *identityMatrix = [self.bigSquareScratch copy];
    [identityMatrix makeIdentity];
    self.bigSquareScratch = [identityMatrix matrixBySubtractionOfMatrix:self.bigSquareScratch];

    self.estimateCovariance = [self.bigSquareScratch matrixByMultiplicationWithMatrix:self.predictedEstimateCovariance];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];

    [description appendString:@">"];
    [description appendFormat:@"\nstateTransition --> %@", self.stateTransition];
    [description appendFormat:@"\nobservationModel --> %@", self.observationModel];
    [description appendFormat:@"\nprocessNoiseCovariance --> %@", self.processNoiseCovariance];
    [description appendFormat:@"\nobservationNoiseCovariance --> %@", self.observationNoiseCovariance];
    [description appendFormat:@"\nobservation --> %@", self.observation];
    [description appendFormat:@"\npredictedState --> %@", self.predictedState];
    [description appendFormat:@"\npredictedEstimateCovariance --> %@", self.predictedEstimateCovariance];
    [description appendFormat:@"\ninnovation --> %@", self.innovation];
    [description appendFormat:@"\ninnovationCovariance --> %@", self.innovationCovariance];
    [description appendFormat:@"\ninverseInnovationCovariance --> %@", self.inverseInnovationCovariance];
    [description appendFormat:@"\noptimanlGain --> %@", self.optimanlGain];
    [description appendFormat:@"\nstateEstimate --> %@", self.stateEstimate];
    [description appendFormat:@"\nestimateCovariance --> %@", self.estimateCovariance];
    [description appendFormat:@"\verticalScratch --> %@", self.verticalScratch];
    [description appendFormat:@"\nsmallSquareScratch --> %@", self.smallSquareScratch];
    [description appendFormat:@"\nbigSquareScratch --> %@", self.bigSquareScratch];

    return description;
}

@end