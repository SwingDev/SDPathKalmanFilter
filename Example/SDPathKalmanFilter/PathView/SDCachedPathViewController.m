//
// Created by Marek Matulski on 16/06/15.
// Copyright (c) 2015 Marek Matulski. All rights reserved.
//

#import "SDCachedPathViewController.h"
#import "SDDateUtils.h"


@implementation SDCachedPathViewController {

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadPath];

    [self filterPath];

    [self reloadView];
}

/*
    Load path (original points) from previously cached file.
 */
- (void)loadPath {
    self.originalLocations = [[NSMutableArray alloc] init];

    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"testpath.log"];
    NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    for(NSString *line in allLinedStrings){
        NSRange range = [line rangeOfString:@"POSITION:"];
        if(range.location == NSNotFound){
            continue;
        }

        NSUInteger rangeMaxIndex = range.location + range.length;
        NSString *lineInfo = [line substringFromIndex:rangeMaxIndex + 1];
        NSArray *components = [lineInfo componentsSeparatedByString:@"] ["];
        if([components count] > 2){
            NSString *dateStr = components[0];
            NSDate *date = [SDDateUtils dateFromString:dateStr];

            NSString * latStr = components[1];
            float lat = [latStr floatValue];

            NSString * lonStr = components[2];
            float lon = [lonStr floatValue];

            CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon)
                                                                 altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:date];
            [self.originalLocations addObject:location];
        }
    }
}

/*
    For all locations estimates more probable position and adds result to estimated locations array
 */
- (void)filterPath {
    self.estimatedLocations = [[NSMutableArray alloc] init];

    for(CLLocation *location in self.originalLocations){
        CLLocation *estimatedLocation = [self.pathKalmanFiler updateWithLocation:location];
        if(estimatedLocation){
            [self.estimatedLocations addObject:estimatedLocation];
        } else {
            DDLogWarn(@"Filter could not estimate location");
        }
    }
}

@end