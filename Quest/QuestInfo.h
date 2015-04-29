//
//  QuestInfo.h
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestInfo : NSObject

// properties

/*
 static NSString * const kQuestColumnName = @"name";
 static NSString * const kQuestColumnDetail = @"description";
 static NSString * const kQuestColumnLocation = @"location";
 static NSString * const kQuestColumnOwner = @"owner";
 static NSString * const kQuestColumnCreatedAt = @"createdAt";
 static NSString * const kQuestColumnUpdatedAt = @"updatedAt";
 static NSString * const kQuestColumnACL = @"ACL";
 static NSString * const kQuestColumnObjectId = @"objectId";
 */

@property (nonatomic) NSString *questName;
@property (nonatomic) NSString *questDetail;
@property (nonatomic) NSString *questLocation;
@property (nonatomic) NSString *questOwner;
@property (nonatomic) NSString *questCreatedAt;
@property (nonatomic) NSString *questUpdatedAt;
@property (nonatomic) NSString *questACL;
@property (nonatomic) NSString *questObjectId;


// methods

- (NSDictionary *) questDictionary;

@end

