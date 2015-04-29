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


@interface ViewPhotoQuest : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic,readonly) NSNumber *viewRadius;

@property (nonatomic,readonly) NSString *message;

@property (nonatomic,readonly) PFFile *imageFile;

@property (nonatomic,readonly) UIImage *image;

@end
