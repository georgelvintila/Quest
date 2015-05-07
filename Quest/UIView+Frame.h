//
//  UIView.h
//  Quest
//
//  Created by Rares Neagu on 07/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Frame)

// float values
@property (nonatomic) CGFloat frameLeft;
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameTop;
@property (nonatomic) CGFloat frameBottom;
@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

// frame valuess
@property (nonatomic) CGSize frameSize;
@property (nonatomic) CGPoint frameOrigin;


@end
