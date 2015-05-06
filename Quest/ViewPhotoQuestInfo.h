//
//  ViewPhotoQuestInfo.h
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QuestInfo.h"

@interface ViewPhotoQuestInfo : QuestInfo

#pragma mark - Properties

@property (nonatomic) NSNumber *questPhotoViewRadius; // TODO: slider (asemantor cu TakePhoto)
@property (nonatomic) NSString *questPhotoMessage; // TODO: textfieldview
@property (nonatomic) id questPhotoImageFile; // TODO: button => add action picker (take photo & save / from gallery) (camera: popover controller)
@end
