//
//  QuestInfoTests.m
//  Quest
//
//  Created by Rares Neagu on 29/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Parse/Parse.h>
#import "QuestInfo.h"
#import "ViewPhotoQuestInfo.h"
#import "TakePhotoQuestInfo.h"

@interface QuestInfoTests : XCTestCase

@end

@implementation QuestInfoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testQuestInfo {
    // This is an example of a functional test case.
    QuestInfo *questInfo = [[QuestInfo alloc] init];
    XCTAssert(questInfo, @"Allocation failed");
    
    questInfo.questName = @"quest name";
    
    XCTAssertEqualObjects(questInfo.questName, @"quest name");
    questInfo.questCreatedAt = questInfo.questName;
    questInfo.questName = @"quest name 2";
    
    XCTAssertNotEqual(questInfo.questName, questInfo.questCreatedAt);
    
    XCTAssertEqualObjects(questInfo.questName, @"quest name 2");
    
    XCTAssertNil(questInfo.questOwner);
    
    XCTAssertThrows([questInfo valueForKey:@"questPhotoViewRadius"]);
    
}

- (void) testTakePhotoQuestInfo {
    TakePhotoQuestInfo *questInfo = [[TakePhotoQuestInfo alloc] init];
    
    questInfo.questPhotoImageFile = @"something image file";
    questInfo.questPhotoMessage = @"something photo message";
    questInfo.questPhotoViewRadius = @"something photo view radius";
    
    questInfo.questOwner = @"quest owner";
    
    XCTAssertEqualObjects(questInfo.questPhotoImageFile, @"something image file");
    XCTAssertEqualObjects(questInfo.questPhotoMessage, @"something photo message");
    XCTAssertEqualObjects(questInfo.questPhotoViewRadius, @"something photo view radius");
    
    XCTAssertNil(questInfo.questLocation);
    
    XCTAssertEqualObjects(questInfo.questOwner, @"quest owner");
}

- testViewPhotoQuestInfo {
    ViewPhotoQuestInfo *questInfo = [[ViewPhotoQuestInfo alloc] init];
    
    questInfo.questPhotoAngle = @"photo angle";
    questInfo.questPhotoRadius = @"photo radius";
    
    questInfo.questOwner = @"quest owner";
    
    XCTAssertEqualObjects(questInfo.questPhotoAngle, @"photo angle");
    XCTAssertEqualObjects(questInfo.questPhotoRadius, @"photo radius");
    
    XCTAssertNil(questInfo.questLocation);
    
    XCTAssertEqualObjects(questInfo.questOwner, @"quest owner");
    
}

@end
