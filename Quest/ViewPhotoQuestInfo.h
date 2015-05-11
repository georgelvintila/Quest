//
//  ViewPhotoQuestInfo.h
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QuestInfo.h"
#import "QuestImage.h"

@interface ViewPhotoQuestInfo : QuestInfo

#pragma mark - Properties

@property (nonatomic) NSNumber *questPhotoViewRadius;
@property (nonatomic) NSString *questPhotoMessage;
@property (nonatomic) QuestImage * questPhotoImage;
@property (nonatomic) BOOL hasImage;
@end
