//
//  LocationPickerViewController.m
//  Quest
//
//  Created by Mircea Eftimescu on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "LocationPickerViewController.h"
#import "CLLocationManager+Addition.h"

@interface LocationPickerViewController ()

#pragma mark - Properties

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL mapPannedSinceLocationUpdate;
@property (nonatomic, strong) MKPointAnnotation* annot;

@end

#pragma mark -

@implementation LocationPickerViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _locationManager = [CLLocationManager locationManagerWithDelegate:self];
    }
    return self;
}

#pragma mark - Base Class Methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }    
    self.mapPannedSinceLocationUpdate = NO;
    [self addLongPressGestureRecognizer];
    [self startStandardUpdates];
    if(self.savedLocation)
    {
        [self addAnnotationForSavedLocation];
        [self gotoLocation:self.savedLocation];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.delegate locationPickerViewController:self saveLocation:self.savedLocation];
    [self.locationManager stopUpdatingLocation];
    [super viewWillDisappear:animated];
}

#pragma mark - Property Methods

- (void)setCurrentLocation:(CLLocation *)currentLocation
{
    if (_currentLocation == currentLocation)
    {
        return;
    }
    
    _currentLocation = currentLocation;
    
    if (!self.mapPannedSinceLocationUpdate)
    {
        // Set the map's region centered on their new location at 2x filterDistance
        [self gotoLocation:_currentLocation];
        self.mapPannedSinceLocationUpdate = NO;
    } // else do nothing.
}

#pragma mark - Gesture Methods

- (void)addLongPressGestureRecognizer
{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.mapView addGestureRecognizer:lpgr];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    self.savedLocation = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [self addAnnotationForSavedLocation];
    [self gotoLocation:self.savedLocation];

}

#pragma mark - Instance Methods

-(void)addAnnotationForSavedLocation
{
    if (!self.annot)
    {
        self.annot = [[MKPointAnnotation alloc] init];
        self.annot.coordinate = self.savedLocation.coordinate;
        [self.mapView addAnnotation:self.annot];
    }
    else
    {
        [self.mapView removeAnnotation:self.annot];
        self.annot.coordinate = self.savedLocation.coordinate;
        [self.mapView addAnnotation:self.annot];
    }
}

- (void)startStandardUpdates
{
    [self.locationManager startUpdatingLocation];
    CLLocation *currentLocation = self.locationManager.location;
    if (currentLocation)
    {
        [self setCurrentLocation: currentLocation];
    }
}

-(void)gotoLocation:(CLLocation *)location
{
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, kFilterDistance * 2.0f, kFilterDistance * 2.0f);
    [self.mapView setRegion:newRegion animated:YES];

}

#pragma mark - MapView Delegate Methods

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    self.mapPannedSinceLocationUpdate = YES;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id ) annotation
{
    if([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        MKPinAnnotationView *newAnnotation = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
        if(!newAnnotation)
        {
            newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
        }
        newAnnotation.pinColor = MKPinAnnotationColorGreen;
        newAnnotation.animatesDrop = YES;
        newAnnotation.canShowCallout = NO;
        return newAnnotation;
    }
    return nil;
}

#pragma mark - Location Manager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            DLog(@"kCLAuthorizationStatusAuthorized");
            // Re-enable the post button if it was disabled before.
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self.locationManager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            DLog(@"kCLAuthorizationStatusDenied");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Quest can’t access your current location." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            // Disable the post button.
            self.navigationItem.rightBarButtonItem.enabled = NO;
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

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self setCurrentLocation: newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"Error: %@", [error description]);
    
    if (error.code == kCLErrorDenied)
    {
        [self.locationManager stopUpdatingLocation];
    }
    else
    {
        if (error.code == kCLErrorLocationUnknown)
        {
        // todo: retry?
        // set a timer for five seconds to cycle location, and if it fails again, bail and tell the user.
        }
        else
        {
            UIAlertController *controller = [UIAlertController  alertControllerWithTitle: @"Error retrieving location" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [controller addAction:action];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}

#pragma mark - Action Methods


- (IBAction)deleteMarker:(id)sender
{
    [self.mapView removeAnnotation:self.annot];
    self.annot = nil;
}

- (IBAction)switchUseLocation:(UISwitch*)sender
{
    if (sender.isOn)
    {
        self.clearButton.enabled = NO;
        self.mapView.userInteractionEnabled = NO;
        UIView *shadow = [[UIView alloc] initWithFrame:self.mapView.bounds];
        [shadow setBackgroundColor:[UIColor grayColor]];
        shadow.alpha = 0.3;
        [self.mapView addSubview:shadow];
         
        if ((self.mapPannedSinceLocationUpdate) && (self.currentLocation))
        {
            self.mapPannedSinceLocationUpdate = NO;
            [self gotoLocation:self.currentLocation];
            self.savedLocation = self.currentLocation;
            [self addAnnotationForSavedLocation];
        }
        
    }
    else
    {
        self.clearButton.enabled = YES;
        self.mapView.userInteractionEnabled = YES;
        [[self.mapView.subviews lastObject] removeFromSuperview];
    }
}

@end
