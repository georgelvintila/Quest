//
//  QuestViewController.m
//  Quest
//
//  Created by Mircea Eftimescu on 30/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "EditQuestViewController.h"
#import "TakePhotoQuestItem.h"
#import "ViewPhotoQuestItem.h"

@interface EditQuestViewController ()
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

@implementation EditQuestViewController

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
                    TakePhotoQuestItem *item = (TakePhotoQuestItem *)self.questItem;
                    self.questNameText.text = item.questName;
                    self.detailTextView.text = item.questDetails;
                    self.questLocation = item.questLocation;
                    if(self.questLocation)
                    {
                        [self.mapButton setSelected:YES];
                    }
                    self.containerViewController.takePhotoQuestViewController.questAngle = [item.questPhotoAngle doubleValue];
                    self.containerViewController.takePhotoQuestViewController.questRadius = [item.questPhotoRadius doubleValue];
                }
                break;
                case QuestTypeViewPhoto:
                {
                    ViewPhotoQuestItem *item = (ViewPhotoQuestItem *)self.questItem;
                    self.questNameText.text = item.questName;
                    self.detailTextView.text = item.questDetails;
                    self.questLocation = item.questLocation;
                    if(self.questLocation)
                    {
                        [ self.mapButton setSelected:YES];
                    }
                    self.containerViewController.viewPhotoViewController.viewPhotoRadius = [item.questPhotoViewRadius integerValue];
                    self.containerViewController.viewPhotoViewController.viewPhotoMessage = item.questPhotoMessage;
                    self.containerViewController.viewPhotoViewController.viewPhotoImageSmall = item.questPhotoImageSmall;
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
    
    switch (self.questType)
    {
        case QuestTypeTakePhoto:
        {
            if(!self.questItem)
                self.questItem = [[TakePhotoQuestItem alloc]init];
            TakePhotoQuestItem *item = (TakePhotoQuestItem *)self.questItem;
            
            item.questName = self.questNameText.text;
            item.questDetails = self.detailTextView.text;
            item.questLocation = self.questLocation;
            item.questPhotoAngle = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.questAngle];
            item.questPhotoRadius = [NSNumber numberWithInteger:self.containerViewController.takePhotoQuestViewController.questRadius];
            BOOL complete = (item.questName.length && item.questDetails.length && item.questLocation != nil);
            item.questComplete = complete;
            if(self.editMode)
            {
                [self.delegate updateQuestItem:item ofType:kQuestTypeTakePhotoQuest];
            }
            else
            {
                if(item.questName.length || item.questDetails.length)
                    [self.delegate addQuestItem:item ofType:kQuestTypeTakePhotoQuest];
            }
            break;
        }
        case QuestTypeViewPhoto:
        {
            if(!self.questItem)
                self.questItem = [[ViewPhotoQuestItem alloc]init];
            ViewPhotoQuestItem *item = (ViewPhotoQuestItem *)self.questItem;
            
            item.questName = self.questNameText.text;
            item.questDetails = self.detailTextView.text;
            item.questLocation = self.questLocation;
            
            item.questPhotoMessage = self.containerViewController.viewPhotoViewController.viewPhotoMessage;
            item.questPhotoImageSmall = self.containerViewController.viewPhotoViewController.viewPhotoImageSmall;
            [item addImageData:self.containerViewController.viewPhotoViewController.viewPhotoImageData];
            item.questPhotoViewRadius = [NSNumber numberWithInteger:self.containerViewController.viewPhotoViewController.viewPhotoRadius];
            
            BOOL complete = (item.questName.length && item.questDetails.length && item.questLocation != nil && item.questPhotoImageSmall);
            item.questComplete = complete;
            if(self.editMode)
            {
                [self.delegate updateQuestItem:item ofType:kQuestTypeViewPhotoQuest];
            }
            else
            {
                if(item.questName.length || item.questDetails.length)
                {
                    [self.delegate addQuestItem:item ofType:kQuestTypeViewPhotoQuest];
                }
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
