//
//  QuestDeleteOperation.m
//  Quest
//
//  Created by Georgel Vintila on 06/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestDeleteOperation.h"
#import "PFObject+Quest.h"


@interface QuestDeleteOperation ()

#pragma mark - Properties

@property (nonatomic) QuestInfo *oldInfo;
@property (nonatomic) NSString * questType;
@property (nonatomic) Quest *quest;


@end

#pragma mark -

@implementation QuestDeleteOperation

#pragma mark - Instantiation

- (instancetype)initWithOldQuestInfo:(QuestInfo *)oldInfo forType:(NSString*)type
{
    self = [super init];
    if (self) {
        _oldInfo = oldInfo;
        _questType = type;
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
        
        [self.quest delete];
        
    }
}


@end
