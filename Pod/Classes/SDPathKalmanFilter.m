//
// Created by Marek Matulski on 09/06/15.
// Copyright (c) 2015 BladePolska. All rights reserved.
//

#import "SDPathKalmanFilter.h"
#import "SDKalmanFilter.h"

static const double kUnitsScaller = 1000.0;

@implementation SDPathKalmanFilter {

}

- (instancetype)init {
    self = [super initWithStateDimension:4 observationDimension:2];
    if (self) {

    }

    return self;
}

- (void)setTimeDifference:(NSTimeInterval)timeDifference
{
    
}

@end