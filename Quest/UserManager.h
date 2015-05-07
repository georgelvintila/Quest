//
//  UserManager.h
//  Quest
//
//  Created by Georgel Vintila on 04/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

@interface UserManager : NSObject

#pragma mark - Class Methods

@property(atomic,readonly) CLLocation *location;

///@brief Shared Instance of the Manager
+(instancetype) sharedManager;

@end
