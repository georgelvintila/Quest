//
//  TakePhotoQuestInfo.h
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestItem.h"

@interface TakePhotoQuestItem : QuestItem

#pragma mark - Properties

@property (nonatomic) NSNumber *questPhotoAngle;
@property (nonatomic) NSNumber *questPhotoRadius;


@end
