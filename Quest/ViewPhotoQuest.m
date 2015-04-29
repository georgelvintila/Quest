//
//  Quest.m
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "ViewPhotoQuest.h"
#import <Parse/PFObject+Subclass.h>

@implementation ViewPhotoQuest

#pragma mark -
#pragma mark Properties

@dynamic viewRadius;
@dynamic imageFile;
@dynamic message;

-(UIImage *)image
{
    __block UIImage *image = nil;
    
    [self.imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            image = [UIImage imageWithData:imageData];
        }
    }];
    return image;
}

-(void)saveQuestInformation:(NSDictionary *)questInfo
{
    UIImage *image = [questInfo objectForKey:kQuestColumnViewPhotoImageFile];
    if(image)
    {
        NSData *imageData = UIImagePNGRepresentation(image);
        NSMutableDictionary *tempInfo = [questInfo mutableCopy];
        [tempInfo setValue:[PFFile fileWithData:imageData] forKey:kQuestColumnViewPhotoImageFile];
        questInfo = tempInfo;
    }
    [super saveQuestInformation:questInfo];
}
#pragma mark -
#pragma mark Class Methods

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return kQuestTypeViewPhotoQuest;
}

@end
