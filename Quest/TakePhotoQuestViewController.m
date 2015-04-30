//
//  TakePhotoQuestViewController.m
//  Quest
//
//  Created by Mircea Eftimescu on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "TakePhotoQuestViewController.h"


@interface TakePhotoQuestViewController ()

@end

@implementation TakePhotoQuestViewController

#pragma mark - Base Methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Action Methods

- (IBAction)angleStepperValueChanged:(UIStepper*)sender {
    NSInteger intValue = sender.value;
    self.angleValue.text = [NSString stringWithFormat:@"%lu", (long)intValue];
}

- (IBAction)radiusSliderValueChanged:(UISlider*)sender {
    NSInteger intValue = sender.value;
    self.radiusValue.text = [NSString stringWithFormat:@"%lu", (long)intValue];
}

@end
