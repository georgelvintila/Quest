//
//  SettingsViewController.m
//  Quest
//
//  Created by Rares Neagu on 12/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "SettingsViewController.h"
#import "FilterTableViewController.h"
#import <Parse/Parse.h>
@interface SettingsViewController () <SettingsFilterDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textFieldRadius;
@property (weak, nonatomic) IBOutlet UISlider *sliderRadius;
@property (weak, nonatomic) IBOutlet UILabel *textFieldSelectedQuest;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *str = [def objectForKey:kQuestSelectedFilterType];
    if (str) {
        self.textFieldSelectedQuest.text = str;
    }
    
    NSNumber *numberValue = [def objectForKey:kQuestSelectedRadius];
    if (numberValue == nil) {
        numberValue = @(5);
        [def setObject:numberValue forKey:kQuestSelectedRadius];
    }
    
    self.sliderRadius.value = [numberValue floatValue];
    self.textFieldRadius.text = [NSString stringWithFormat:@"%@m", numberValue];
    
}

- (void)filterDidSelectQuestType:(NSString *)questType {
    [[NSUserDefaults standardUserDefaults] setObject:questType forKey:kQuestSelectedFilterType];
    self.textFieldSelectedQuest.text = questType;
}


- (IBAction)buttonLogout:(id)sender {
    [PFUser logOut];
}


- (IBAction)sliderChanged:(UISlider *)sender {
    NSUInteger value = sender.value;
    self.textFieldRadius.text = [NSString stringWithFormat:@"%lum", (unsigned long)value];
    [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:kQuestSelectedRadius];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isMemberOfClass:[FilterTableViewController class]]) {
        FilterTableViewController *ctrl = segue.destinationViewController;
        ctrl.delegate = self;
        ctrl.currentSelectedFilterType = [[NSUserDefaults standardUserDefaults] objectForKey:kQuestSelectedFilterType];
    }
    NSUInteger value = [[[NSUserDefaults standardUserDefaults] objectForKey:kQuestSelectedRadius] unsignedIntegerValue];
    if (value < 5)
        value = 5;
    self.sliderRadius.value = value;
    self.textFieldRadius.text = [NSString stringWithFormat:@"%lum", (unsigned long)value];
    
}

@end
