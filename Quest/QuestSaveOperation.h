//
//  QuestSaveOperation.h
//  Quest
//
//  Created by Georgel Vintila on 06/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class Quest;

@interface QuestSaveOperation : NSOperation

-(instancetype)initWithQuest:(id)quest andQuestInfo:(QuestInfo*)questInfo;

@end
