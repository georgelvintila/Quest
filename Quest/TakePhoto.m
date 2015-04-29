//
//  Quest.m
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "TakePhoto.h"
#import <Parse/PFObject+Subclass.h>

@implementation TakePhoto

#pragma mark -
#pragma mark Properties

@dynamic angle;
@dynamic radius;

#pragma mark -
#pragma mark Class Methods

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return kQuestTypeTakePhoto;
}

@end
