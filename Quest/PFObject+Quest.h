//
//  PFObject+Quest.h
//  Quest
//
//  Created by Georgel Vintila on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFObject (Quest)

#pragma mark -
#pragma mark Properties

///@brief Property that contains the name of the Quest
@property (nonatomic,readonly,strong) NSString *name;

///@brief Property that contains the description of the Quest
@property (nonatomic,readonly,strong) NSString *details;

///@brief Property that contains the Owner of the Quest
@property (nonatomic,readonly,strong) PFUser *owner;

///@brief Property that contains the location of the Quest
@property (nonatomic,readonly,strong) CLLocation *mapLocation;

///@brief Property that contains the location of the Quest
@property(nonatomic,readonly,strong) PFGeoPoint *location;

#pragma mark -
#pragma mark Instance Methods

///@brief Method that saves Quest information
-(void)saveQuestInformation:(QuestInfo *)questInfo;

@end
