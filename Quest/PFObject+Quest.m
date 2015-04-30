//
//  PFObject+Quest.m
//  Quest
//
//  Created by Georgel Vintila on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "PFObject+Quest.h"

@implementation PFObject (Quest)

@dynamic name;
@dynamic details;
@dynamic owner;
@dynamic location;

-(CLLocation *)mapLocation
{
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:self.location.latitude longitude:self.location.longitude];
    return loc;
}


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
