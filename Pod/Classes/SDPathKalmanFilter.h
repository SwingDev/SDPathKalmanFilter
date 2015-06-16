//
// Created by Marek Matulski on 09/06/15.
// Copyright (c) 2015 BladePolska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDKalmanFilter.h"

@class CLLocation;

@interface SDPathKalmanFilter : SDKalmanFilter

- (CLLocation *)updateWithLocation:(CLLocation *)location;

@end