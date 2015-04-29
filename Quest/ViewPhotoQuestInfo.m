//
//  ViewPhotoQuestInfo.m
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "ViewPhotoQuestInfo.h"

@interface QuestInfo ()

@property (nonatomic) NSMutableDictionary *dictionary;

@end

@implementation ViewPhotoQuestInfo

- (NSString *)questPhotoAngle {
    return self.dictionary[kQuestColumnTakePhotoAngle];
}

- (NSString *)questPhotoRadius {
    return self.dictionary[kQuestColumnTakePhotoRadius];
}

- (void)setQuestPhotoAngle:(NSString *)questPhotoAngle {
    self.dictionary[kQuestColumnTakePhotoAngle] = questPhotoAngle;
}

- (void)setQuestPhotoRadius:(NSString *)questPhotoRadius {
    self.dictionary[kQuestColumnTakePhotoRadius] = questPhotoRadius;
}

@end
