//
//  QuestManager.m
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestManager.h"

@interface QuestManager ()

@property (atomic,readwrite) NSMutableDictionary *myQuests;

@end

@implementation QuestManager

#pragma mark -
#pragma mark Properties

@synthesize myQuests = _myQuests;

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
    }
    return self;
}

#pragma mark -
#pragma mark Properties

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


#pragma mark -
#pragma mark Edit Methods

-(void)addNewQuestWithType:(NSString *)type andInfo:(NSDictionary *)questInfo
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

-(void) updateQuestOfType:(NSString *)type atIndex:(NSUInteger) index withQuestInfo:(NSDictionary*)questInfo
{
    NSMutableArray *array = [self.myQuests objectForKey:type];
    PFObject *quest = [array objectAtIndex:index];
    [quest saveQuestInformation:questInfo];
}

#pragma mark -
#pragma mark Request Methods
-(void)requestMyQuests
{
    PFQuery *query = [PFQuery queryWithClassName:kQuestTypeTakePhoto];
//    [query whereKey:kQuestColumnOwner equalTo:[PFUser currentUser]];
    [query orderByDescending:kQuestColumnUpdatedAt];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
       if(error)
       {
           DLog(@"%@",error);
           [[NSNotificationCenter defaultCenter] postNotificationName:kMyQuestQueryFailureNotification object:nil];
       }
       else
       {
           [self.myQuests setObject:[results mutableCopy] forKey:kQuestTypeTakePhoto];
           [[NSNotificationCenter defaultCenter] postNotificationName:kMyQuestQuerySuccesNotification object:nil];
       }
    }];
}


@end
