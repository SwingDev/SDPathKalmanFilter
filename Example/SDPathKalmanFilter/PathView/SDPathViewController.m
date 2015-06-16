//
// Created by Marek Matulski on 16/06/15.
// Copyright (c) 2015 Marek Matulski. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import <SDPathKalmanFilter/SDPathKalmanFilter.h>
#import "SDPathViewController.h"


@interface SDPathViewController ()

@property (strong, nonatomic) MKPolyline *originalPath;
@property (strong, nonatomic) MKPolyline *estimatedPath;

@end

@implementation SDPathViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.pathKalmanFiler = [[SDPathKalmanFilter alloc] init];
}

- (void)reloadView {
    [self showLocationsOnMap];
    [self showCorrectedLocationsOnMap];
    [self centerMap];
}

- (void)centerMap {
    if([self.originalLocations count] == 0){
        return;
    }

    MKCoordinateRegion region;

    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;

    for(NSUInteger idx = 0; idx < self.originalLocations.count; idx++)
    {
        CLLocation* currentLocation = self.originalLocations[idx];

        if(currentLocation.coordinate.latitude > maxLat)
            maxLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.latitude < minLat)
            minLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.longitude > maxLon)
            maxLon = currentLocation.coordinate.longitude;
        if(currentLocation.coordinate.longitude < minLon)
            minLon = currentLocation.coordinate.longitude;
    }

    for(NSUInteger idx = 0; idx < self.estimatedLocations.count; idx++)
    {
        CLLocation* currentLocation = self.estimatedLocations[idx];

        if(currentLocation.coordinate.latitude > maxLat)
            maxLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.latitude < minLat)
            minLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.longitude > maxLon)
            maxLon = currentLocation.coordinate.longitude;
        if(currentLocation.coordinate.longitude < minLon)
            minLon = currentLocation.coordinate.longitude;
    }

    region.center.latitude     = (maxLat + minLat) / 2;
    region.center.longitude    = (maxLon + minLon) / 2;
    region.span.latitudeDelta  = maxLat - minLat;
    region.span.longitudeDelta = maxLon - minLon;

    [self.mapView setRegion:region animated:YES];
}

- (void)showLocationsOnMap {
    NSUInteger numberOfSteps = [self.originalLocations count];

    CLLocationCoordinate2D coordinates[numberOfSteps];
    for(NSUInteger index=0;index<numberOfSteps;index++)
    {
        CLLocation *location = self.originalLocations[index];
        CLLocationCoordinate2D coordinate2 = location.coordinate;
        coordinates[index] = coordinate2;
    }

    self.originalPath = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];

    [self.mapView addOverlay:self.originalPath];
}

- (void)showCorrectedLocationsOnMap {
    NSUInteger numberOfSteps = [self.estimatedLocations count];

    CLLocationCoordinate2D coordinates[numberOfSteps];
    for(NSUInteger index=0;index<numberOfSteps;index++)
    {
        CLLocation *location = self.estimatedLocations[index];
        CLLocationCoordinate2D coordinate2 = location.coordinate;
        coordinates[index] = coordinate2;
    }

    self.estimatedPath = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
    [self.mapView addOverlay:self.estimatedPath];
}

- (void)compareLocations {
    __block NSUInteger i = 0;
    [[self.originalLocations mutableCopy] bk_each:^(CLLocation * location) {

        CLLocation *correctedLocation = self.estimatedLocations[i];
        NSString *info = @"";
        info = [info stringByAppendingFormat:@"[%@] [%f] [%f]",
                                             location.timestamp, location.coordinate.latitude - correctedLocation.coordinate.latitude,
                                             location.coordinate.longitude - correctedLocation.coordinate.longitude];

        DDLogDebug(@"COMPARE: %@", info);
        i++;
    }];
}

- (void)printLocation:(CLLocation *)location {
    NSString *info = @"";
    info = [info stringByAppendingFormat:@"[%@] [%f] [%f] [%f] [%f] [%f] [%f] [%f]",
                                         location.timestamp, location.coordinate.latitude, location.coordinate.longitude,
                                         location.horizontalAccuracy, location.verticalAccuracy,
                                         location.altitude, location.course, location.speed];

    DDLogInfo(@"POSITION: %@", info);
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKPolyline *route = overlay;
    MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
    routeRenderer.strokeColor = [overlay isEqual:self.originalPath] ?
            [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.3] : [UIColor redColor];
    routeRenderer.lineWidth = 1.0f;
    return routeRenderer;
}

@end