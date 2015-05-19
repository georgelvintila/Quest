//
//  ViewController.m
//  Quest
//
//  Created by Georgel Vintila on 24/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestLoginViewController.h"

@interface QuestLoginViewController ()

#pragma mark - Properties

//@property (nonatomic,strong) PFLogInViewController *loginViewController;

@end

#pragma mark - 

@implementation QuestLoginViewController

#pragma mark - Base Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucces) name:PFLogInSuccessNotification object:nil];
}


-(void)loginSucces
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
