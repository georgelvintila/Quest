//
//  QuestResultTableViewController.m
//  Quest
//
//  Created by Georgel Vintila on 04/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestResultTableViewController.h"
#import "QuestManager.h"

@implementation QuestResultTableViewController

#pragma mark - TableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.questItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.questItems objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"kQuestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSArray *quests = [self.questItems objectAtIndex:indexPath.section];
    QuestInfo *quest = [quests objectAtIndex:indexPath.row];
    
    cell.textLabel.text = quest.questName;
    cell.textLabel.textColor = [UIColor tintGreenColor];
    cell.detailTextLabel.text = quest.questDetails;
    cell.detailTextLabel.textColor = [UIColor subtitleBlueColor];
    
    return  cell;
}

@end
