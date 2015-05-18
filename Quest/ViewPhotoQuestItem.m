//
//  ViewPhotoQuestInfo.m
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "ViewPhotoQuestItem.h"
#import "ViewPhotoQuest.h"

@interface QuestItem ()

#pragma mark - Properties

@property (nonatomic) ViewPhotoQuest *quest;

@end

@implementation ViewPhotoQuestItem
@dynamic quest;

- (instancetype)init
{
    self = [super initWithType:kQuestTypeViewPhotoQuest];
    if (self) {
    }
    return self;
}

#pragma mark - Property Methods

- (NSNumber *)questPhotoViewRadius {
    return self.quest[kQuestColumnViewPhotoViewRadius];
}

- (NSString *)questPhotoMessage {
    return self.quest[kQuestColumnViewPhotoMessage];
}


- (void)setQuestPhotoViewRadius:(NSNumber *)questPhotoViewRadius {
    if(questPhotoViewRadius)
        self.quest[kQuestColumnViewPhotoViewRadius] = questPhotoViewRadius;
}

- (void)setQuestPhotoMessage:(NSString *)questPhotoMessage {
    if(questPhotoMessage)
        self.quest[kQuestColumnViewPhotoMessage] = questPhotoMessage;
}

-(void)setQuestPhotoImageSmall:(UIImage *)questPhotoImageSmall
{
    if(questPhotoImageSmall)
        self.quest[kQuestColumnViewPhotoImage] = UIImagePNGRepresentation(questPhotoImageSmall);
}

-(UIImage *)questPhotoImageSmall
{   NSData *imageData  = self.quest[kQuestColumnViewPhotoImage];
    if(imageData)
        return [UIImage imageWithData:imageData];
    return nil;
}

-(void)addImageData:(NSData *)imageData
{
    PFFile *file  = [PFFile fileWithData:imageData];
    self.quest[kQuestColumnViewPhotoImageFile] = file;
}

- (void)requestImageData
{
    PFFile *imageFile = [self.quest valueForKey:kQuestColumnViewPhotoImageFile];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError * error)
    {
        UIImage * image = nil;
        if(error)
        {
            DLog(@"%@",error);
        }
        else
        {
            image = [UIImage imageWithData:data];
        }
        [self.delegate imageReceived:image];
    }];

}

@end
