//
//  QuestViewPhotoViewController.m
//  Quest
//
//  Created by Rares Neagu on 19/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestViewPhotoViewController.h"

@interface QuestViewPhotoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelTimeLeft;
@property (weak, nonatomic) IBOutlet UIView *viewTimeLeft;

@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSUInteger timeLeft;

@end

@implementation QuestViewPhotoViewController

#pragma mark - View Triggers

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateCorners];
}

- (void)viewDidAppear:(BOOL)animated {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    self.timeLeft = kViewPhotoTime;
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.timer invalidate];
}

#pragma mark - Updaters

- (void)updateCorners {
    self.viewTimeLeft.layer.cornerRadius = self.viewTimeLeft.frame.size.width / 2;
}

- (void)updateTimeLeft {
    self.labelTimeLeft.text = [NSString stringWithFormat:@"%us", self.timeLeft];
    [UIView animateWithDuration:2 animations:^{
        double size = self.timeLeft / kViewPhotoTime;
        if (size < 0.2)
            size = 0.2;
        self.viewTimeLeft.transform = CGAffineTransformMakeScale(size, size);
    }];
}

- (void)updateTimeDone {
//    self.questItem.questComplete = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Timer tick

- (void)timerTick {
    if (self.timeLeft > 0) {
        self.timeLeft--;
        [self updateTimeLeft];
    } else {
        [self updateTimeDone];
    }
}

@end
