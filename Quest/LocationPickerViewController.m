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
@property (nonatomic, assign) BOOL mapPannedSinceLocationUpdate;
@property (nonatomic, strong) MKPointAnnotation* annot;

@end

#pragma mark -

@implementation LocationPickerViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

#pragma mark - Base Class Methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapPannedSinceLocationUpdate = NO;
    [self addLongPressGestureRecognizer];
    if(self.savedLocation)
    {
        [self addAnnotationForSavedLocation];
        [self gotoLocation:self.savedLocation];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationHasChanged:) name:kQuestUserLocationDidChangeNotification object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.delegate locationPickerViewController:self saveLocation:self.savedLocation];
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

#pragma mark - Action Methods

-(void)locationHasChanged:(NSNotification*)notification
{
    [self setCurrentLocation:[notification.userInfo objectForKey:kQuestCurrentLocation]];
}

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
