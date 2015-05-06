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
                    if(self.questLocation)
                    {
                      [ self.mapButton setSelected:YES];
                    }
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
    if(location)
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
                self.takePhotoQuestInfo.questName = self.questNameText.text;
                self.takePhotoQuestInfo.questDetails = self.detailTextView.text;
                self.takePhotoQuestInfo.questLocation = self.questLocation;
                self.takePhotoQuestInfo.questPhotoAngle = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.angleStepper.value];
                self.takePhotoQuestInfo.questPhotoRadius = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.radiusSlider.value];
                BOOL complete = (self.takePhotoQuestInfo.questName.length && self.takePhotoQuestInfo.questDetails.length && self.takePhotoQuestInfo.questLocation != nil);
                self.takePhotoQuestInfo.questComplete = complete;
                [qmanager updateQuestOfType:kQuestTypeTakePhotoQuest atIndex:self.questIndex withQuestInfo:self.takePhotoQuestInfo];

            }
            else
            {
                self.takePhotoQuestInfo = [[TakePhotoQuestInfo alloc]init];
                self.takePhotoQuestInfo.questName = self.questNameText.text;
                self.takePhotoQuestInfo.questDetails = self.detailTextView.text;
                self.takePhotoQuestInfo.questLocation = self.questLocation;
                self.takePhotoQuestInfo.questPhotoAngle = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.angleStepper.value];
                self.takePhotoQuestInfo.questPhotoRadius = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.radiusSlider.value];
                BOOL complete = (self.takePhotoQuestInfo.questName.length && self.takePhotoQuestInfo.questDetails.length && self.takePhotoQuestInfo.questLocation != nil);
                self.takePhotoQuestInfo.questComplete = complete;
                if(self.takePhotoQuestInfo.questName.length || self.takePhotoQuestInfo.questDetails.length)
                    [qmanager addNewQuestWithType:kQuestTypeTakePhotoQuest andInfo:self.takePhotoQuestInfo];
            }
        }
            break;
            
        default:
            break;
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
