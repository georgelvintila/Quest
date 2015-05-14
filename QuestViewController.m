//
//  QuestViewController.m
//  Quest
//
//  Created by Mircea Eftimescu on 30/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestViewController.h"
#import "TakePhotoQuestInfo.h"
#import "ViewPhotoQuestInfo.h"

@interface QuestViewController ()
{
    BOOL isMapTransition;
}

#pragma mark - Properties

@property (nonatomic, strong) CLLocation *questLocation;
@property (nonatomic, strong) NSCharacterSet *blockedCharacterSet;
@property (nonatomic, strong) ContainerViewController *containerViewController;

@property (weak, nonatomic) IBOutlet UITextField *questNameText;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIView *takePhotoContainer;

@end

#pragma mark -

@implementation QuestViewController

#pragma mark - Instantiation

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _editMode = NO;
        isMapTransition = NO;
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
                    TakePhotoQuestInfo *info = (TakePhotoQuestInfo *)self.questInfo;
                    self.questNameText.text = info.questName;
                    self.detailTextView.text = info.questDetails;
                    self.questLocation = info.questLocation;
                    if(self.questLocation)
                    {
                        [self.mapButton setSelected:YES];
                    }
                    self.containerViewController.takePhotoQuestViewController.questAngle = [info.questPhotoAngle doubleValue];
                    self.containerViewController.takePhotoQuestViewController.questRadius = [info.questPhotoRadius doubleValue];
                }
                break;
                case QuestTypeViewPhoto:
                {
                    ViewPhotoQuestInfo *info = (ViewPhotoQuestInfo *)self.questInfo;
                    self.questNameText.text = info.questName;
                    self.detailTextView.text = info.questDetails;
                    self.questLocation = info.questLocation;
                    if(self.questLocation)
                    {
                        [ self.mapButton setSelected:YES];
                    }
                    self.containerViewController.viewPhotoViewController.viewPhotoRadius = [info.questPhotoViewRadius integerValue];
                    self.containerViewController.viewPhotoViewController.viewPhotoMessage = info.questPhotoMessage;
                }
                default:
                break;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(!isMapTransition)
        [self saveQuest];
    [super viewWillDisappear:animated];
}

#pragma mark - Location Picker View Controller Delegate Methods

-(void)locationPickerViewController:(LocationPickerViewController *)viewController saveLocation:(CLLocation *)location
{
    self.questLocation = location;
    if(location)
        [self.mapButton setSelected:YES];
    isMapTransition = NO;
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

-(IBAction)dismissKeyboard:(id)sender
{
    [self.questNameText resignFirstResponder];
    [self.detailTextView resignFirstResponder];
}

- (void)saveQuest
{
    QuestManager *qmanager = [QuestManager sharedManager];
    qmanager = [QuestManager sharedManager];
    
    switch (self.questType)
    {
        case QuestTypeTakePhoto:
        {
            if(!self.questInfo)
                self.questInfo = [[TakePhotoQuestInfo alloc]init];
            TakePhotoQuestInfo *info = (TakePhotoQuestInfo *)self.questInfo;
            
            info.questName = self.questNameText.text;
            info.questDetails = self.detailTextView.text;
            info.questLocation = self.questLocation;
            info.questPhotoAngle = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.questAngle];
            info.questPhotoRadius = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.questRadius];
            BOOL complete = (info.questName.length && info.questDetails.length && info.questLocation != nil);
            info.questComplete = complete;
            if(self.editMode)
            {
                [qmanager updateQuestOfType:kQuestTypeTakePhotoQuest atIndex:self.questIndex withQuestInfo:info];
            }
            else
            {
                if(info.questName.length || info.questDetails.length)
                    [qmanager addNewQuestWithType:kQuestTypeTakePhotoQuest andInfo:info];
            }
            break;
        }
        case QuestTypeViewPhoto:
        {
            if(!self.questInfo)
                self.questInfo = [[ViewPhotoQuestInfo alloc]init];
            ViewPhotoQuestInfo *info = (ViewPhotoQuestInfo *)self.questInfo;
            
            info.questName = self.questNameText.text;
            info.questDetails = self.detailTextView.text;
            info.questLocation = self.questLocation;
            
            info.questPhotoMessage = self.containerViewController.viewPhotoViewController.viewPhotoMessage;
            if(self.containerViewController.viewPhotoViewController.viewPhotoImage)
                info.questPhotoImage = [[QuestImage alloc] initWithData:self.containerViewController.viewPhotoViewController.viewPhotoImage];
            info.questPhotoViewRadius = [NSNumber numberWithInteger:self.containerViewController.viewPhotoViewController.viewPhotoRadius];
            
            BOOL complete = (info.questName.length && info.questDetails.length && info.questLocation != nil && info.questPhotoImage);
            info.questComplete = complete;
            if(self.editMode)
            {
                [qmanager updateQuestOfType:kQuestTypeViewPhotoQuest atIndex:self.questIndex withQuestInfo:info];
            }
            else
            {
                if(info.questName.length || info.questDetails.length)
                    [qmanager addNewQuestWithType:kQuestTypeViewPhotoQuest andInfo:info];
            }
            break;

        }
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
            isMapTransition = YES;
            LocationPickerViewController *locationPickerViewController = (LocationPickerViewController *) [segue destinationViewController];
            if(self.questLocation)
                [locationPickerViewController setSavedLocation:self.questLocation];
            locationPickerViewController.delegate = self;
        }
}

@end
