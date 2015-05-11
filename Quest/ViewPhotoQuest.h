//
//  Quest.h
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Parse/Parse.h>



@interface ViewPhotoQuest : PFObject<PFSubclassing>

#pragma mark - Properties

@property (nonatomic,readonly) NSNumber *viewRadius;

@property (nonatomic,readonly) NSString *message;

@property (nonatomic,readonly) PFFile *imageFile;

#pragma mark - Class Methods

+ (NSString *)parseClassName;

@end
