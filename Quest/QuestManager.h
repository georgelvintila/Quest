//
//  QuestManager.h
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TakePhotoQuest.h"

@interface QuestManager : NSObject

#pragma mark - Class Methods

///@brief Shared Instance of the Manager
+(instancetype) sharedManager;

#pragma mark - Instance Methods

///@brief Add a new Quest of a specific type
-(void)addNewQuestWithType:(NSString *)type andInfo:(QuestInfo *)questInfo;

///@brief Delete a certain quest
-(void)deleteQuestOfType:(NSString *)type atIndex:(NSUInteger) index;

///@brief Update information for a certain quest
-(void)updateQuestOfType:(NSString *)type atIndex:(NSUInteger) index withQuestInfo:(QuestInfo*)questInfo;

///@brief Make a request for all the quests of a specific type for a certain owner
-(void)requestItemsOfType:(NSString *)questType forOwner:(QuestOwnerType)questOwner;

///@brief Make a request for all the quests of a specific type for a certain owner with item limit
-(void)requestItemsOfType:(NSString *)questType forOwner:(QuestOwnerType)questOwner withLimit:(NSUInteger) limit;

///@brief Make a request for all the quests of a specific type for a certain owner with item limit and skiping first
-(void)requestItemsOfType:(NSString *)questType forOwner:(QuestOwnerType)questOwner withLimit:(NSUInteger) limit skipFirst:(NSUInteger) skip;

///@brief Make a request for all the quests of a certain owner
-(void)requestAllItemsForOwner:(QuestOwnerType)questOwner;

///@brief Get all quest types for a certain owner
-(NSArray *)allQuestTypesForOwner:(QuestOwnerType)owner;

///@brief Get all quests of one type for a certain owner
-(NSArray *)questListOfType:(NSString *)type forOwner:(QuestOwnerType) owner;

@end
