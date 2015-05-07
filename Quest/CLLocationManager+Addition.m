//
//  CLLocationManager+Addition.m
//  Quest
//
//  Created by Georgel Vintila on 07/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "CLLocationManager+Addition.h"

@implementation CLLocationManager (Addition)

+(instancetype)locationManagerWithDelegate:(id<CLLocationManagerDelegate>)delegate
{
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    manager.delegate = delegate;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    manager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    return manager;
}

@end
