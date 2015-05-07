//
//  CLLocationManager+Addition.h
//  Quest
//
//  Created by Georgel Vintila on 07/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocationManager (Addition)

+(instancetype) locationManagerWithDelegate:(id<CLLocationManagerDelegate>) delegate;

@end
