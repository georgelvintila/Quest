//
//  QuestDetailsViewController.m
//  Quest
//
//  Created by Rares Neagu on 04/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestDetailsViewController.h"
#import <MapKit/MapKit.h>
#import "QuestItem.h"
#import "TakePhotoQuestItem.h"
#import "ViewPhotoQuestItem.h"
#import "CLLocationManager+Addition.h"
#import "QuestTakePhotoViewController.h"
#import "QuestViewPhotoViewController.h"
#import "CompletedQuestsManager.h"
@interface QuestDetailsViewController () <MKMapViewDelegate,CLLocationManagerDelegate>

#pragma mark - Properties

@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) CLLocationManager *manager;

@property (strong, nonatomic) MKCircle *circle;

@property (strong, nonatomic) UITapGestureRecognizer *tgr;

@property (assign, nonatomic) CGRect lastMapRect;
@property (strong, nonatomic) UIBarButtonItem *lastBarButtonItem;
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
    self.circle = [MKCircle circleWithCenterCoordinate:self.questInfo.questLocation.coordinate radius: 150];
    [self.map addOverlay:self.circle];
    
    // the logic
    [self.map showAnnotations:@[point] animated:YES];
    self.map.userTrackingMode = MKUserTrackingModeFollow;
    [self.manager startUpdatingLocation];
    
    self.tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMap)];
    [self.map addGestureRecognizer: self.tgr];
    self.lastMapRect = CGRectZero;
    self.map.autoresizesSubviews = NO;
    
}

- (void)tapMap {
    NSLog(@"tap map!");
    if (self.lastMapRect.size.width == 0 && self.lastMapRect.size.height == 0) {
        self.view.autoresizesSubviews = NO;
        self.lastMapRect = self.map.frame;
//        [self.view bringSubviewToFront:self.map];
        [UIView animateWithDuration:0.5 animations:^{
            self.map.frame = self.view.bounds;
            self.map.autoresizingMask = self.view.autoresizingMask;
        } completion:^(BOOL finished) {
            if (!finished)
                return;
            
            // again.. ?
            self.map.frame = self.view.bounds;
            
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
        
            self.lastBarButtonItem = self.navigationItem.leftBarButtonItem;
            self.navigationItem.leftBarButtonItem = backButton;
            self.navigationItem.title = @"Map";
        }];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.lastMapRect.size.width != 0 || self.lastMapRect.size.height != 0) {
        self.map.frame = self.view.bounds;
    }
}

- (void)actionBack {
    NSLog(@"action back!");
    [UIView animateWithDuration:0.5 animations:^{
        self.map.frame = self.lastMapRect;
    } completion:^(BOOL finished) {
        if (!finished)
            return;
        self.view.autoresizesSubviews = YES;
        self.navigationItem.leftBarButtonItem = self.lastBarButtonItem;
        self.lastBarButtonItem = nil;
        self.navigationItem.title = @"Quest Details";
        self.lastMapRect = CGRectZero;
    }];

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[CompletedQuestsManager sharedManager] objectForKeyedSubscript:self.questInfo.questObjectId]) {
        self.startButton.selected = NO;
        self.startButton.enabled = NO;
        [self.startButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self.startButton setTitle:@"QUEST COMPLETED" forState:UIControlStateDisabled];
    }
}

#pragma mark - MapView Delegate Methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay: overlay];
    if (!self.startButton.selected) {
        renderer.fillColor = [[UIColor redColor] colorWithAlphaComponent: 0.3];
    } else {
        renderer.fillColor = [[UIColor greenColor] colorWithAlphaComponent: 0.3];
    }
    return renderer;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    DLog(@"updated user location: %@", userLocation);
    double distance = [userLocation.location distanceFromLocation:self.questInfo.questLocation] * 2.3;
    DLog(@"distance: %.2f", distance);
   
    int radius = 15;
    if ([self.questInfo isMemberOfClass:[ViewPhotoQuestItem class]]) {
        radius = [((ViewPhotoQuestItem*)self.questInfo).questPhotoViewRadius intValue];
        NSLog(@"following the int value here: %u", radius);
    }
    
    if (distance / 2.3 < radius + MAX(userLocation.location.horizontalAccuracy, userLocation.location.verticalAccuracy) && self.startButton.enabled)
        self.startButton.selected = YES;
    else
        self.startButton.selected = NO;
    
    [self.map removeOverlay:self.circle];
    [self.map addOverlay:self.circle];

//    [self.map setCenterCoordinate: userLocation.coordinate animated:YES];
    [self.map setRegion: [self.map regionThatFits: MKCoordinateRegionMakeWithDistance(userLocation.coordinate, distance, distance)] animated: YES];

}

#pragma mark - Action Methods

- (IBAction)startQuestButtonClick:(UIButton *)sender {
    DLog(@"user clicked on the button, start the quest!");
    if (!sender.selected) {
        UIAlertController *alc = [UIAlertController alertControllerWithTitle:@"Get closer!" message:@"Please get within 150m to start the quest!" preferredStyle:UIAlertControllerStyleAlert];
        [alc addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alc dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alc animated:YES completion:nil];
        return;
    }
    if ([self.questInfo isMemberOfClass: [TakePhotoQuestItem class]]) {
        [self performSegueWithIdentifier: kStartQuestTakePhotoSegue sender:self];
    }
    if ([self.questInfo isMemberOfClass:[ViewPhotoQuestItem class]]) {
        [self performSegueWithIdentifier: kStartQuestViewPhotoSegue sender:self];
    }
    if (self.lastMapRect.size.width != 0 || self.lastMapRect.size.height != 0) {
        [self actionBack];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isMemberOfClass:[QuestTakePhotoViewController class]]) {
        QuestTakePhotoViewController *controller = (QuestTakePhotoViewController *)segue.destinationViewController;
        controller.questItem = (TakePhotoQuestItem *)self.questInfo;
    } else if ([segue.destinationViewController isMemberOfClass:[QuestViewPhotoViewController class]]){
        
        QuestViewPhotoViewController *controller = (QuestViewPhotoViewController *)segue.destinationViewController;
        controller.questItem = (ViewPhotoQuestItem *)self.questInfo;
    }
}

@end
