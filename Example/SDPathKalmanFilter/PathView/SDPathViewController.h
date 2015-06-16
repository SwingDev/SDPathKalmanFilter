//
// Created by Marek Matulski on 16/06/15.
// Copyright (c) 2015 Marek Matulski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <SDPathKalmanFilter/SDPathKalmanFilter.h>

/*
    This class is used for showing two paths:
    - first is original list of CLLocation points
    - second is result list of estimated CLLocation points
 */
@interface SDPathViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) SDPathKalmanFilter *pathKalmanFiler;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *originalLocations;
@property (strong, nonatomic) NSMutableArray *estimatedLocations;

- (void)reloadView;

@end