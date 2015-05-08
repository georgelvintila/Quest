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
#import "PFObject+Quest.h"

@interface ViewPhotoQuest ()
{
    ViewPhotoQuestInfo *_questInfo;
}

@end

#pragma mark -

@implementation ViewPhotoQuest

#pragma mark - Properties

@dynamic viewRadius;
@dynamic imageFile;
@dynamic message;

#pragma mark - Property Methods

-(NSData *)image
{
    __block NSData *image = nil;
    
    [self.imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            image = imageData;
        }
    }];
    return image;
}

-(void)saveQuestInformation:(QuestInfo *)questInfo
{
    NSData *image = [[questInfo questDictionary] objectForKey:kQuestColumnViewPhotoImage];
    if(image)
    {
        ((ViewPhotoQuestInfo*)questInfo).questPhotoImage = [PFFile fileWithData:image];
    }
    [super saveQuestInformation:questInfo];
}

-(QuestInfo *)questInfo
{
    if(!_questInfo)
        _questInfo = [ViewPhotoQuestInfo new];
    
    _questInfo.questObjectId = self.objectId;
    _questInfo.questLocation = self.mapLocation;
    _questInfo.questName = self.name;
    _questInfo.questDetails = self.details;
    _questInfo.questPhotoImage = self.image;
    _questInfo.questPhotoMessage = self.message;
    _questInfo.questPhotoViewRadius = self.viewRadius;
    _questInfo.questComplete = [self.complete boolValue];
    
    return _questInfo;
}

#pragma mark - Class Methods

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return kQuestTypeViewPhotoQuest;
}

@end
