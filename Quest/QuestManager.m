//
//  QuestManager.m
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestManager.h"
#import "PFObject+Quest.h"
#import "QuestSaveOperation.h"
#import "FetchQuestsOperation.h"


@interface QuestManager ()
{
    NSArray *typesList;
}
#pragma mark - Properties
@property (atomic,readwrite) NSMutableDictionary *myQuests;
@property (atomic,readwrite) NSMutableDictionary *otherQuests;
@property (nonatomic) NSOperationQueue* editOperationQueue;
@property (nonatomic) NSOperationQueue* fetchOperationQueue;

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
        _editOperationQueue = [NSOperationQueue new];
        _editOperationQueue.name = @"QuestQueue";
        _fetchOperationQueue = [NSOperationQueue new];
        _fetchOperationQueue.name = @"FetchQueue";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChanged:) name:kQuestQuerySuccesNotification object:nil];
    }
    return self;
}

#pragma mark - Property Methods

-(NSMutableDictionary *)otherQuests
{
    @synchronized(self)
    {
        return _otherQuests;
    }
}

-(void)setOtherQuests:(NSMutableDictionary *)otherQuests
{
    @synchronized(self)
    {
        if(_otherQuests != otherQuests)
            _otherQuests = otherQuests;
    }
}

-(NSMutableDictionary *)myQuests
{
    @synchronized(self)
    {
        return _myQuests;
    }
}

-(void)setMyQuests:(NSMutableDictionary *)myQuests
{
    @synchronized(self)
    {
        if(_myQuests != myQuests)
            _myQuests = myQuests;
    }
}

#pragma mark - Methods

-(void)dataChanged:(NSNotification *)notification
{
    NSMutableDictionary *source = nil;
    NSDictionary *userInfo =notification.userInfo;
    switch ([userInfo[kFetchOwner] integerValue])
    {
        case QuestOwnerTypeCurrent:
            source = self.myQuests;
            break;
        case QuestOwnerTypeOthers:
            source = self.otherQuests;
            break;
        default:
            break;
    }
    
    [source setValue:userInfo[kFetchItems] forKey:userInfo[kFetchType]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kQuestDataChangedNotification object:nil];
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
    QuestSaveOperation *saveOp = [[QuestSaveOperation alloc] initWithQuest:quest andQuestInfo:questInfo];
    [saveOp setCompletionBlock:^{
        [array insertObject:[quest questInfo] atIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kQuestDataChangedNotification object:nil];
        });
    }];
    [self.editOperationQueue addOperation:saveOp];
    
}

-(void)deleteQuestOfType:(NSString *)type atIndex:(NSUInteger) index
{
    NSMutableArray *array = [self.myQuests objectForKey:type];
    QuestInfo *info = [array objectAtIndex:index];
    Quest *quest = [self questWithId:info.questObjectId andType:type];
    [array removeObjectAtIndex:index];
    [quest delete];
    [[NSNotificationCenter defaultCenter] postNotificationName:kQuestDataChangedNotification object:nil];
}

-(void) updateQuestOfType:(NSString *)type atIndex:(NSUInteger) index withQuestInfo:(QuestInfo*)questInfo
{
    NSMutableArray *array = [self.myQuests objectForKey:type];
    QuestInfo *info = [array objectAtIndex:index];
    Quest *quest = [self questWithId:info.questObjectId andType:type];
    QuestSaveOperation *saveOp = [[QuestSaveOperation alloc] initWithQuest:quest andQuestInfo:questInfo];
    [saveOp setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kQuestDataChangedNotification object:nil];
        });
    }];
    [self.editOperationQueue addOperation:saveOp];
}

#pragma mark - Request Methods

-(void)requestAllItemsForOwner:(QuestOwnerType)questOwner
{
    for(NSString *type in typesList)
    {
        FetchQuestsOperation *fetch = [FetchQuestsOperation fetchQuestOperationWithType:type forOwner:questOwner];
        [self.fetchOperationQueue addOperation:fetch];
    }
}

-(void)requestItemsOfType:(NSString *)questType forOwner:(QuestOwnerType)questOwner
{
    FetchQuestsOperation *fetch = [FetchQuestsOperation fetchQuestOperationWithType:questType forOwner:questOwner];
    [self.fetchOperationQueue addOperation:fetch];
}

-(void)requestItemsOfType:(NSString *)questType forOwner:(QuestOwnerType)questOwner withLimit:(NSUInteger)limit
{
    FetchQuestsOperation *fetch = [FetchQuestsOperation fetchQuestOperationWithType:questType forOwner:questOwner withLimit:limit];
    [self.fetchOperationQueue addOperation:fetch];
}

-(void)requestItemsOfType:(NSString *)questType forOwner:(QuestOwnerType)questOwner withLimit:(NSUInteger)limit skipFirst:(NSUInteger) skip
{
    FetchQuestsOperation *fetch = [FetchQuestsOperation fetchQuestOperationWithType:questType forOwner:questOwner withLimit:limit skipFirst:skip];
    [self.fetchOperationQueue addOperation:fetch];
}

-(Quest *)questWithId:(NSString *)questId andType:(NSString*)questType
{
   return [[PFQuery queryWithClassName:questType] getObjectWithId:questId];
    
}

@end
