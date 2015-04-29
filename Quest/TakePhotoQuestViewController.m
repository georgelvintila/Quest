//
//  TakePhotoQuestViewController.m
//  Quest
//
//  Created by Mircea Eftimescu on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "TakePhotoQuestViewController.h"

@interface TakePhotoQuestViewController ()
@property (nonatomic, strong) CLLocation *questLocation;
@end

@implementation TakePhotoQuestViewController
@synthesize angleValue, radiusValue, questLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)angleStepperValueChanged:(UIStepper*)sender {
    int intValue = (int) sender.value;
    angleValue.text = [NSString stringWithFormat:@"%d", intValue];
}

- (IBAction)radiusSliderValueChanged:(UISlider*)sender {
    int intValue = (int) sender.value;
    radiusValue.text = [NSString stringWithFormat:@"%d", intValue];
}

- (IBAction)saveQuest:(id)sender {
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
