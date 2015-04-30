//
//  Quest.h
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PFObject+Quest.h"


@interface TakePhotoQuest : PFObject<PFSubclassing>

#pragma mark -
#pragma mark Properties

@property (nonatomic,readonly) NSNumber *radius;

@property (nonatomic,readonly) NSNumber *angle;

#pragma mark -
#pragma mark Class Methods

+ (NSString *)parseClassName;

@end
