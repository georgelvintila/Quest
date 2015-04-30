//
//  TakePhotoQuestInfo.m
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "TakePhotoQuestInfo.h"

@interface QuestInfo ()

@property (nonatomic) NSMutableDictionary *dictionary;

@end

@implementation TakePhotoQuestInfo

- (NSNumber *)questPhotoAngle {
    return self.dictionary[kQuestColumnTakePhotoAngle];
}

- (NSNumber *)questPhotoRadius {
    return self.dictionary[kQuestColumnTakePhotoRadius];
}

- (void)setQuestPhotoAngle:(NSNumber *)questPhotoAngle {
    self.dictionary[kQuestColumnTakePhotoAngle] = questPhotoAngle;
}

- (void)setQuestPhotoRadius:(NSNumber *)questPhotoRadius {
    self.dictionary[kQuestColumnTakePhotoRadius] = questPhotoRadius;
}

@end
