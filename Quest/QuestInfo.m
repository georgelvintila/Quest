//
//  QuestInfo.m
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestInfo.h"

@interface QuestInfo ()

@property (nonatomic) NSMutableDictionary *dictionary;

@end

@implementation QuestInfo

@synthesize dictionary = _dictionary;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setQuestName:(NSString *)questName {
    self.dictionary[kQuestColumnName] = questName;
}

- (void)setQuestDetail:(NSString *)questDetail {
    self.dictionary[kQuestColumnDetail] = questDetail;
}

- (void)setQuestLocation:(NSString *)questLocation {
    self.dictionary[kQuestColumnLocation] = questLocation;
}

- (void)setQuestOwner:(NSString *)questOwner {
     self.dictionary[kQuestColumnOwner] = questOwner;
}

- (void)setQuestCreatedAt:(NSString *)questCreatedAt {
     self.dictionary[kQuestColumnCreatedAt] = questCreatedAt;
}

- (void)setQuestUpdatedAt:(NSString *)questUpdatedAt {
     self.dictionary[kQuestColumnUpdatedAt] = questUpdatedAt;
}

- (void)setQuestACL:(NSString *)questACL {
     self.dictionary[kQuestColumnACL] = questACL;
}

- (void)setQuestObjectId:(NSString *)questObjectId {
     self.dictionary[kQuestColumnObjectId] = questObjectId;
}

- (NSString *)questName {
    return self.dictionary[kQuestColumnName];
}

- (NSString *)questDetail {
    return self.dictionary[kQuestColumnDetail];
}

- (NSString *)questLocation {
    return self.dictionary[kQuestColumnLocation];
}

- (NSString *)questOwner {
    return self.dictionary[kQuestColumnOwner];
}

- (NSString *)questCreatedAt {
    return self.dictionary[kQuestColumnCreatedAt];
}

- (NSString *)questUpdatedAt {
    return self.dictionary[kQuestColumnUpdatedAt];
}

- (NSString *)questACL {
    return self.dictionary[kQuestColumnACL];
}

- (NSString *)questObjectId {
    return self.dictionary[kQuestColumnObjectId];
}

- (NSDictionary *)questDictionary {
    return [NSDictionary dictionaryWithDictionary:self.dictionary];
}

@end