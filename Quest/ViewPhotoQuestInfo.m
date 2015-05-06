//
//  ViewPhotoQuestInfo.m
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "ViewPhotoQuestInfo.h"

@interface QuestInfo ()

#pragma mark - Properties

@property (nonatomic) NSMutableDictionary *dictionary;

@end

@implementation ViewPhotoQuestInfo

#pragma mark - Property Methods

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
    if(questPhotoViewRadius)
        self.dictionary[kQuestColumnViewPhotoViewRadius] = [questPhotoViewRadius copy];
}

- (void)setQuestPhotoMessage:(NSString *)questPhotoMessage {
    if(questPhotoMessage)
        self.dictionary[kQuestColumnViewPhotoMessage] = [questPhotoMessage copy];
}

- (void)setQuestPhotoImageFile:(id)questPhotoImageFile {
    if(questPhotoImageFile)
        self.dictionary[kQuestColumnViewPhotoImageFile] = [questPhotoImageFile copy];
}

@end
