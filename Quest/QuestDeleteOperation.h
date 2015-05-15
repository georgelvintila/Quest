//
//  QuestDeleteOperation.h
//  Quest
//
//  Created by Georgel Vintila on 06/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestDeleteOperation : NSOperation

#pragma mark - Instantiation

- (instancetype)initWithOldQuestInfo:(QuestInfo *)oldInfo forType:(NSString*)type;

@end
