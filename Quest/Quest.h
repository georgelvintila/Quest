//
//  Quest.h
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Quest : PFObject

///@brief Property that contains the name of the Quest
@property (nonatomic,readonly,strong) NSString *name;

///@brief Property that contains the description of the Quest
@property (nonatomic,readonly,strong) NSString *detail;

@property (nonatomic,readonly,strong) PFUser *owner;

///@brief Property that contains the location of the Quest
@property (nonatomic,readonly,strong) CLLocation *location;

///@brief Property that contains the type of the Quest
@property (nonatomic,readonly) NSString *questType;

///@brief Property that contains the Quest information specific to a certain type
@property(nonatomic,readonly) NSDictionary *typeSpecificData;

///@brief Creates instance of Quest of a specific type
-(instancetype) initWithType:(NSString *) type;

///@brief Save the Quest information in the database
-(void) saveQuestInformation:(NSDictionary*)questInfo;

@end
