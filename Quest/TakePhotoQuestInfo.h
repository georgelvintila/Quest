//
//  TakePhotoQuestInfo.h
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestInfo.h"

@interface TakePhotoQuestInfo : QuestInfo

@property (nonatomic) NSString *questPhotoViewRadius;
@property (nonatomic) NSString *questPhotoMessage;
@property (nonatomic) NSString *questPhotoImageFile;

@end
