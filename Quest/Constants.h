//
//  Constants.h
//  Quest
//
//  Created by Mircea Eftimescu on 28/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#ifndef Quest_Constants_h
#define Quest_Constants_h

// Quest Types

static NSString * const kQuestTypeTakePhotoQuest = @"TakePhotoQuest";
static NSString * const kQuestTypeViewPhotoQuest = @"ViewPhotoQuest";
static NSString * const kQuestTypeAllQuests = @"AllQuests";

static NSString * const kQuestTableViewControllerTitleOtherQuests = @"OtherQuests";
static NSString * const kQuestTableViewControllerTitleMyQuests = @"MyQuests";

static NSString * const kQuestSelectedFilterType = @"kQuestSelectedFilterType";

//Cell Identifiers

static NSString * const kCellIdentifier = @"kCellIdentifier";
static NSString * const kCellIdentifierQuest = @"kQuestCellIdentifier";
static NSString * const kCellHeaderIdentifier = @"kCellHeaderIdentifier";
static NSUInteger const kCellIncompleteTag = 2;

// Segues

static NSString * const kQuestDetailsSegue = @"QuestDetailsSegue";
static NSString * const kTakePhotoSegue = @"TakePhotoSegue";
static NSString * const kViewPhotoSegue = @"ViewPhotoSegue";
static NSString * const kQuestSegue = @"QuestSegue";


//General Quest Property Keys

static NSString * const kQuestColumnName = @"name";
static NSString * const kQuestColumnDetails = @"details";
static NSString * const kQuestColumnLocation = @"location";
static NSString * const kQuestColumnOwner = @"owner";
static NSString * const kQuestColumnCreatedAt = @"createdAt";
static NSString * const kQuestColumnUpdatedAt = @"updatedAt";
static NSString * const kQuestColumnACL = @"ACL";
static NSString * const kQuestColumnObjectId = @"objectId";
static NSString * const kQuestColumnComplete = @"complete";

//Specific Quest Property Keys
//Take Photo Quest
static NSString * const kQuestColumnTakePhotoAngle = @"angle";
static NSString * const kQuestColumnTakePhotoRadius = @"radius";

//View Photo Quest
static NSString * const kQuestColumnViewPhotoViewRadius = @"viewRadius";
static NSString * const kQuestColumnViewPhotoMessage = @"message";
static NSString * const kQuestColumnViewPhotoImageFile = @"imageFile";

//Notification Strings
static NSString * const kQuestQuerySuccesNotification = @"kQuestQuerySuccesNotification";
static NSString * const kQuestQueryFailureNotification = @"kQuestQueryFailureNotification";
static NSString * const kQuestDataChangedNotification = @"kQuestDataChangedNotification";


static NSString * const kFetchOwner = @"kFetchOwner";
static NSString * const kFetchItems= @"kFetchItems";
static NSString * const kFetchType= @"kFetchType";

static CGFloat const kFilterDistance = 1000.0f;
static CGFloat const kHeaderHeight = 25.0f;

#endif
