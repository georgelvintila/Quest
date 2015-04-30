//
//  PFObject+Quest.m
//  Quest
//
//  Created by Georgel Vintila on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "PFObject+Quest.h"

@implementation PFObject (Quest)

#pragma mark -
#pragma mark Properties

@dynamic name;
@dynamic details;
@dynamic owner;
@dynamic location;

#pragma mark -
#pragma mark Property Methods

-(CLLocation *)mapLocation
{
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:self.location.latitude longitude:self.location.longitude];
    return loc;
}

#pragma mark -
#pragma mark Instance Methods

-(void)saveQuestInformation:(QuestInfo *)questInfo
{
    for (NSString *key in [questInfo questDictionary].allKeys) {
        if([key isEqualToString:kQuestColumnLocation])
        {
            CLLocation *loc = [[questInfo questDictionary] objectForKey:key];
            PFGeoPoint *geoPoint = [self objectForKey:key];
            if(!geoPoint)
            {
                geoPoint =[PFGeoPoint geoPoint];
                [self setObject:geoPoint forKey:key];
            }
            [geoPoint setLatitude:loc.coordinate.latitude];
            [geoPoint setLongitude:loc.coordinate.longitude];
            
        }
        else
        {
            [self setObject:[[questInfo questDictionary] objectForKey:key]  forKey:key];
        }
    }
    [self save];
}
@end
