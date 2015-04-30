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

- (NSNumber *)questPhotoViewRadius {
    return self.dictionary[kQuestColumnViewPhotoViewRadius];
}

- (NSString *)questPhotoMessage {
    return self.dictionary[kQuestColumnViewPhotoMessage];
}

- (id)questPhotoImageFile {
    return self.dictionary[kQuestColumnViewPhotoImageFile];
}

- (void)setQuestPhotoViewRadius:(NSNumber *)questPhotoViewRadius {
    self.dictionary[kQuestColumnViewPhotoViewRadius] = questPhotoViewRadius;
}

- (void)setQuestPhotoMessage:(NSString *)questPhotoMessage {
    self.dictionary[kQuestColumnViewPhotoMessage] = questPhotoMessage;
}

- (void)setQuestPhotoImageFile:(id)questPhotoImageFile {
    self.dictionary[kQuestColumnViewPhotoImageFile] = questPhotoImageFile;
}

@end
