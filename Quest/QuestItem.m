//
//  QuestInfo.m
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestItem.h"
#import "PFObject+Quest.h"

@interface QuestItem ()

#pragma mark - Properties
@property (nonatomic) Quest *quest;

@end

#pragma mark -

@implementation QuestItem

#pragma mark - Properties

#pragma mark - Instantiation Methods

- (instancetype)initWithType:(NSString *)type
{
    self = [super init];
    if (self) {
        Class typeClass = NSClassFromString(type);
        
         _quest = [[typeClass alloc] init];
    }
    return self;
}

+ (QuestItem*)questItemForQuest:(id)quest;
{
    NSString* className =[((Quest*)quest).parseClassName stringByAppendingString:@"Item"];
    
    Class typeClass = NSClassFromString(className);
    QuestItem *newQuest = [[typeClass alloc] init];
    newQuest.quest = (Quest*)quest;
    return newQuest;
}

#pragma mark - Property Methods

- (void)setQuestName:(NSString *)questName {
    if(questName)
        self.quest[kQuestColumnName] = questName;
}

- (void)setQuestDetails:(NSString *)questDetails {
    if(questDetails)
        self.quest[kQuestColumnDetails] = questDetails;
}

- (void)setQuestLocation:(CLLocation*)questLocation {

    if(questLocation)
    {
        PFGeoPoint* point = [PFGeoPoint geoPointWithLocation:questLocation];
        self.quest[kQuestColumnLocation] = point;
    }
}

- (void)setQuestCreatedAt:(NSDate *)questCreatedAt {
    if(questCreatedAt)
        self.quest[kQuestColumnCreatedAt] = questCreatedAt;
}

- (void)setQuestUpdatedAt:(NSDate *)questUpdatedAt {
    if(questUpdatedAt)
        self.quest[kQuestColumnUpdatedAt] = questUpdatedAt;
}

- (void)setQuestObjectId:(NSString *)questObjectId {
    if(questObjectId)
        self.quest.objectId = questObjectId;
}

-(void)setQuestComplete:(BOOL)questComplete
{
    self.quest[kQuestColumnComplete] = [NSNumber numberWithInt:questComplete];
}

- (NSString *)questName {
    return self.quest[kQuestColumnName];
}

- (NSString *)questDetails {
    return self.quest[kQuestColumnDetails];
}

- (CLLocation*)questLocation {
    
    PFGeoPoint* point = self.quest[kQuestColumnLocation];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
    return location;
}

- (NSDate *)questCreatedAt {
    return self.quest[kQuestColumnCreatedAt];
}

- (NSDate *)questUpdatedAt {
    return self.quest[kQuestColumnUpdatedAt];
}

- (NSString *)questObjectId {
    return self.quest.objectId;
}

-(BOOL)questComplete
{
    return [self.quest[kQuestColumnComplete] boolValue];
}

#pragma mark - Instance Methods

-(void)saveQuestWithComplition:(void (^)(void))block
{
    if(!self.quest[kQuestColumnOwner])
    {
        self.quest[kQuestColumnOwner] = [PFUser currentUser];
    }
    [self.quest saveInBackgroundWithBlock:^(BOOL succeded, NSError *error)
     {
         if (!succeded) {
             DLog(@"%@",error);
         }
         else
         {
             block();
         }
     }];
}

-(void)deleteQuestWithComplition:(void (^)(void))block
{
    [self.quest deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!succeeded) {
             DLog(@"%@",error);
         }
         else
         {
             block();
         }
     }];
}

@end