//
//  QuestTests.m
//  QuestTests
//
//  Created by Georgel Vintila on 24/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Parse/Parse.h>
#import "QuestManager.h"
#import "Constants.h"

@interface QuestTests : XCTestCase

@end

@implementation QuestTests

- (void)setUp {
    [super setUp];
    [self addNewQuestTest];
//    [self deleteQuestTest];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}


- (void)addNewQuestTest
{
    NSDictionary *info = @{kQuestColumnName:@"name",kQuestColumnViewPhotoViewRadius:@3,kQuestColumnViewPhotoImageFile:[UIImage imageNamed:@"Globe"]};
    [[QuestManager sharedManager] addNewQuestWithType:kQuestTypeViewPhotoQuest andInfo:info];
}

-(void)deleteQuestTest
{
    [[QuestManager sharedManager] deleteQuestOfType:kQuestTypeTakePhotoQuest atIndex:0];
}

@end
