//
//  QuestInfo.m
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestInfo.h"

@interface QuestInfo ()

#pragma mark - Properties
@property (nonatomic) NSMutableDictionary *dictionary;

@end

#pragma mark -

@implementation QuestInfo

#pragma mark - Properties

@synthesize dictionary = _dictionary;

#pragma mark - Instantiation Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Property Methods

- (void)setQuestName:(NSString *)questName {
    if(questName)
        self.dictionary[kQuestColumnName] = [questName copy];
}

- (void)setQuestDetails:(NSString *)questDetails {
    if(questDetails)
        self.dictionary[kQuestColumnDetails] = [questDetails copy];
}

- (void)setQuestLocation:(CLLocation*)questLocation {
    if(questLocation)
        self.dictionary[kQuestColumnLocation] = questLocation;
}

- (void)setQuestCreatedAt:(NSDate *)questCreatedAt {
    if(questCreatedAt)
        self.dictionary[kQuestColumnCreatedAt] = [questCreatedAt copy];
}

- (void)setQuestUpdatedAt:(NSDate *)questUpdatedAt {
    if(questUpdatedAt)
        self.dictionary[kQuestColumnUpdatedAt] = [questUpdatedAt copy];
}

- (void)setQuestObjectId:(NSString *)questObjectId {
    if(questObjectId)
        self.dictionary[kQuestColumnObjectId] = [questObjectId copy];
}

-(void)setQuestComplete:(BOOL)questComplete
{
    self.dictionary[kQuestColumnComplete] = [NSNumber numberWithInt:questComplete];
}

- (NSString *)questName {
    return self.dictionary[kQuestColumnName];
}

- (NSString *)questDetails {
    return self.dictionary[kQuestColumnDetails];
}

- (CLLocation*)questLocation {
    return self.dictionary[kQuestColumnLocation];
}

- (NSDate *)questCreatedAt {
    return self.dictionary[kQuestColumnCreatedAt];
}

- (NSDate *)questUpdatedAt {
    return self.dictionary[kQuestColumnUpdatedAt];
}

- (NSString *)questObjectId {
    return self.dictionary[kQuestColumnObjectId];
}

-(BOOL)questComplete
{
    return [self.dictionary[kQuestColumnComplete] boolValue];
}

#pragma mark - Instance Methods

- (NSDictionary *)questDictionary {
    return [NSDictionary dictionaryWithDictionary:self.dictionary];
}

@end