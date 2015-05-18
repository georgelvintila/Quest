//
//  QuestManager.h
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

@class QuestManager;

@protocol QuestManagerDelegate <NSObject>

-(void)updateQuestList;

@end


@interface QuestManager : NSObject

@property (nonatomic,weak)id<QuestManagerDelegate> delegate;

#pragma mark - Class Methods

///@brief Shared Instance of the Manager

- (instancetype)initWithOwner:(QuestOwnerType)questOwner;

#pragma mark - Instance Methods

///@brief Add a new Quest of a specific type
-(void)addNewQuestWithType:(NSString *)type andInfo:(QuestItem *)questInfo;

///@brief Delete a certain quest
-(void)deleteQuestOfType:(NSString *)type atIndex:(NSUInteger) index;

///@brief Update information for a certain quest
-(void)updateQuestOfType:(NSString *)type atIndex:(NSUInteger) index withQuestInfo:(QuestItem*)questInfo;

///@brief Make a request for all the quests of a specific type for a certain owner
-(void)requestItemsOfType:(NSString *)questType;

///@brief Make a request for all the quests of a specific type for a certain owner with item limit
-(void)requestItemsOfType:(NSString *)questType withLimit:(NSUInteger) limit;

///@brief Make a request for all the quests of a specific type for a certain owner with item limit and skiping first
-(void)requestItemsOfType:(NSString *)questType withLimit:(NSUInteger) limit skipFirst:(NSUInteger) skip;

///@brief Make a request for all the quests of a certain owner
-(void)requestAllItems;

///@brief Get all quest types for a certain owner
-(NSArray *)allQuestTypes;

///@brief Get all quests of one type for a certain owner
-(NSArray *)questListOfType:(NSString *)type;

@end
