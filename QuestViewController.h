//
//  QuestViewController.h
//  Quest
//
//  Created by Mircea Eftimescu on 30/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationPickerViewController.h"
#import "QuestManager.h"
#import "ContainerViewController.h"
#import "TakePhotoQuestViewController.h"

@class QuestItem;

@interface QuestViewController : UIViewController<LocationPickerViewControllerDelegate,UITextFieldDelegate>

#pragma mark - Properties

@property (nonatomic) QuestType questType;
@property (nonatomic) NSInteger questIndex;
@property (nonatomic) BOOL editMode;
@property (nonatomic) QuestItem* questInfo;

@end
