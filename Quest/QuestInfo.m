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

#pragma mark - Instance Methods
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

- (void)setQuestDetails:(NSString *)questDetails {
    self.dictionary[kQuestColumnDetails] = questDetails;
}

- (void)setQuestLocation:(CLLocation*)questLocation {
    self.dictionary[kQuestColumnLocation] = questLocation;
}

- (void)setQuestOwner:(PFUser *)questOwner {
     self.dictionary[kQuestColumnOwner] = questOwner;
}

- (void)setQuestCreatedAt:(NSDate *)questCreatedAt {
     self.dictionary[kQuestColumnCreatedAt] = questCreatedAt;
}

- (void)setQuestUpdatedAt:(NSDate *)questUpdatedAt {
     self.dictionary[kQuestColumnUpdatedAt] = questUpdatedAt;
}

- (void)setQuestACL:(PFACL *)questACL {
     self.dictionary[kQuestColumnACL] = questACL;
}

- (void)setQuestObjectId:(NSString *)questObjectId {
     self.dictionary[kQuestColumnObjectId] = questObjectId;
}

- (NSString *)questName {
    return self.dictionary[kQuestColumnName];
}

- (NSString *)questDetail {
    return self.dictionary[kQuestColumnDetails];
}

- (CLLocation*)questLocation {
    return self.dictionary[kQuestColumnLocation];
}

- (PFUser *)questOwner {
    return self.dictionary[kQuestColumnOwner];
}

- (NSDate *)questCreatedAt {
    return self.dictionary[kQuestColumnCreatedAt];
}

- (NSDate *)questUpdatedAt {
    return self.dictionary[kQuestColumnUpdatedAt];
}

- (PFACL *)questACL {
    return self.dictionary[kQuestColumnACL];
}

- (NSString *)questObjectId {
    return self.dictionary[kQuestColumnObjectId];
}

- (NSDictionary *)questDictionary {
    return [NSDictionary dictionaryWithDictionary:self.dictionary];
}

@end