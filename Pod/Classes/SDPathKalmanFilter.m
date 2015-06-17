//
// Created by Marek Matulski on 09/06/15.
// Copyright (c) 2015 BladePolska. All rights reserved.
//

#import "SDPathKalmanFilter.h"
#import "SDMatrix.h"
#import <CoreLocation/CoreLocation.h>

// All units will be scalled with this value
static const double SDUnitsScaller = 1000.0;

static const double SDNoiseFactor = 0.000001;


@interface SDPathKalmanFilter ()

// Location for which last estimation was performed
@property (strong, nonatomic) CLLocation *lastInputLocation;

// Location for which estimation will be performed
@property (strong, nonatomic) CLLocation *currentInputLocation;

// Result of last estimation
@property (strong, nonatomic) CLLocation *lastEstimatedLocation;

@end

@implementation SDPathKalmanFilter {

}

- (instancetype)init {
    self = [super initWithStateDimension:4 observationDimension:2];
    if (self) {

        [self updateStateTransitionMatrixWithTimeSinceLastUpdate:1];

        [self.observationModel setValue:1 atRow:0 andColumn:0];
        [self.observationModel setValue:1 atRow:1 andColumn:1];

        /* Noise in the world. */
        [self.processNoiseCovariance makeIdentity];
        [self.processNoiseCovariance setValue:SDNoiseFactor atRow:0 andColumn:0];
        [self.processNoiseCovariance setValue:SDNoiseFactor atRow:1 andColumn:1];

        [self.observationNoiseCovariance makeIdentity];
        [self.observationNoiseCovariance scale:SDNoiseFactor * 120.0];

        double trillion = 1000.0 * 1000.0 * 1000.0 * 1000.0;
        [self.estimateCovariance makeIdentity];
        [self.estimateCovariance scale:trillion];
    }

    return self;
}

- (CLLocation *)updateWithLocation:(CLLocation *)location {
    self.currentInputLocation = location;
    
    [self updateVelocity];
   
    return self.lastEstimatedLocation;
}

- (void)updateVelocity {
    NSTimeInterval timeSinceLastUpdate = 1.0f;
    if(self.lastInputLocation){
        timeSinceLastUpdate = [self.currentInputLocation.timestamp timeIntervalSince1970] - [self.lastInputLocation.timestamp timeIntervalSince1970];
    }

    [self updateStateTransitionMatrixWithTimeSinceLastUpdate:timeSinceLastUpdate];

    [self.observation setValue:self.currentInputLocation.coordinate.latitude atRow:0 andColumn:0];
    [self.observation setValue:self.currentInputLocation.coordinate.longitude atRow:1 andColumn:0];

    [self update];

    self.lastInputLocation = self.currentInputLocation;
    self.currentInputLocation = nil;
}

- (void)updateStateTransitionMatrixWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLastUpdate {
    [self.stateTransition setValue:timeSinceLastUpdate / SDUnitsScaller atRow:0 andColumn:2];
    [self.stateTransition setValue:timeSinceLastUpdate / SDUnitsScaller atRow:1 andColumn:3];
}

@end