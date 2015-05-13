//
//  FilterTableViewController.h
//  Quest
//
//  Created by Georgel Vintila on 04/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsFilterDelegate <NSObject>

- (void)filterDidSelectQuestType:(NSString *)questType;

@end


@interface FilterTableViewController : UITableViewController

@property (weak, nonatomic) id<SettingsFilterDelegate> delegate;
@property (strong, nonatomic) NSString *currentSelectedFilterType;

@end
