//
//  UserManager.m
//  Quest
//
//  Created by Georgel Vintila on 04/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "UserManager.h"
#import <Parse/Parse.h>
#import "CLLocationManager+Addition.h"

@interface UserManager ()<CLLocationManagerDelegate>

@property(nonatomic) CLLocationManager *locationManager;
@property(atomic,readwrite) CLLocation *location;

@end

@implementation UserManager

@synthesize location = _location;

#pragma mark - Instantition

+(instancetype)sharedManager
{
    static UserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager locationManagerWithDelegate:self];
    }
    return self;
}

-(void)dealloc
{
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            DLog(@"kCLAuthorizationStatusAuthorized");
            [self.locationManager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            DLog(@"kCLAuthorizationStatusDenied");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Quest can’t access your current location." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            DLog(@"kCLAuthorizationStatusNotDetermined");
        }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            DLog(@"kCLAuthorizationStatusRestricted");
        }
            break;
        default:break;
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self setLocation:[locations objectAtIndex:0]];
}

-(void)setLocation:(CLLocation *)location
{
    @synchronized(self)
    {
        if(_location != location)
        {
            _location = location;
        }
    }
}

-(CLLocation *)location
{
    @synchronized(self)
    {
        return _location;
    }
}

@end
