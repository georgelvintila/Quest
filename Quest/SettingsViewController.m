//
//  SettingsViewController.m
//  Quest
//
//  Created by Rares Neagu on 12/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>
@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textFieldRadius;
@property (weak, nonatomic) IBOutlet UISlider *sliderRadius;
@property (weak, nonatomic) IBOutlet UILabel *textFieldSelectedQuest;


@end

@implementation SettingsViewController

- (IBAction)buttonLogout:(id)sender {
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)sliderChanged:(UISlider *)sender {
    NSUInteger value = sender.value;
    self.textFieldRadius.text = [NSString stringWithFormat:@"%um", value];
    [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:kQuestSelectedRadius];
}
- (IBAction)buttonFilter:(id)sender {
    // segue
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kQuestSelectedFilterType];
    if (str) {
        self.textFieldSelectedQuest.text = str;
    }
    NSUInteger value = [[[NSUserDefaults standardUserDefaults] objectForKey:kQuestSelectedRadius] unsignedIntegerValue];
    if (value < 5)
        value = 5;
    self.sliderRadius.value = value;
    self.textFieldRadius.text = [NSString stringWithFormat:@"%um", value];
    
}

@end
