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
#pragma mark - Properties
@property (atomic,readwrite) NSMutableDictionary *myQuests;
@property (atomic,readwrite) NSMutableDictionary *otherQuests;

@end

#pragma mark -

@implementation QuestManager

#pragma mark - Properties

@synthesize myQuests = _myQuests;
@synthesize otherQuests = _otherQuests;

#pragma mark - Instantition

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

#pragma mark - Property Methods

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

#pragma mark - Methods

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

-(NSArray *)questListOfType:(NSString *)type forOwner:(QuestOwnerType)owner
{
    switch (owner) {
        case QuestOwnerTypeCurrent:
            return self.myQuests[type];
        case QuestOwnerTypeOthers:
            return self.otherQuests[type];
        case QuestOwnerTypeAll:
        {
            //lets hope we don't get to this
            NSArray *array  = [[self.myQuests[type] arrayByAddingObjectsFromArray:self.otherQuests[type]] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                Quest *first = (Quest*)obj1;
                Quest *second = (Quest*)obj2;
                return  ([first.updatedAt compare:second.updatedAt]);
            }];
            return array;
        }
        default:
            break;
    }
    return nil;
}

#pragma mark - Edit Methods

-(void)addNewQuestWithType:(NSString *)type andInfo:(QuestInfo *)questInfo
{
    NSMutableArray *array = [self.myQuests objectForKey:type];
    
    Class typeClass = NSClassFromString(type);
    
    Quest *quest = [[typeClass alloc] init];
    [quest saveQuestInformation:questInfo];
    [array addObject:quest];
    [[NSNotificationCenter defaultCenter] postNotificationName:kQuestDataChangedNotification object:nil];
}

-(void)deleteQuestOfType:(NSString *)type atIndex:(NSUInteger) index
{
    NSMutableArray *array = [self.myQuests objectForKey:type];
    Quest *quest = [array objectAtIndex:index];
    [array removeObjectAtIndex:index];
    [quest delete];
}

-(void) updateQuestOfType:(NSString *)type atIndex:(NSUInteger) index withQuestInfo:(QuestInfo*)questInfo
{
    NSMutableArray *array = [self.myQuests objectForKey:type];
    Quest *quest = [array objectAtIndex:index];
    [quest saveQuestInformation:questInfo];
}

#pragma mark - Request Methods

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
               [[NSNotificationCenter defaultCenter] postNotificationName:kQuestDataChangedNotification object:nil userInfo:userInfo];
           }
       }
    }];
}


@end
