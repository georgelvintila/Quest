//
//  QuestManager.h
//  Quest
//
//  Created by Georgel Vintila on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quest.h"

@interface QuestManager : NSObject

@property (nonatomic,strong) NSDictionary *questDictionary;

-(void) addNewQuestWithType:(NSString*)type;
-(void) deleteQuest:(Quest*)quest;
-(void) setInformation:(NSDictionary*)questInfo forQuest:(Quest*)quest;

@end
