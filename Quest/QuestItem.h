//
//  QuestInfo.h
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface QuestItem : NSObject

#pragma mark - Properties

@property (nonatomic) NSString *questName;
@property (nonatomic) NSString *questDetails;
@property (nonatomic) CLLocation* questLocation;
@property (nonatomic) NSDate *questCreatedAt;
@property (nonatomic) NSDate *questUpdatedAt;
@property (nonatomic) NSString *questObjectId;
@property (nonatomic) BOOL questComplete;


- (instancetype)initWithType:(NSString *)type;
+ (QuestItem*)questItemForQuest:(id)quest;

#pragma mark - Instance Methods

-(void)saveQuestWithComplition:(void (^)(void))block;
-(void)deleteQuestWithComplition:(void (^)(void))block;

@end

