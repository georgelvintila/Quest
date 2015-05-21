//
//  CompletedQuestsManager.h
//  Quest
//
//  Created by Rares Neagu on 21/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompletedQuestsManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)objectForKeyedSubscript:(NSString *)key;
- (void)setYesForKey:(NSString *)string;

@end
