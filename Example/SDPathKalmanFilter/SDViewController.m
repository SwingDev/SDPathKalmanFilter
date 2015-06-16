//
//  SDViewController.m
//  SDPathKalmanFilter
//
//  Created by Marek Matulski on 06/16/2015.
//  Copyright (c) 2014 Marek Matulski. All rights reserved.
//
#import "SDViewController.h"
#import <SDPathKalmanFilter/SDPathKalmanFilter.h>

@interface SDViewController ()

@property(strong, nonatomic) SDPathKalmanFilter *pathKalmanFiler;

@end

@implementation SDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.pathKalmanFiler = [[SDPathKalmanFilter alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
