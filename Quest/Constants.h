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
static NSString * const kQuestSelectedRadius = @"kQuestSelectedRadius";

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
static NSString * const kStartQuestTakePhotoSegue = @"StartQuestTakePhotoSegue";
static NSString * const kStartQuestViewPhotoSegue = @"StartQuestViewPhotoSegue";


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
static NSString * const kQuestColumnViewPhotoImage = @"image";

//Notification Strings

static NSString * const kQuestQuerySuccesNotification = @"kQuestQuerySuccesNotification";
static NSString * const kQuestQueryFailureNotification = @"kQuestQueryFailureNotification";
static NSString * const kQuestDataChangedNotification = @"kQuestDataChangedNotification";
static NSString * const kQuestUserLocationDidChangeNotification = @"kQuestUserLocationDidChangeNotification";
static NSString * const kQuestQueryNoLocationNotification = @"kQuestQueryNoLocationNotification";
static NSString * const kQuestQueryNoUserNotification = @"kQuestQueryNoUserNotification";
static NSString * const kQuestFilterHasChanged = @"kQuestFilterHasChanged";

//Fetch UserInfo Keys

static NSString * const kFetchOwner = @"kFetchOwner";
static NSString * const kFetchItems= @"kFetchItems";
static NSString * const kFetchType= @"kFetchType";

//Fetch Keys

static NSString * const kQuestFetchImageDataKey = @"kQuestFetchImageDataKey";
static NSString * const kQuestFetchSuccesImageData = @"kQuestFetchSuccesImageData";

//Current Location Key

static NSString * const kQuestCurrentLocation = @"kQuestCurrentLocation";

//Numbers

static CGFloat const kFilterDistance = 1000.0f;
static CGFloat const kHeaderHeight = 25.0f;
static CGFloat const kViewPhotoTime = 60;


#endif
