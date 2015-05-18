//
//  UIImage+Size.m
//  Quest
//
//  Created by Georgel Vintila on 18/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "UIImage+Size.h"

@implementation UIImage (Size)

-(UIImage *)imageOfSize:(CGSize)size
{
    UIImage *newImage = nil;
    CGFloat ratio = self.size.width/self.size.height;
    if(size.width<size.height)
    {
        size.width = ratio*size.height;
    }
    else
    {
        size.height = (1/ratio)*size.width;
    }
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
