//
//  UIView.m
//  Quest
//
//  Created by Rares Neagu on 07/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

#pragma mark - Getters

- (CGFloat)frameLeft {
    return self.frame.origin.x;
}

- (CGFloat)frameRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)frameTop {
    return self.frame.origin.y;
}

- (CGFloat)frameBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)frameWidth {
    return self.frame.size.width;
}

- (CGFloat)frameHeight {
    return self.frame.size.height;
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (CGPoint)frameOrigin {
    return self.frame.origin;
}

- (CGPoint)frameCenter {
    return CGPointMake(self.frameLeft + self.frameWidth / 2.0 , self.frameTop + self.frameHeight / 2.0);
}

#pragma mark - Setters

- (void)setFrameCenter:(CGPoint)frameCenter {
    self.frameLeft = frameCenter.x - self.frameWidth / 2.0;
    self.frameTop = frameCenter.y - self.frameHeight / 2.0;
}

- (void)setFrameLeft:(CGFloat)frameLeft {
    self.frame = CGRectMake(frameLeft, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    [self frameIntegral];
}

- (void)setFrameRight:(CGFloat)frameRight {
    self.frame = CGRectMake(frameRight - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    [self frameIntegral];
}

- (void)setFrameTop:(CGFloat)frameTop {
     self.frame = CGRectMake(self.frame.origin.x, frameTop, self.frame.size.width, self.frame.size.height);
    [self frameIntegral];
}

- (void)setFrameBottom:(CGFloat)frameBottom {
     self.frame = CGRectMake(self.frame.origin.x, frameBottom - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self frameIntegral];
}

- (void)setFrameWidth:(CGFloat)frameWidth {
     self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frameWidth, self.frame.size.height);
    [self frameIntegral];
}

- (void)setFrameHeight:(CGFloat)frameHeight {
     self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, frameHeight);
    [self frameIntegral];
}

- (void)setFrameSize:(CGSize)frameSize {
     self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frameSize.width, frameSize.height);
    [self frameIntegral];
}

- (void)setFrameOrigin:(CGPoint)frameOrigin {
     self.frame = CGRectMake(frameOrigin.x, frameOrigin.y, self.frame.size.width, self.frame.size.height);
    [self frameIntegral];
}

- (void)frameIntegral {
    CGRect frame = self.frame;
    self.frame = CGRectIntegral(frame);
}

@end
