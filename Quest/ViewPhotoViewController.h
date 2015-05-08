//
//  ViewPhotoViewController.h
//  Quest
//
//  Created by Mircea Eftimescu on 04/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewPhotoViewController : UIViewController

@property (assign, nonatomic) NSUInteger viewPhotoRadius;
@property (strong, nonatomic) NSData* viewPhotoImage;
@property (strong, nonatomic) NSString* viewPhotoMessage;

@end
