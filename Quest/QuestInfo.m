//
//  QuestInfo.m
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestInfo.h"

@interface QuestInfo ()

@end

@implementation QuestInfo

@synthesize questName = _questName;
@synthesize questDetail = _questDetail;
@synthesize questLocation = _questLocation;
@synthesize questOwner = _questOwner;
@synthesize questCreatedAt = _questCreatedAt;
@synthesize questUpdatedAt = _questUpdatedAt;
@synthesize questACL = _questACL;
@synthesize questObjectId = _questObjectId;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _questName = [NSString string];
        _questDetail = [NSString string];
        _questLocation = [NSString string];
        _questOwner = [NSString string];
        _questCreatedAt = [NSString string];
        _questUpdatedAt = [NSString string];
        _questACL = [NSString string];
        _questObjectId = [NSString string];
    }
    return self;
}

- (NSDictionary *) questDictionary {
    return @{@"questName": self.questName,
             @"questDetail": self.questDetail,
             @"questLocation": self.questLocation,
             @"questOwner": self.questOwner,
             @"questCreatedAt": self.questCreatedAt,
             @"questUpdatedAt": self.questUpdatedAt,
             @"questACL": self.questACL,
             @"questObjectId": self.questObjectId};
}


- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key {
    NSLog(@"setting object for keyed subscript");
    if ([key isEqualToString: @"questName"]) {
        self.questName = obj;
    }
    if ([key isEqualToString: @"questDetail"]) {
        self.questDetail = obj;
    }
    if ([key isEqualToString: @"questLocation"]) {
        self.questLocation = obj;
    }
    if ([key isEqualToString: @"questOwner"]) {
        self.questOwner = obj;
    }
    if ([key isEqualToString: @"questCreatedAt"]) {
        self.questCreatedAt = obj;
    }
    if ([key isEqualToString: @"questUpdatedAt"]) {
        self.questUpdatedAt = obj;
    }
    if ([key isEqualToString: @"questACL"]) {
        self.questACL = obj;
    }
    if ([key isEqualToString: @"questObjectId"]) {
        self.questObjectId = obj;
    }
}
- (id)objectForKeyedSubscript:(NSString *)idx {
    if ([idx isEqualToString: @"questName"]) {
        return self.questName;
    }
    if ([idx isEqualToString: @"questDetail"]) {
        return self.questDetail;
    }
    if ([idx isEqualToString: @"questLocation"]) {
        return self.questLocation;
    }
    if ([idx isEqualToString: @"questOwner"]) {
        return self.questOwner;
    }
    if ([idx isEqualToString: @"questCreatedAt"]) {
        return self.questCreatedAt;
    }
    if ([idx isEqualToString: @"questUpdatedAt"]) {
        return self.questUpdatedAt;
    }
    if ([idx isEqualToString: @"questACL"]) {
        return self.questACL;
    }
    if ([idx isEqualToString: @"questObjectId"]) {
        return self.questObjectId;
    }
    return nil;
}

@end
