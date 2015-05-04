//
//  TakePhotoQuestInfo.m
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "TakePhotoQuestInfo.h"

@interface QuestInfo ()

#pragma mark - Properties

@property (nonatomic) NSMutableDictionary *dictionary;

#pragma mark -

@end

@implementation TakePhotoQuestInfo

#pragma mark - Property Methods

- (NSNumber *)questPhotoAngle {
    return self.dictionary[kQuestColumnTakePhotoAngle];
}

- (NSNumber *)questPhotoRadius {
    return self.dictionary[kQuestColumnTakePhotoRadius];
}

- (void)setQuestPhotoAngle:(NSNumber *)questPhotoAngle {
    if(questPhotoAngle)
        self.dictionary[kQuestColumnTakePhotoAngle] = questPhotoAngle;
}

- (void)setQuestPhotoRadius:(NSNumber *)questPhotoRadius {
    if(questPhotoRadius)
        self.dictionary[kQuestColumnTakePhotoRadius] = questPhotoRadius;
}

@end
