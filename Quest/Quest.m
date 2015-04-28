//
//  Quest.m
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "Quest.h"

@implementation Quest

#pragma mark -
#pragma mark Properties

@synthesize questType = _questType;

#pragma mark -
#pragma mark Initialization

- (instancetype)initWithType:(NSString *)type
{
    self = [super initWithClassName:type];
    if (self) {
        _questType = type;
    }
    return self;
}

#pragma mark -
#pragma mark Property Methods

-(NSString *)name
{
    return [self objectForKey:kQuestColumnName];
}

-(CLLocation *)location
{
    PFGeoPoint *geoPoint = [self objectForKey:kQuestColumnLocation];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
    return loc;
}

-(NSString *)detail
{
    return [self objectForKey:kQuestColumnDetail];
}

-(NSString *)questType
{
    return _questType;
}

-(NSDictionary *)typeSpecificData
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if([self.questType isEqualToString:kQuestTypeTakePhoto])
    {
        [dict setObject:[self objectForKey:kQuestColumnTakePhotoAngle] forKey:kQuestColumnTakePhotoAngle];
        [dict setObject:[self objectForKey:kQuestColumnTakePhotoRadius] forKey:kQuestColumnTakePhotoRadius];
    }
    else
    {
        
    }
    return  [NSDictionary dictionaryWithDictionary:dict];
}

-(PFUser *)owner
{
    return [self objectForKey:kQuestColumnOwner];
}

#pragma mark -
#pragma mark Save Data

-(void)saveQuestInformation:(NSDictionary *)questInfo
{
    for (NSString *key in questInfo.allKeys) {
        if([key isEqualToString:kQuestColumnLocation])
        {
            CLLocation *loc = [questInfo objectForKey:key];
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
            [self setObject:[questInfo objectForKey:key]  forKey:key];
        }
    }
    [self saveInBackground];
}


@end
