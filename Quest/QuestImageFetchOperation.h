//
//  QuestImageFetchOperation.h
//  Quest
//
//  Created by Georgel Vintila on 11/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestImageFetchOperation : NSOperation

#pragma mark - Instantiation

-(instancetype)initWithQuestType:(NSString*)questType andQuestId:(NSString*)questId;

@end
