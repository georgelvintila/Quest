//
//  FetchQuestsOperation.m
//  Quest
//
//  Created by Georgel Vintila on 06/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestFetchOperation.h"
#import <Parse/Parse.h>
#import "PFObject+Quest.h"
#import "UserManager.h"

@interface QuestFetchOperation ()

#pragma mark - Properties

@property(nonatomic) NSString *questType;
@property(nonatomic) QuestOwnerType questOwner;
@property(nonatomic) NSUInteger limit;
@property(nonatomic) NSUInteger skip;

@end

#pragma mark -

@implementation QuestFetchOperation

#pragma mark - Class Methods

+(instancetype)fetchQuestOperationWithType:(NSString *)questType forOwner:(QuestOwnerType)questOwner
{
    return [[QuestFetchOperation alloc]initWithType:questType forOwner:questOwner withLimit:-1 skipFirst:0];
}

+(instancetype)fetchQuestOperationWithType:(NSString *)questType forOwner:(QuestOwnerType)questOwner withLimit:(NSUInteger)limit
{
    return [[QuestFetchOperation alloc]initWithType:questType forOwner:questOwner withLimit:limit skipFirst:0];
}

+(instancetype)fetchQuestOperationWithType:(NSString *)questType forOwner:(QuestOwnerType)questOwner withLimit:(NSUInteger)limit skipFirst:(NSUInteger)skip
{
    return [[QuestFetchOperation alloc]initWithType:questType forOwner:questOwner withLimit:limit skipFirst:skip];
}

#pragma mark - Instantiation Methods

-(instancetype)initWithType:(NSString *)questType forOwner:(QuestOwnerType)questOwner withLimit:(NSUInteger)limit skipFirst:(NSUInteger)skip
{
    self = [super init];
    if (self) {
        _questOwner = questOwner;
        _questType = questType;
        _limit = limit;
        _skip = skip;
    }
    return self;
}

#pragma mark - Main

-(void)main
{
    @autoreleasepool {
        PFQuery *query = [PFQuery queryWithClassName:self.questType];
        PFUser *current =[PFUser currentUser];
        if(!current)
            return;
        switch (self.questOwner)
        {
            case QuestOwnerTypeCurrent:
            {
                [query whereKey:kQuestColumnOwner equalTo:current];
                break;
            }
            case QuestOwnerTypeOthers:
            {
                [query whereKey:kQuestColumnOwner notEqualTo:current];
                [query whereKey:kQuestColumnComplete notEqualTo:@0];
                CLLocation *location = [UserManager sharedManager].location;
                if(!location)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kQuestQueryNoLocationNotification object:self];
                    });
                    return;
                }
                PFGeoPoint * point = [PFGeoPoint geoPointWithLocation:location];
                [query whereKey:kQuestColumnLocation nearGeoPoint:point withinKilometers:3];
                break;
            }
            default:
                break;
        }
        
        [query orderByDescending:kQuestColumnUpdatedAt];
        query.limit = self.limit;
        query.skip = self.skip;
        
        NSArray *results = [query findObjects];
        NSMutableArray *quests = [NSMutableArray new];
        for (Quest *item  in results) {
            id q = [QuestItem questItemForQuest:item];
            [quests addObject:q];
            
        }
        NSDictionary *userInfo = @{kFetchType:self.questType,kFetchItems:quests, kFetchOwner:[NSNumber numberWithInteger:self.questOwner]};
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kQuestQuerySuccesNotification object:self userInfo:userInfo];
        });
    }
}

@end
