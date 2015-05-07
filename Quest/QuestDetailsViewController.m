//
//  QuestDetailsViewController.m
//  Quest
//
//  Created by Rares Neagu on 04/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestDetailsViewController.h"
#import <MapKit/MapKit.h>
#import "QuestInfo.h"
#import "CLLocationManager+Addition.h"

@interface QuestDetailsViewController () <MKMapViewDelegate,CLLocationManagerDelegate>

#pragma mark - Properties

@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) CLLocationManager *manager;

@end

#pragma mark -

@implementation QuestDetailsViewController

#pragma mark - Instantiation

- (instancetype)init {
    if (self = [super init]) {
        _manager = [CLLocationManager locationManagerWithDelegate:self];
    }
    return self;
}

#pragma mark - Base Class Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.titleText.text = self.questInfo.questName;

    self.descriptionText.selectable = YES;
    self.descriptionText.text = self.questInfo.questDetails;
    self.descriptionText.selectable = NO;

    // the pin
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = self.questInfo.questLocation.coordinate;
    point.title = self.questInfo.questName;
    
    // the radius
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.questInfo.questLocation.coordinate radius: 150];
    [self.map addOverlay:circle];
    
    // the logic
    [self.map showAnnotations:@[point] animated:YES];
    self.map.userTrackingMode = MKUserTrackingModeFollow;
    [self.manager startUpdatingLocation];
}

#pragma mark - MapView Delegate Methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay: overlay];
    renderer.fillColor = [[UIColor redColor] colorWithAlphaComponent: 0.3];
    return renderer;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    DLog(@"received update");
    if (self.map.userTrackingMode != MKUserTrackingModeFollow)
        return;
    DLog(@"updated user location: %@", userLocation);
    double distance = [userLocation.location distanceFromLocation:self.questInfo.questLocation] * 2;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, distance, distance);
    MKCoordinateRegion regionInMap = [self.map regionThatFits: region];
    [self.map setRegion: regionInMap animated: YES];
    

}

#pragma mark - Action Methods

- (IBAction)startQuestButtonClick:(id)sender {
    DLog(@"user clicked on the button, start the quest!");
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
