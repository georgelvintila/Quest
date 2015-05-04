//
//  LocationPickerViewController.m
//  Quest
//
//  Created by Mircea Eftimescu on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "LocationPickerViewController.h"

static CGFloat const filterDistance = 1000.0;

@interface LocationPickerViewController ()

#pragma mark - Properties

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL mapPannedSinceLocationUpdate;
@property (nonatomic, strong) MKPointAnnotation* annot;

@end

#pragma mark -

@implementation LocationPickerViewController

#pragma mark - Base Methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.locationManager startUpdatingLocation];
 
    self.tabBarController.tabBar.userInteractionEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.userInteractionEnabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }    
    self.mapPannedSinceLocationUpdate=NO;
    [self addLongPressGestureRecognizer];
    [self startStandardUpdates];
    
}

#pragma mark - Property Methods

- (void)setCurrentLocation:(CLLocation *)currentLocation {
    if (self.currentLocation == currentLocation) {
        return;
    }
    
    _currentLocation = currentLocation;
    
    if (!self.mapPannedSinceLocationUpdate) {
        // Set the map's region centered on their new location at 2x filterDistance
        MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, filterDistance * 2.0f, filterDistance * 2.0f);
        [self.mapView setRegion:newRegion animated:YES];
        self.mapPannedSinceLocationUpdate = NO;
    } // else do nothing.
}

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // Set a movement threshold for new events.
        _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    }
    return _locationManager;
}

#pragma mark - Gesture Methods

- (void)addLongPressGestureRecognizer
{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.5;
    [self.mapView addGestureRecognizer:lpgr];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    if (!self.annot)
    {
        self.annot = [[MKPointAnnotation alloc] init];
        self.annot.coordinate = touchMapCoordinate;
        [self.mapView addAnnotation:self.annot];
    }
    else
    {
        self.annot.coordinate = touchMapCoordinate;
    }
}

#pragma mark - MapView Delegate Methods

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    self.mapPannedSinceLocationUpdate = YES;
}

- (void)startStandardUpdates {
    [self.locationManager startUpdatingLocation];
    CLLocation *currentLocation = self.locationManager.location;
    if (currentLocation) {
        [self setCurrentLocation: currentLocation];
    }
}

#pragma mark - Location Manager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"kCLAuthorizationStatusAuthorized");
            // Re-enable the post button if it was disabled before.
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self.locationManager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            NSLog(@"kCLAuthorizationStatusDenied");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Quest can’t access your current location." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            // Disable the post button.
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"kCLAuthorizationStatusNotDetermined");
        }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"kCLAuthorizationStatusRestricted");
        }
            break;
        default:break;
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self setCurrentLocation: newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"Error: %@", [error description]);
    
    if (error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
    } else if (error.code == kCLErrorLocationUnknown) {
        // todo: retry?
        // set a timer for five seconds to cycle location, and if it fails again, bail and tell the user.
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

#pragma mark - Action Methods

- (IBAction)saveLocation:(id)sender{
    if (self.annot)
    {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.annot.coordinate.latitude longitude:self.annot.coordinate.longitude];
            if ([self.delegate respondsToSelector:@selector(locationPickerViewController:saveLocation:)])
            {
                [self.delegate locationPickerViewController:self saveLocation:location];
            }
    }
}

- (IBAction)deleteMarker:(id)sender {
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.annot = nil;
}

- (IBAction)switchUseLocation:(UISwitch*)sender {
    if (sender.isOn)
    {
        self.deleteButton.enabled = NO;
        self.mapView.userInteractionEnabled = NO;
        if ((self.mapPannedSinceLocationUpdate) && (self.currentLocation))
        {
            self.mapPannedSinceLocationUpdate = NO;
            MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, filterDistance * 2.0f, filterDistance * 2.0f);
            [self.mapView setRegion:newRegion animated:YES];
        }
    }
    else
    {
        self.deleteButton.enabled = YES;
        self.mapView.userInteractionEnabled = YES;
    }
}

@end
