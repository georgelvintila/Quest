//
//  LocationPickerViewController.h
//  Quest
//
//  Created by Mircea Eftimescu on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol LocationPickerViewControllerDelegate;

@interface LocationPickerViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

- (IBAction)saveLocation:(id)sender;
- (IBAction)deleteMarker:(id)sender;
- (IBAction)switchUseLocation:(UISwitch*)sender;

@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@property (nonatomic, weak) id<LocationPickerViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@protocol LocationPickerViewControllerDelegate <NSObject>

- (void)locationPickerViewController:(LocationPickerViewController*) viewController
             saveLocation:(CLLocation*) location;

@end