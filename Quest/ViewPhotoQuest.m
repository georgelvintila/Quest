//
//  Quest.m
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "ViewPhotoQuest.h"
#import <Parse/PFObject+Subclass.h>
#import "ViewPhotoQuestInfo.h"

@implementation ViewPhotoQuest

#pragma mark -
#pragma mark Properties

@dynamic viewRadius;
@dynamic imageFile;
@dynamic message;

#pragma mark -
#pragma mark Property Methods

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

-(void)saveQuestInformation:(QuestInfo *)questInfo
{
    UIImage *image = [[questInfo questDictionary] objectForKey:kQuestColumnViewPhotoImageFile];
    if(image)
    {
        NSData *imageData = UIImagePNGRepresentation(image);
        ((ViewPhotoQuestInfo*)questInfo).questPhotoImageFile = [PFFile fileWithData:imageData];
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
