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

@property (nonatomic) QuestInfo *questInfo;
@property (nonatomic) Quest *quest;

@end

@implementation QuestSaveOperation

- (instancetype)initWithQuest:(id)quest andQuestInfo:(QuestInfo *)questInfo
{
    self = [super init];
    if (self) {
        _questInfo = questInfo;
        _quest = (Quest*)quest;
    }
    return self;
}

-(void)main
{
    @autoreleasepool
    {
        [self.quest saveQuestInformation:self.questInfo];
    }
}

@end
