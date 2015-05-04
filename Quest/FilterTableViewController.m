//
//  FilterTableViewController.m
//  Quest
//
//  Created by Georgel Vintila on 04/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "FilterTableViewController.h"

@interface FilterTableViewController ()

@property (nonatomic, strong) NSArray *filterTypes;

@end

@implementation FilterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filterTypes = @[kQuestTypeAllQuests,kQuestTypeTakePhotoQuest,kQuestTypeViewPhotoQuest];
}


#pragma mark - Table view data source

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.filterTypes objectAtIndex:indexPath.row];
    return  cell;
    
}

-(void)tableView:tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setObject:[self.filterTypes objectAtIndex:indexPath.row] forKey:kQuestSelectedFilterType];
}

@end
