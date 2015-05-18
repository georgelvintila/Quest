//
//  ContainerViewController.h
//  Quest
//
//  Created by Mircea Eftimescu on 04/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakePhotoQuestViewController.h"
#import "ViewPhotoViewController.h"
#import "EditQuestViewController.h"


@interface ContainerViewController : UIViewController

#pragma mark - Properties

@property (nonatomic, strong) TakePhotoQuestViewController *takePhotoQuestViewController;
@property (nonatomic, strong) ViewPhotoViewController *viewPhotoViewController;
@property (nonatomic) NSInteger questType;

@end
