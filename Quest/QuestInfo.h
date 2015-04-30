//
//  QuestInfo.h
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestInfo : NSObject

#pragma mark - Properties

@property (nonatomic) NSString *questName;
@property (nonatomic) NSString *questDetails;
@property (nonatomic) CLLocation* questLocation;
@property (nonatomic) PFUser *questOwner;
@property (nonatomic) NSDate *questCreatedAt;
@property (nonatomic) NSDate *questUpdatedAt;
@property (nonatomic) PFACL *questACL;
@property (nonatomic) NSString *questObjectId;


#pragma mark - Instance Methods

- (NSDictionary *) questDictionary;

@end

