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

@class QuestInfo;

@interface QuestViewController : UIViewController<LocationPickerViewControllerDelegate,UITextFieldDelegate>

#pragma mark - Properties

@property (weak, nonatomic) IBOutlet UITextField *questNameText;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIView *takePhotoContainer;

@property (nonatomic) QuestType questType;
@property (nonatomic) NSInteger questIndex;
@property (nonatomic) BOOL editMode;
@property (nonatomic) QuestInfo* questInfo;

@end
