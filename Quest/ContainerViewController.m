//
//  ContainerViewController.m
//  Quest
//
//  Created by Mircea Eftimescu on 04/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

#pragma mark - Properties

@property (strong, nonatomic) NSString *currentSegueIdentifier;

@end

#pragma mark -

@implementation ContainerViewController

#pragma mark - Base Class Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //switch (((QuestViewController *)self.parentViewController).questType)
    switch (self.questType)
    {
        case TakePhoto:
        {
            [self performSegueWithIdentifier:kTakePhotoSegue sender:self];
        }
            break;
        case ViewPhoto:
        {
            [self performSegueWithIdentifier:kViewPhotoSegue sender:self];
        }
        break;
    default:
        break;
    }
}

#pragma mark - Navigation Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kTakePhotoSegue]) {
        self.takePhotoQuestViewController = segue.destinationViewController;
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.takePhotoQuestViewController];
        }
        else
        {
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }        
    }
    
    else if ([segue.identifier isEqualToString:kViewPhotoSegue])
    {
        self.viewPhotoViewController = segue.destinationViewController;
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.viewPhotoViewController];
        }
        else
        {
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
    }];
}

@end
