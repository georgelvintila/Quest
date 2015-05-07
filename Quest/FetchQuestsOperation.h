//
//  FetchQuestsOperation.h
//  Quest
//
//  Created by Georgel Vintila on 06/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchQuestsOperation : NSOperation

+(instancetype)fetchQuestOperationWithType:(NSString *)questType forOwner:(QuestOwnerType)questOwner;
+(instancetype)fetchQuestOperationWithType:(NSString *)questType forOwner:(QuestOwnerType)questOwner withLimit:(NSUInteger)limit;
+(instancetype)fetchQuestOperationWithType:(NSString *)questType forOwner:(QuestOwnerType)questOwner withLimit:(NSUInteger)limit skipFirst:(NSUInteger) skip;

@end
