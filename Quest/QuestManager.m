//
//  QuestManager.m
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestManager.h"

@interface QuestManager ()
{
    NSArray *typesList;
}

@property (atomic,readwrite) NSMutableDictionary *myQuests;
@property (atomic,readwrite) NSMutableDictionary *otherQuests;

@end

@implementation QuestManager

#pragma mark -
#pragma mark Properties

@synthesize myQuests = _myQuests;
@synthesize otherQuests = _otherQuests;
#pragma mark -
#pragma mark Instantition

+(instancetype)sharedManager
{
    static QuestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QuestManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _myQuests = [NSMutableDictionary new];
        _otherQuests = [NSMutableDictionary new];
        typesList = @[kQuestTypeTakePhotoQuest,kQuestTypeViewPhotoQuest];
    }
    return self;
}

#pragma mark -
#pragma mark Properties

-(NSMutableDictionary *)otherQuests
{
    @synchronized(_otherQuests)
    {
        return _otherQuests;
    }
}

-(void)setOtherQuests:(NSMutableDictionary *)otherQuests
{
    @synchronized(_otherQuests)
    {
        if(_otherQuests != otherQuests)
            _otherQuests = otherQuests;
    }
}

-(NSMutableDictionary *)myQuests
{
    @synchronized(_myQuests)
    {
        return _myQuests;
    }
}

-(void)setMyQuests:(NSMutableDictionary *)myQuests
{
    @synchronized(_myQuests)
    {
        if(_myQuests != myQuests)
            _myQuests = myQuests;
    }
}

-(NSArray *)allQuestTypesForOwner:(QuestOwnerType)owner
{
    switch (owner) {
        case QuestOwnerTypeCurrent:
            return [self.myQuests.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            break;
        case QuestOwnerTypeOthers:
            return [self.otherQuests.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            break;
        default:
            break;
    }
    return  nil;
}


#pragma mark -
#pragma mark Edit Methods

-(void)addNewQuestWithType:(NSString *)type andInfo:(QuestInfo *)questInfo
{
    NSMutableArray *array = [self.myQuests objectForKey:type];
    
    Class typeClass = NSClassFromString(type);
    
    PFObject *quest = [[typeClass alloc] init];
    [quest saveQuestInformation:questInfo];
    [array addObject:quest];
}

-(void)deleteQuestOfType:(NSString *)type atIndex:(NSUInteger) index
{
    NSMutableArray *array = [self.myQuests objectForKey:type];
    PFObject *quest = [array objectAtIndex:index];
    [array removeObjectAtIndex:index];
    [quest delete];
}

-(void) updateQuestOfType:(NSString *)type atIndex:(NSUInteger) index withQuestInfo:(QuestInfo*)questInfo
{
    NSMutableArray *array = [self.myQuests objectForKey:type];
    PFObject *quest = [array objectAtIndex:index];
    [quest saveQuestInformation:questInfo];
}

#pragma mark -
#pragma mark Request Methods

-(void)requestAllItemsForOwner:(QuestOwnerType)questOwner
{
    for(NSString *type in typesList)
        [self requestItemsOfType:type forOwner:questOwner withLimit:-1 skipFirst:0];
}

-(void)requestItemsOfType:(NSString *)questType forOwner:(QuestOwnerType)questOwner
{
    [self requestItemsOfType:questType forOwner:questOwner withLimit:-1 skipFirst:0];
}

-(void)requestItemsOfType:(NSString *)questType forOwner:(QuestOwnerType)questOwner withLimit:(NSUInteger)limit
{
    [self requestItemsOfType:questType forOwner:questOwner withLimit:limit skipFirst:0];
}

-(void)requestItemsOfType:(NSString *)questType forOwner:(QuestOwnerType)questOwner withLimit:(NSUInteger)limit skipFirst:(NSUInteger) skip
{
    PFQuery *query = [PFQuery queryWithClassName:questType];
    __block NSMutableDictionary *source = nil;
    switch (questOwner)
    {
        case QuestOwnerTypeCurrent:
            [query whereKey:kQuestColumnOwner equalTo:[PFUser currentUser]];
            source = self.myQuests;
            break;
        case QuestOwnerTypeOthers:
            [query whereKey:kQuestColumnOwner notEqualTo:[PFUser currentUser]];
            source = self.otherQuests;
            break;
        default:
            break;
    }
    
    [query orderByDescending:kQuestColumnUpdatedAt];
    query.limit = limit;
    query.skip = skip;
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
       if(error)
       {
           DLog(@"%@",error);
           [[NSNotificationCenter defaultCenter] postNotificationName:kMyQuestQueryFailureNotification object:nil];
       }
       else
       {
           if([results count])
           {
               [source setObject:[results mutableCopy] forKey:questType];
               NSDictionary *userInfo = @{@"owner":[NSNumber numberWithInteger:questOwner]};
               [[NSNotificationCenter defaultCenter] postNotificationName:kMyQuestQuerySuccesNotification object:nil userInfo:userInfo];
           }
       }
    }];
}


@end
