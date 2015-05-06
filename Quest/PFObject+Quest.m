//
//  PFObject+Quest.m
//  Quest
//
//  Created by Georgel Vintila on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "PFObject+Quest.h"
#import "PFGeoPoint+Addition.h"

@implementation PFObject (Quest)

#pragma mark - Properties

@dynamic name;
@dynamic details;
@dynamic owner;
@dynamic location;
@dynamic complete;

#pragma mark - Property Methods

-(CLLocation *)mapLocation
{
    if(self.location)
    {
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:self.location.latitude longitude:self.location.longitude];
        return loc;
    }
    return nil;
}

-(QuestInfo *)questInfo
{
    return nil;
}

#pragma mark - Instance Methods

-(void)saveQuestInformation:(QuestInfo *)questInfo
{
    BOOL save = NO;
    if(!self[kQuestColumnOwner])
    {
        [self setObject:[PFUser currentUser] forKey:kQuestColumnOwner];
        save = YES;
    }
    for (NSString *key in [questInfo questDictionary].allKeys) {
        if([key isEqualToString:kQuestColumnObjectId])
            continue;
        if([key isEqualToString:kQuestColumnLocation])
        {
            PFGeoPoint *  geoPoint =[PFGeoPoint geoPointWithLocation:[[questInfo questDictionary] objectForKey:key]];
            
            if(![[self objectForKey:key] isSamePoint:geoPoint])
            {
                [self setObject:geoPoint forKey:key];
                save = YES;
            }
        }
        else
        {
            if(![[[questInfo questDictionary] objectForKey:key] isEqual:self[key]])
            {
                [self setObject:[[questInfo questDictionary] objectForKey:key] forKey:key];
                save = YES;
            }
        }
    }
    if(save)
        [self saveEventually];
}
@end
