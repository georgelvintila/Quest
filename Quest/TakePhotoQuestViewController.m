//
//  TakePhotoQuestViewController.m
//  Quest
//
//  Created by Mircea Eftimescu on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "TakePhotoQuestViewController.h"
#import "QuestManager.h"
#import "TakePhotoQuestInfo.h"

@interface TakePhotoQuestViewController () <UITextFieldDelegate>
@property (nonatomic, strong) CLLocation *questLocation;
@property (nonatomic, strong) NSCharacterSet *blockedCharacterSet;
@end

@implementation TakePhotoQuestViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)angleStepperValueChanged:(UIStepper*)sender {
    NSInteger intValue = sender.value;
    self.angleValue.text = [NSString stringWithFormat:@"%lu", intValue];
}

- (IBAction)radiusSliderValueChanged:(UISlider*)sender {
    NSInteger intValue = sender.value;
    self.radiusValue.text = [NSString stringWithFormat:@"%lu", intValue];
}

- (IBAction)saveQuest:(id)sender {
    
    TakePhotoQuestInfo *info = [[TakePhotoQuestInfo alloc] init];
    info.questName = self.questNameText.text;
    info.questDetails = self.detailTextView.text;
    info.questLocation = self.questLocation;
    info.questOwner = [PFUser currentUser];
    info.questPhotoAngle = [NSNumber numberWithInteger:self.angleStepper.value];
    info.questPhotoRadius = [NSNumber numberWithInteger:self.radiusSlider.value];
    
    QuestManager *qmanager = [QuestManager sharedManager];
    [qmanager addNewQuestWithType:kQuestTypeTakePhotoQuest andInfo:info];
    

}

- (IBAction)chooseLocation:(id)sender {
    LocationPickerViewController *locationPickerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationPicker"];
    locationPickerViewController.delegate = self;
    [self.navigationController showViewController:locationPickerViewController sender:sender];
}

- (IBAction)questTextChanged:(id)sender {
    [self validateTextFields];
}

-(void)locationPickerViewController:(LocationPickerViewController *)viewController saveLocation:(CLLocation *)location
{
    self.questLocation = location;
    [viewController.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)characters {
    self.blockedCharacterSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([characters rangeOfCharacterFromSet:self.blockedCharacterSet].location == NSNotFound);
}

- (BOOL)textView:(UITextField *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)characters {
    self.blockedCharacterSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([characters rangeOfCharacterFromSet:self.blockedCharacterSet].location == NSNotFound);
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self validateTextFields];
}

-(void) validateTextFields
{
    if ((self.questNameText.text.length>0)&&(self.detailTextView.text.length>0))
    {
        self.saveButton.enabled = YES;
    }
    else
    {
        self.saveButton.enabled = NO;
    }
}



@end
