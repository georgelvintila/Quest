//
//  ViewController.m
//  Quest
//
//  Created by Georgel Vintila on 24/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) PFLogInViewController *loginViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginViewController = [[PFLogInViewController alloc] init];
    self.loginViewController.fields = (PFLogInFieldsDefault | PFLogInFieldsFacebook);
    self.loginViewController.view.backgroundColor = [UIColor lightGrayColor];
    [self presentViewController:self.loginViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
