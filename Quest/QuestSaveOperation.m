//
//  QuestSaveOperation.m
//  Quest
//
//  Created by Georgel Vintila on 06/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestSaveOperation.h"
#import "PFObject+Quest.h"


@interface QuestSaveOperation ()

#pragma mark - Properties

@property (nonatomic) QuestInfo *oldInfo;
@property (nonatomic) QuestInfo *questInfo;
@property (nonatomic) NSString * questType;
@property (nonatomic) Quest *quest;

@end

#pragma mark -

@implementation QuestSaveOperation

#pragma mark - Instantiation Methods

- (instancetype)initWithOldQuestInfo:(QuestInfo *)oldInfo andNewQuestInfo:(QuestInfo *)newInfo forType:(NSString*)type
{
    self = [super init];
    if (self) {
        _oldInfo = oldInfo;
        _questInfo = newInfo;
        _questType = type;
    }
    return self;
}

-(instancetype)initWithQuest:(id)quest andQuestInfo:(QuestInfo *)questInfo
{
    self = [super init];
    if (self) {
        _quest = quest;
        _questInfo = questInfo;
    }
    return self;
}

#pragma mark - Main

-(void)main
{
    @autoreleasepool
    {
        if (!self.quest)
        {
            self.quest = [[PFQuery queryWithClassName:self.questType] getObjectWithId:self.oldInfo.questObjectId];
        }
        
        
        [self.quest saveQuestInformation:self.questInfo];
        
    }
}

@end
