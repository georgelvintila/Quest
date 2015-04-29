//
//  QuestManager.h
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TakePhoto.h"

@interface QuestManager : NSObject

///@brief Property that contains all quests of the curent user grouped by type
@property (atomic,readonly) NSMutableDictionary *myQuests;

///@brief Property that contains all quests of the other users grouped by type
@property (atomic,readonly) NSMutableDictionary *otherQuests;

///@brief Shared Instance of the Manager
+(instancetype) sharedManager;

///@brief Add a new Quest of a specific type
-(void)addNewQuestWithType:(NSString *)type andInfo:(NSDictionary *)questInfo;

///@brief Delete a certain quest
-(void)deleteQuestOfType:(NSString *)type atIndex:(NSUInteger) index;

///@brief Update information for a certain quest
-(void)updateQuestOfType:(NSString *)type atIndex:(NSUInteger) index withQuestInfo:(NSDictionary*)questInfo;

///@brief Make a request for all the quests of the curent user
-(void)requestMyQuests;
@end
