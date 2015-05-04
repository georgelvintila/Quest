//
//  QuestDetailsViewController.m
//  Quest
//
//  Created by Rares Neagu on 04/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestDetailsViewController.h"
#import <MapKit/MapKit.h>
#import "TakePhotoQuestInfo.h"

@interface QuestDetailsViewController () <MKMapViewDelegate>
{
}
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation QuestDetailsViewController

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.questInfo == nil) {
        DLog(@"WARNING! NO QUEST INFO!");
        self.questInfo = [[TakePhotoQuestInfo alloc] init];
        self.questInfo.questName = @"NO QUEST NAME";
        self.questInfo.questDetails = @"quest details\nare totally missing\n\n\n\n\n...\n\n\n...\n\n\nbummer";
        self.questInfo.questLocation = [[CLLocation alloc] initWithLatitude: 47.0 longitude:24.4];
        self.questInfo.questPhotoRadius = @150000.0; // 150km

    }
    self.titleText.text = self.questInfo.questName;

    self.descriptionText.selectable = YES;
    self.descriptionText.text = self.questInfo.questDetails;
    self.descriptionText.selectable = NO;
    NSLog(@"%@", self.descriptionText);

    // the pin
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = self.questInfo.questLocation.coordinate;
    point.title = self.questInfo.questName;
    
    // the radius
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.questInfo.questLocation.coordinate radius:self.questInfo.questPhotoRadius.doubleValue];
    
    [self.map addOverlay:circle];
    
    // the logic
    
    self.map.showsUserLocation = YES;
    
    [self.map showAnnotations:@[point] animated:YES];

    self.map.userTrackingMode = MKUserTrackingModeFollow;
    
    
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay: overlay];
    renderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    renderer.fillColor = [[UIColor redColor] colorWithAlphaComponent: 0.3];
    return renderer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startQuestButtonClick:(id)sender {
    DLog(@"user clicked on the button, start the quest!");
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    DLog(@"received update");
    if (self.map.userTrackingMode != MKUserTrackingModeFollow)
        return;
    DLog(@"updated user location: %@", userLocation);
    double distance = [userLocation.location distanceFromLocation:self.questInfo.questLocation] * 2.3;

    [self.map setCenterCoordinate: userLocation.coordinate animated:YES];

    [self.map setRegion: [self.map regionThatFits: MKCoordinateRegionMakeWithDistance(self.map.centerCoordinate, distance, distance)] animated: YES];
 }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
