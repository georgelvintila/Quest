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

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.editMode = NO;
    }
    return self;
}


#pragma mark - Base Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.editMode) {
        switch (self.questType)
        {
                case QuestTypeTakePhoto:
                {
                    self.questNameText.text = self.takePhotoQuestInfo.questName;
                    self.detailTextView.text = self.takePhotoQuestInfo.questDetails;
                    self.questLocation = self.takePhotoQuestInfo.questLocation;
                    self.containerViewController.takePhotoQuestViewController.angleStepper.value = [self.takePhotoQuestInfo.questPhotoAngle doubleValue];
                    self.containerViewController.takePhotoQuestViewController.angleValue.text = [self.takePhotoQuestInfo.questPhotoAngle stringValue];
                    self.containerViewController.takePhotoQuestViewController.radiusSlider.value = [self.takePhotoQuestInfo.questPhotoRadius doubleValue];
                    self.containerViewController.takePhotoQuestViewController.radiusValue.text = [self.takePhotoQuestInfo.questPhotoRadius stringValue];
                }
                break;
                
                default:
                break;
        }
    }
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
    QuestManager *qmanager = [QuestManager sharedManager];
    qmanager = [QuestManager sharedManager];
    
    switch (self.questType)
    {
        case QuestTypeTakePhoto:
        {
            if (self.editMode)
            {
                [qmanager updateQuestOfType:kQuestTypeTakePhotoQuest atIndex:self.questIndex withQuestInfo:self.takePhotoQuestInfo];
                self.takePhotoQuestInfo.questName = self.questNameText.text;
                self.takePhotoQuestInfo.questDetails = self.detailTextView.text;
                self.takePhotoQuestInfo.questLocation = self.questLocation;
                self.takePhotoQuestInfo.questPhotoAngle = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.angleStepper.value];
                self.takePhotoQuestInfo.questPhotoRadius = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.radiusSlider.value];
            }
            
            else
            {
                self.takePhotoQuestInfo = [[TakePhotoQuestInfo alloc]init];
                self.takePhotoQuestInfo.questName = self.questNameText.text;
                self.takePhotoQuestInfo.questDetails = self.detailTextView.text;
                self.takePhotoQuestInfo.questLocation = self.questLocation;
                self.takePhotoQuestInfo.questPhotoAngle = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.angleStepper.value];
                self.takePhotoQuestInfo.questPhotoRadius = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.radiusSlider.value];
                [qmanager addNewQuestWithType:kQuestTypeTakePhotoQuest andInfo:self.takePhotoQuestInfo];
            }
        }
            break;
            
        default:
            break;
    }
    
    /*
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
    qmanager = [QuestManager sharedManager];
    [qmanager addNewQuestWithType:kQuestTypeTakePhotoQuest andInfo:info];
    */
    [self.navigationController popViewControllerAnimated:NO];
    
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
