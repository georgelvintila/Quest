//
//  QuestViewController.m
//  Quest
//
//  Created by Mircea Eftimescu on 30/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestViewController.h"

@interface QuestViewController ()

#pragma mark - Properties

@property (nonatomic, strong) CLLocation *questLocation;
@property (nonatomic, strong) NSCharacterSet *blockedCharacterSet;

@property (nonatomic, strong) ContainerViewController *containerViewController;

@end

#pragma mark -

@implementation QuestViewController

#pragma mark - Base Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [self validateQuestInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location Picker View Controller Delegate Methods

-(void)locationPickerViewController:(LocationPickerViewController *)viewController saveLocation:(CLLocation *)location
{
    self.questLocation = location;
    [viewController.navigationController popViewControllerAnimated:YES];
    [self.mapButton setSelected:YES];
    [self validateQuestInfo];
}

#pragma mark - TextField Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)characters
{
    self.blockedCharacterSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([characters rangeOfCharacterFromSet:self.blockedCharacterSet].location == NSNotFound);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self validateQuestInfo];
}

#pragma mark - Action Methods

- (IBAction)saveQuest:(id)sender
{
    TakePhotoQuestInfo *info = [[TakePhotoQuestInfo alloc] init];
    info.questName = self.questNameText.text;
    info.questDetails = self.detailTextView.text;
    info.questLocation = self.questLocation;

    info.questPhotoAngle = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.angleStepper.value];
    info.questPhotoRadius = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.radiusSlider.value];
    
    QuestManager *qmanager = [QuestManager sharedManager];
    if (self.questType == TakePhoto)
    {
        info.questPhotoAngle = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.angleStepper.value];
        info.questPhotoRadius = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.radiusSlider.value];
        qmanager = [QuestManager sharedManager];
        [qmanager addNewQuestWithType:kQuestTypeTakePhotoQuest andInfo:info];
    }
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (IBAction)chooseLocation:(id)sender
{
    LocationPickerViewController *locationPickerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationPicker"];
    locationPickerViewController.delegate = self;
    [self.navigationController showViewController:locationPickerViewController sender:sender];
}

#pragma mark - Navigation Methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"ContainerSegue"])
    {
        self.containerViewController = (ContainerViewController *) [segue destinationViewController];
        self.containerViewController.questType = self.questType;
    }
    else
        if ([segueName isEqualToString: @"QuestToMapSegue"])
        {
            LocationPickerViewController *locationPickerViewController = (LocationPickerViewController *) [segue destinationViewController];
            locationPickerViewController.delegate = self;
        }
}

#pragma mark - Instance Method

-(void) validateQuestInfo
{
    if ((self.questNameText.text.length > 0) && self.questLocation)
    {
        self.saveButton.enabled = YES;
    }
    else
    {
        self.saveButton.enabled = NO;
    }
}

@end
