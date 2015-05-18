//
//  FetchQuestsOperation.h
//  Quest
//
//  Created by Georgel Vintila on 06/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QuestFetchOperationDelegate <NSObject>

#pragma mark - Delegate Methods

-(void) operation:(NSOperation *)operation finishedWithInfo:(NSDictionary*)userInfo;

@end

@interface QuestFetchOperation : NSOperation

#pragma mark - Properties

@property (nonatomic,weak) id<QuestFetchOperationDelegate> delegate;

#pragma mark - Class Methods

+(instancetype)fetchQuestOperationWithType:(NSString *)questType forOwner:(QuestOwnerType)questOwner;
+(instancetype)fetchQuestOperationWithType:(NSString *)questType forOwner:(QuestOwnerType)questOwner withLimit:(NSUInteger)limit;
+(instancetype)fetchQuestOperationWithType:(NSString *)questType forOwner:(QuestOwnerType)questOwner withLimit:(NSUInteger)limit skipFirst:(NSUInteger) skip;

@end
