//
//  FilterTableViewController.m
//  Quest
//
//  Created by Georgel Vintila on 04/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "FilterTableViewController.h"

@interface FilterTableViewController ()

#pragma mark - Properties

@property (nonatomic, strong) NSArray *filterTypes;

@end

#pragma mark -

@implementation FilterTableViewController

#pragma mark - Base Class Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filterTypes = @[kQuestTypeAllQuests,kQuestTypeTakePhotoQuest,kQuestTypeViewPhotoQuest];
}


#pragma mark - TableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filterTypes count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = kCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.filterTypes objectAtIndex:indexPath.row];
    
    if ([cell.textLabel.text isEqualToString:self.currentSelectedFilterType]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
    
}

-(void)tableView:tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *oldValue = self.currentSelectedFilterType;
    NSString *newValue = [self.filterTypes objectAtIndex:indexPath.row];

    UITableViewCell *cellNew = [tableView cellForRowAtIndexPath:indexPath];
    UITableViewCell *cellOld = [tableView cellForRowAtIndexPath: [NSIndexPath indexPathForItem: [self.filterTypes indexOfObject: oldValue] inSection:0]];
    
    cellOld.accessoryType = UITableViewCellAccessoryNone;
    cellNew.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if (self.delegate)
        [self.delegate filterDidSelectQuestType: newValue];
    
    [cellNew setSelected:NO animated:YES];
    
    self.currentSelectedFilterType = newValue;
}


// hide sections not used
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

@end
