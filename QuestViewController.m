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
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self saveQuest];
    [super viewWillDisappear:animated];
}

#pragma mark - Location Picker View Controller Delegate Methods

-(void)locationPickerViewController:(LocationPickerViewController *)viewController saveLocation:(CLLocation *)location
{
    self.questLocation = location;
    [self.mapButton setSelected:YES];
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

#pragma mark - Action Methods

- (void)saveQuest
{
    TakePhotoQuestInfo *info = [[TakePhotoQuestInfo alloc] init];
    info.questName = self.questNameText.text;
    info.questDetails = self.detailTextView.text;
    info.questLocation = self.questLocation;
    
    BOOL complete = (info.questName.length && info.questDetails.length && info.questLocation != nil);
    info.questComplete = complete;
    
    info.questPhotoAngle = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.angleStepper.value];
    info.questPhotoRadius = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.radiusSlider.value];
    
    QuestManager *qmanager = [QuestManager sharedManager];
    if (self.questType == QuestTypeTakePhoto)
    {
        info.questPhotoAngle = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.angleStepper.value];
        info.questPhotoRadius = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.radiusSlider.value];
        qmanager = [QuestManager sharedManager];
        [qmanager addNewQuestWithType:kQuestTypeTakePhotoQuest andInfo:info];
    }
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
            if(self.questLocation)
                [locationPickerViewController setSavedLocation:self.questLocation];
            locationPickerViewController.delegate = self;
        }
}

#pragma mark - Instance Method


@end
