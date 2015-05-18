//
//  ViewPhotoQuestInfo.h
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QuestItem.h"
#import "QuestImage.h"
@class ViewPhotoQuestItem;
@protocol ViewPhotoQuestItemDelegate <NSObject>

-(void)imageReceived:(UIImage*)image;

@end


@interface ViewPhotoQuestItem : QuestItem

#pragma mark - Properties

@property (nonatomic) NSNumber *questPhotoViewRadius;
@property (nonatomic) NSString *questPhotoMessage;
@property (nonatomic) UIImage *questPhotoImageSmall;
@property (nonatomic) BOOL hasImage;
@property (nonatomic,weak) id<ViewPhotoQuestItemDelegate> delegate;

-(void)addImageData:(NSData*)imageData;
-(void)requestImageData;

@end
