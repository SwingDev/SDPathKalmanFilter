//
// Created by Marek Matulski on 09/06/15.
// Copyright (c) 2015 BladePolska. All rights reserved.
//

#import "SDPathKalmanFilter.h"
#import "SDMatrix.h"
#import <CoreLocation/CoreLocation.h>

// All units will be scalled with this value
static const double SDUnitsScaller = 1000.0;

@interface SDPathKalmanFilter ()

// Location for which last estimation was performed
@property(strong, nonatomic) CLLocation *lastInputLocation;

// Location for which estimation will be performed
@property(strong, nonatomic) CLLocation *currentInputLocation;

// Result of last estimation
@property(nonatomic, strong) CLLocation *lastEstimatedLocation;

@end

@implementation SDPathKalmanFilter {

}

- (instancetype)init {
    self = [super initWithStateDimension:4 observationDimension:2];
    if (self) {

    }

    return self;
}

- (CLLocation *)updateWithLocation:(CLLocation *)location{
    self.currentInputLocation = location;
    
    [self updateVelocity];
   
    return self.lastEstimatedLocation;
}

- (void)updateVelocity{
    NSTimeInterval timeSinceLastUpdate = 1.0f;
    if(self.lastInputLocation){
        timeSinceLastUpdate = [self.currentInputLocation.timestamp timeIntervalSince1970] - [self.lastInputLocation.timestamp timeIntervalSince1970];
    }

    [self updateStateTransitionMatrixWithTimeSinceLastUpdate:timeSinceLastUpdate];

    [self.observation setValue:self.currentInputLocation.coordinate.latitude n:0 m:0];
    [self.observation setValue:self.currentInputLocation.coordinate.longitude n:1 m:0];

    [self update];

    self.lastInputLocation = self.currentInputLocation;
    self.currentInputLocation = nil;
}

- (void)updateStateTransitionMatrixWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLastUpdate{
    [self.stateTransition setValue:timeSinceLastUpdate/SDUnitsScaller n:0 m:2];
    [self.stateTransition setValue:timeSinceLastUpdate/SDUnitsScaller n:1 m:3];
}

- (void)update{
    [self predicate];
    [self estimate];
}

- (void)predicate {

}

- (void)estimate {

}

@end