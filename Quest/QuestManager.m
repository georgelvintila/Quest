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
#import "QuestFetchOperation.h"
#import "QuestDeleteOperation.h"


@interface QuestManager ()<QuestFetchOperationDelegate>
{
    NSArray *typesList;
}
#pragma mark - Properties
@property (atomic,readwrite) NSDictionary *questList;
@property (nonatomic) NSOperationQueue* editOperationQueue;
@property (nonatomic) NSOperationQueue* fetchOperationQueue;
@property (nonatomic) QuestOwnerType questOwner;

@end

#pragma mark -

@implementation QuestManager

#pragma mark - Properties

@synthesize questList = _questList;

#pragma mark - Instantition


- (instancetype)initWithOwner:(QuestOwnerType)questOwner
{
    self = [super init];
    if (self) {
        _questList = [NSDictionary new];
        _questOwner = questOwner;
        typesList = @[kQuestTypeTakePhotoQuest,kQuestTypeViewPhotoQuest];
        _editOperationQueue = [NSOperationQueue new];
        _editOperationQueue.name = @"QuestQueue";
        _fetchOperationQueue = [NSOperationQueue new];
        _fetchOperationQueue.name = @"FetchQueue";
        
    }
    return self;
}

#pragma mark - Property Methods

-(NSDictionary *)questList
{
    @synchronized(self)
    {
        return _questList;
    }
}

-(void)setQuestList:(NSDictionary *)questList
{
    @synchronized(self)
    {
        if(_questList != questList)
            _questList = questList;
    }
}


-(void)operation:(NSOperation *)operation finishedWithInfo:(NSDictionary *)userInfo
{
    NSMutableDictionary *source = [self.questList mutableCopy];
    [source setValue:userInfo[kFetchItems] forKey:userInfo[kFetchType]];
    self.questList = [NSDictionary dictionaryWithDictionary:source];
    
    [self.delegate updateQuestList];
}

#pragma mark - Methods


-(NSArray *)allQuestTypes
{
    return [self.questList.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

-(NSArray *)questListOfType:(NSString *)type
{
    return self.questList[type];
}

#pragma mark - Edit Methods

-(void)addNewQuestWithType:(NSString *)type andInfo:(QuestItem *)questInfo
{
    [questInfo saveQuestWithComplition:^{
        NSMutableArray *array = [self.questList objectForKey:type];
        [array insertObject:questInfo atIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate updateQuestList];
        });
    }];
    
}

-(void)deleteQuestOfType:(NSString *)type atIndex:(NSUInteger) index
{
    NSMutableArray *array = [self.questList objectForKey:type];
    QuestItem *questInfo = [array objectAtIndex:index];
    [questInfo deleteQuestWithComplition:^{
        [array removeObjectAtIndex:index];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate updateQuestList];
        });
    }];
}

-(void) updateQuestOfType:(NSString *)type atIndex:(NSUInteger) index withQuestInfo:(QuestItem*)questInfo
{
    [questInfo saveQuestWithComplition:^{
         NSMutableArray *array = [self.questList objectForKey:type];
        [array replaceObjectAtIndex:index withObject:questInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate updateQuestList];
        });
    }];
}

#pragma mark - Request Methods

-(void)requestAllItems
{
    for(NSString *type in typesList)
    {
        QuestFetchOperation *fetch = [QuestFetchOperation fetchQuestOperationWithType:type forOwner:self.questOwner];
        fetch.delegate = self;
        [self.fetchOperationQueue addOperation:fetch];
    }
}

-(void)requestItemsOfType:(NSString *)questType
{
    QuestFetchOperation *fetch = [QuestFetchOperation fetchQuestOperationWithType:questType forOwner:self.questOwner];
    fetch.delegate = self;
    [self.fetchOperationQueue addOperation:fetch];
}

-(void)requestItemsOfType:(NSString *)questType withLimit:(NSUInteger)limit
{
    QuestFetchOperation *fetch = [QuestFetchOperation fetchQuestOperationWithType:questType forOwner:self.questOwner withLimit:limit];
    fetch.delegate = self;
    [self.fetchOperationQueue addOperation:fetch];
}

-(void)requestItemsOfType:(NSString *)questType withLimit:(NSUInteger)limit skipFirst:(NSUInteger) skip
{
    QuestFetchOperation *fetch = [QuestFetchOperation fetchQuestOperationWithType:questType forOwner:self.questOwner withLimit:limit skipFirst:skip];
    fetch.delegate = self;
    [self.fetchOperationQueue addOperation:fetch];
}


@end
