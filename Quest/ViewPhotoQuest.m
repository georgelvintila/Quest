//
//  Quest.m
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "ViewPhotoQuest.h"
#import <Parse/PFObject+Subclass.h>
#import "ViewPhotoQuestItem.h"
#import "PFObject+Quest.h"
#import "QuestImage.h"

@implementation ViewPhotoQuest

#pragma mark - Properties

@dynamic viewRadius;
@dynamic imageFile;
@dynamic message;

#pragma mark - Class Methods

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return kQuestTypeViewPhotoQuest;
}

@end
