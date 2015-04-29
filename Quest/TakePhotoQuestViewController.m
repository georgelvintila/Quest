//
//  TakePhotoQuestViewController.m
//  Quest
//
//  Created by Mircea Eftimescu on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "TakePhotoQuestViewController.h"
#import "QuestManager.h"

@interface TakePhotoQuestViewController ()
@property (nonatomic, strong) CLLocation *questLocation;
@end

@implementation TakePhotoQuestViewController
@synthesize angleValue, radiusValue, questLocation, angleStepper, radiusSlider,questNameText,detailTextView;

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
    angleValue.text = [NSString stringWithFormat:@"%d", intValue];
}

- (IBAction)radiusSliderValueChanged:(UISlider*)sender {
    NSInteger intValue = sender.value;
    radiusValue.text = [NSString stringWithFormat:@"%d", intValue];
}

- (IBAction)saveQuest:(id)sender {
    
    NSDictionary *nsDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                            [[NSString alloc] initWithString:questNameText.text], kQuestColumnName,
                            [[NSString alloc] initWithString:detailTextView.text], kQuestColumnDetail,
                            questLocation, kQuestColumnLocation,
                            [NSNumber numberWithInteger:angleStepper.value], kQuestColumnTakePhotoAngle,
                            [NSNumber numberWithInteger:radiusSlider.value], kQuestColumnTakePhotoRadius, nil];
    
    
    QuestManager *qmanager = [QuestManager sharedManager];
    [qmanager addNewQuestWithType:kQuestTypeTakePhoto andInfo:nsDict];
    

}

- (IBAction)chooseLocation:(id)sender {
    LocationPickerViewController *locationPickerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationPicker"];
    locationPickerViewController.delegate = self;
    [self.navigationController showViewController:locationPickerViewController sender:sender];
}

-(void)locationPickerViewController:(LocationPickerViewController *)viewController saveLocation:(CLLocation *)location
{
    questLocation = location;
    [viewController.navigationController popViewControllerAnimated:YES];
}

@end
