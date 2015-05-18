//
//  QuestImageFetchOperation.m
//  Quest
//
//  Created by Georgel Vintila on 11/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestImageFetchOperation.h"
#import <Parse/Parse.h>

@interface QuestImageFetchOperation ()

#pragma mark - Properties

@property(nonatomic) NSString *questType;
@property(nonatomic) NSString *questId;

@end

#pragma mark -

@implementation QuestImageFetchOperation

#pragma mark - Instantiation

-(instancetype)initWithQuestType:(NSString *)questType andQuestId:(NSString *)questId
{
    self = [super init];
    if (self) {
        _questType = questType;
        _questId = questId;
    }
    return self;
}

#pragma mark - Main

-(void)main
{
    PFQuery *query= [PFQuery queryWithClassName:self.questType];
    PFObject * quest = [query getObjectWithId:self.questId];
    PFFile *imageFile = [quest valueForKey:kQuestColumnViewPhotoImageFile];
    NSError *error = nil;
    NSData *imageData = [imageFile getData:&error];
    if(error)
    {
        DLog(@"%@",error);
    }
    else
    {
        NSDictionary *userInfo = @{kQuestFetchImageDataKey:imageData};
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kQuestFetchSuccesImageData object:nil userInfo:userInfo];
        });
    }
    
}

@end
