//
//  ViewPhotoQuestInfo.m
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "ViewPhotoQuestItem.h"
#import "ViewPhotoQuest.h"

@interface QuestItem ()

#pragma mark - Properties

@property (nonatomic) ViewPhotoQuest *quest;

@end

@implementation ViewPhotoQuestItem
@dynamic quest;

#pragma mark - Property Methods

- (NSNumber *)questPhotoViewRadius {
    return self.quest[kQuestColumnViewPhotoViewRadius];
}

- (NSString *)questPhotoMessage {
    return self.quest[kQuestColumnViewPhotoMessage];
}


- (void)setQuestPhotoViewRadius:(NSNumber *)questPhotoViewRadius {
    if(questPhotoViewRadius)
        self.quest[kQuestColumnViewPhotoViewRadius] = questPhotoViewRadius;
}

- (void)setQuestPhotoMessage:(NSString *)questPhotoMessage {
    if(questPhotoMessage)
        self.quest[kQuestColumnViewPhotoMessage] = questPhotoMessage;
}


@end
