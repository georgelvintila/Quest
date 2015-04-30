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
    self.angleValue.text = [NSString stringWithFormat:@"%lu", (long)intValue];
}

- (IBAction)radiusSliderValueChanged:(UISlider*)sender {
    NSInteger intValue = sender.value;
    self.radiusValue.text = [NSString stringWithFormat:@"%lu", (long)intValue];
}

@end
