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
#import "TakePhotoQuestInfo.h"
#import "TakePhotoQuestViewController.h"

@interface QuestViewController : UIViewController<LocationPickerViewControllerDelegate>

#pragma mark - Properties

@property (weak, nonatomic) IBOutlet UITextField *questNameText;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIView *takePhotoContainer;

#pragma mark - Instance Methods

- (IBAction)saveQuest:(id)sender;
- (IBAction)chooseLocation:(id)sender;
- (IBAction)questTextChanged:(id)sender;


@end
