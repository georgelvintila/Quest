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

@property (nonatomic) NSString *questName;
@property (nonatomic) NSString *questDetail;
@property (nonatomic) NSString *questLocation;
@property (nonatomic) NSString *questOwner;
@property (nonatomic) NSString *questCreatedAt;
@property (nonatomic) NSString *questUpdatedAt;
@property (nonatomic) NSString *questACL;
@property (nonatomic) NSString *questObjectId;


// methods

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key; // setter
- (id)objectForKeyedSubscript:(id)key;                           // getter

- (NSDictionary *) questDictionary;

@end

