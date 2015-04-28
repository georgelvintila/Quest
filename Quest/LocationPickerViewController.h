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

@interface LocationPickerViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>


@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
