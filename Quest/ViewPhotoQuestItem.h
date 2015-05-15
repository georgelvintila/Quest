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

@interface ViewPhotoQuestItem : QuestItem

#pragma mark - Properties

@property (nonatomic) NSNumber *questPhotoViewRadius;
@property (nonatomic) NSString *questPhotoMessage;
@property (nonatomic) UIImage * questPhotoImage;
@property (nonatomic) BOOL hasImage;
@end
