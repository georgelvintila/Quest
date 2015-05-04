//
//  Quest.m
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "TakePhotoQuest.h"
#import "TakePhotoQuestInfo.h"
#import <Parse/PFObject+Subclass.h>

@interface TakePhotoQuest ()
{
    TakePhotoQuestInfo *_questInfo;
}
@end

#pragma mark -

@implementation TakePhotoQuest

#pragma mark - Properties

@dynamic angle;
@dynamic radius;

#pragma mark - Property Methods

-(QuestInfo *)questInfo
{
    if(!_questInfo)
        _questInfo = [TakePhotoQuestInfo new];
    
    _questInfo.questLocation = self.mapLocation;
    _questInfo.questName = self.name;
    _questInfo.questDetails = self.details;
    _questInfo.questOwner = self.owner;
    _questInfo.questPhotoAngle = self.angle;
    _questInfo.questPhotoRadius = self.radius;
    
    return _questInfo;
}

#pragma mark - Class Methods

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return kQuestTypeTakePhotoQuest;
}

@end
