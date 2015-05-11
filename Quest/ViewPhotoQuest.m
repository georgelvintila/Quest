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
#import "QuestImage.h"

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


-(void)saveQuestInformation:(QuestInfo *)questInfo
{
    NSData *image = ((ViewPhotoQuestInfo*)questInfo).questPhotoImage.imageData;
    if(image)
    {
        ((ViewPhotoQuestInfo*)questInfo).questPhotoImage = nil;
        [self setObject:[PFFile fileWithData:image] forKey:kQuestColumnViewPhotoImage];
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
    if(self.imageFile)
        _questInfo.questPhotoImage =  [[QuestImage alloc] initWithUrl:self.imageFile.url];
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
