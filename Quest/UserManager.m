//
//  UserManager.m
//  Quest
//
//  Created by Georgel Vintila on 04/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "UserManager.h"
#import <Parse/Parse.h>

@implementation UserManager

#pragma mark - Instantition

+(instancetype)sharedManager
{
    static UserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserManager alloc] init];
    });
    return manager;
}

@end
