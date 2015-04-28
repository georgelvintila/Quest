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

static NSString * const kQuestTypeTakePhoto = @"TakePhoto";
static NSString * const kQuestTypeSeePhoto = @"SeePhoto";

//General Quest Property Keys

static NSString * const kQuestColumnName = @"name";
static NSString * const kQuestColumnDetail = @"description";
static NSString * const kQuestColumnLocation = @"location";
static NSString * const kQuestColumnOwner = @"owner";
static NSString * const kQuestColumnCreatedAt = @"createdAt";
static NSString * const kQuestColumnUpdatedAt = @"updatedAt";
static NSString * const kQuestColumnACL = @"ACL";
static NSString * const kQuestColumnObjectId = @"objectId";

//Specific Quest Property Keys
//Take Photo
static NSString * const kQuestColumnTakePhotoAngle = @"angle";
static NSString * const kQuestColumnTakePhotoRadius = @"radius";

//Notification Strings
static NSString * const kMyQuestQuerySuccesNotification = @"kMyQuestQuerySuccesNotification";
static NSString * const kMyQuestQueryFailureNotification = @"kMyQuestQueryFailureNotification";

#endif
