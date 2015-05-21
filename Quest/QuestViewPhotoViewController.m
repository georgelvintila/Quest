//
//  QuestViewPhotoViewController.m
//  Quest
//
//  Created by Rares Neagu on 19/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestViewPhotoViewController.h"
#import "CompletedQuestsManager.h"

@interface QuestViewPhotoViewController () <ViewPhotoQuestItemDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelTimeLeft;
@property (weak, nonatomic) IBOutlet UIView *viewTimeLeft;

@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSUInteger timeLeft;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation QuestViewPhotoViewController

#pragma mark - ViewPhotoQuestItemDelegate

-(void)imageReceived:(UIImage*)image {
    [self.imagePicture setImage: image];
    [self imageDidLoad];
}

#pragma mark - View Triggers

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateCorners];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
}

- (void)imageDidLoad {
    self.labelTimeLeft.hidden = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    self.timeLeft = kViewPhotoTime;
    [self.activityIndicatorView stopAnimating];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareLoadImage];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (void)prepareLoadImage {
    self.activityIndicatorView.frameWidth = 50;
    self.activityIndicatorView.frameHeight = 50;
    self.activityIndicatorView.frameCenter = self.viewTimeLeft.frameCenter;
    self.activityIndicatorView.frameTop += 50;
    
    // add the activityIndicatorView and hide the label
    self.labelTimeLeft.hidden = YES;
    [self.view addSubview: self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    self.questItem.delegate = self;
    [self.questItem requestImageData];
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
    CompletedQuestsManager *questsManager = [CompletedQuestsManager sharedManager];
    [questsManager setYesForKey: self.questItem.questObjectId]; 
    [self.navigationController popViewControllerAnimated:YES];
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
