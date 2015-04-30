//
//  Quest.m
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "TakePhotoQuest.h"
#import <Parse/PFObject+Subclass.h>

@implementation TakePhotoQuest

#pragma mark - Properties

@dynamic angle;
@dynamic radius;

#pragma mark - Class Methods

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return kQuestTypeTakePhotoQuest;
}

@end
