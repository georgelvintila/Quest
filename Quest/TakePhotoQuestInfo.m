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

- (NSString *)questPhotoViewRadius {
    return self.dictionary[kQuestColumnViewPhotoViewRadius];
}

- (NSString *)questPhotoMessage {
    return self.dictionary[kQuestColumnViewPhotoMessage];
}

- (NSString *)questPhotoImageFile {
    return self.dictionary[kQuestColumnViewPhotoImageFile];
}

- (void)setQuestPhotoViewRadius:(NSString *)questPhotoViewRadius {
    self.dictionary[kQuestColumnViewPhotoViewRadius] = questPhotoViewRadius;
}

- (void)setQuestPhotoMessage:(NSString *)questPhotoMessage {
    self.dictionary[kQuestColumnViewPhotoMessage] = questPhotoMessage;
}

- (void)setQuestPhotoImageFile:(NSString *)questPhotoImageFile {
    self.dictionary[kQuestColumnViewPhotoImageFile] = questPhotoImageFile;
}

@end
