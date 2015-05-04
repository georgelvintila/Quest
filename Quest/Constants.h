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
static NSString * const kTakePhotoSegue = @"TakePhotoSegue";
static NSString * const kViewPhotoSegue = @"ViewPhotoSegue";
static NSString * const kQuestSegue = @"QuestSegue";

typedef enum
{
    TakePhoto = 0,
    ViewPhoto = 1
} questTypeNo;



//General Quest Property Keys

static NSString * const kQuestColumnName = @"name";
static NSString * const kQuestColumnDetails = @"details";
static NSString * const kQuestColumnLocation = @"location";
static NSString * const kQuestColumnOwner = @"owner";
static NSString * const kQuestColumnCreatedAt = @"createdAt";
static NSString * const kQuestColumnUpdatedAt = @"updatedAt";
static NSString * const kQuestColumnACL = @"ACL";
static NSString * const kQuestColumnObjectId = @"objectId";

//Specific Quest Property Keys
//Take Photo Quest
static NSString * const kQuestColumnTakePhotoAngle = @"angle";
static NSString * const kQuestColumnTakePhotoRadius = @"radius";

//View Photo Quest
static NSString * const kQuestColumnViewPhotoViewRadius = @"viewRadius";
static NSString * const kQuestColumnViewPhotoMessage = @"message";
static NSString * const kQuestColumnViewPhotoImageFile = @"imageFile";

//Notification Strings
static NSString * const kMyQuestQuerySuccesNotification = @"kMyQuestQuerySuccesNotification";
static NSString * const kMyQuestQueryFailureNotification = @"kMyQuestQueryFailureNotification";
static NSString * const kQuestDataChangedNotification = @"kQuestDataChangedNotification";


#endif
