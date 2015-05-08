//
//  TakePhotoQuestViewController.m
//  Quest
//
//  Created by Mircea Eftimescu on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "TakePhotoQuestViewController.h"


@interface TakePhotoQuestViewController ()

@property (weak, nonatomic) IBOutlet UILabel *radiusValue;
@property (weak, nonatomic) IBOutlet UILabel *angleValue;

@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UIStepper *angleStepper;

@end

@implementation TakePhotoQuestViewController

#pragma mark - Base Methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Action Methods

- (IBAction)angleStepperValueChanged:(UIStepper*)sender {
    NSInteger intValue = sender.value;
    self.angleValue.text = [@(intValue) stringValue];
}

- (IBAction)radiusSliderValueChanged:(UISlider*)sender {
    NSInteger intValue = sender.value;
    self.radiusValue.text = [@(intValue) stringValue];
}

- (double)questRadius {
    return self.angleStepper.value;
}

- (double)questAngle {
    return self.radiusSlider.value;
}

- (void)setQuestAngle:(double)questAngle {
    [self.angleStepper setValue:self.questAngle];
    self.angleValue.text = [@(questAngle) stringValue];
}

- (void)setQuestRadius:(double)questRadius {
    [self.radiusSlider setValue:questRadius animated:NO];
    self.radiusValue.text = [@(questRadius) stringValue];
}

@end
