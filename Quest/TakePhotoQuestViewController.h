//
//  TakePhotoQuestViewController.h
//  Quest
//
//  Created by Mircea Eftimescu on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationPickerViewController.h"

@interface TakePhotoQuestViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *radiusValue;
@property (weak, nonatomic) IBOutlet UILabel *angleValue;

@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UIStepper *angleStepper;

- (IBAction)angleStepperValueChanged:(UIStepper*)sender;
- (IBAction)radiusSliderValueChanged:(UISlider*)sender;

@end
