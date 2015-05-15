//
//  TakePhotoQuestInfo.m
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "TakePhotoQuestItem.h"
#import "TakePhotoQuest.h"

@interface QuestItem ()
#pragma mark - Properties

@property (nonatomic) TakePhotoQuest *quest;

#pragma mark -

@end

@implementation TakePhotoQuestItem
@dynamic quest;

- (instancetype)init
{
    self = [super initWithType:kQuestTypeTakePhotoQuest];
    if (self) {
        
    }
    return self;
}


#pragma mark - Property Methods

- (NSNumber *)questPhotoAngle {
    return self.quest[kQuestColumnTakePhotoAngle];
}

- (NSNumber *)questPhotoRadius {
    return self.quest[kQuestColumnTakePhotoRadius];
}

- (void)setQuestPhotoAngle:(NSNumber *)questPhotoAngle {
    if(questPhotoAngle)
        self.quest[kQuestColumnTakePhotoAngle] = questPhotoAngle;
}

- (void)setQuestPhotoRadius:(NSNumber *)questPhotoRadius {
    if(questPhotoRadius)
        self.quest[kQuestColumnTakePhotoRadius] = questPhotoRadius;
}

@end
