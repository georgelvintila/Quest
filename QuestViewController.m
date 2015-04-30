//
//  QuestViewController.m
//  Quest
//
//  Created by Mircea Eftimescu on 30/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestViewController.h"

@interface QuestViewController ()
@property (nonatomic, strong) CLLocation *questLocation;
@property (nonatomic, strong) NSCharacterSet *blockedCharacterSet;
@property (nonatomic, strong) TakePhotoQuestViewController *takePhotoQuestViewController;
@end

@implementation QuestViewController

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

- (IBAction)saveQuest:(id)sender {
    
    TakePhotoQuestInfo *info = [[TakePhotoQuestInfo alloc] init];
    info.questName = self.questNameText.text;
    info.questDetails = self.detailTextView.text;
    info.questLocation = self.questLocation;
    info.questOwner = [PFUser currentUser];
    info.questPhotoAngle = [NSNumber numberWithInteger:self.takePhotoQuestViewController.angleStepper.value];
    info.questPhotoRadius = [NSNumber numberWithInteger:self.takePhotoQuestViewController.radiusSlider.value];
    
    QuestManager *qmanager = [QuestManager sharedManager];
    [qmanager addNewQuestWithType:kQuestTypeTakePhotoQuest andInfo:info];
    
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"alertview_embed"]) {
        self.takePhotoQuestViewController = (TakePhotoQuestViewController *) [segue destinationViewController];
        
        // do something with the AlertView's subviews here...
    }
}


@end
