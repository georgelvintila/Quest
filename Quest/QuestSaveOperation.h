//
//  QuestSaveOperation.h
//  Quest
//
//  Created by Georgel Vintila on 06/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestSaveOperation : NSOperation

#pragma mark - Instantiation Methods

- (instancetype)initWithOldQuestInfo:(QuestInfo *)oldInfo andNewQuestInfo:(QuestInfo *)newInfo forType:(NSString*)type;
- (instancetype)initWithQuest:(id)quest andQuestInfo:(QuestInfo*)questInfo;

@end
