//
//  PFGeoPoint+Compare.m
//  Quest
//
//  Created by Georgel Vintila on 06/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "PFGeoPoint+Addition.h"

@implementation PFGeoPoint (Addition)


-(BOOL)isSamePoint:(PFGeoPoint *)point
{
    return (self.latitude == point.latitude) && (self.longitude == point.longitude);
}

@end
