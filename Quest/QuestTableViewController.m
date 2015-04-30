//
//  QuestTableViewController.m
//  Quest
//
//  Created by Georgel Vintila on 27/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestTableViewController.h"
#import "QuestManager.h"

@interface QuestTableViewController ()

@property(nonatomic,strong) QuestManager *questManager;
@property(nonatomic,strong) NSArray *allQuestTypes;
@property(nonatomic) QuestOwnerType owner;

@end

@implementation QuestTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _questManager = [QuestManager sharedManager];
        _allQuestTypes = [NSMutableArray new];
        if ([self.title isEqualToString:kQuestTableViewControllerTitleMyQuests]) {
            _owner = QuestOwnerTypeCurrent;
        }
        else
        {
            if ([self.title isEqualToString:kQuestTableViewControllerTitleOtherQuests])
            {
               _owner = QuestOwnerTypeOthers;
            }
            else
            {
                _owner = QuestOwnerTypeAll;
            }
        }

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:kQuestDataChangedNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQuestDataChangedNotification object:nil];
}

-(void) requestData
{
    [self.questManager requestAllItemsForOwner:self.owner];

}

-(void)reloadData:(NSNotification*)notification
{
    self.allQuestTypes = [self.questManager allQuestTypesForOwner:self.owner];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerId"];
    if(!view)
    {
        view = [[UIView alloc] init];
    }
    UILabel *label = [[UILabel alloc] init];
    
    view.backgroundColor = [UIColor grayColor];
    label.text = [self.allQuestTypes objectAtIndex:section];
    [view addSubview:label];
    [label sizeToFit];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.allQuestTypes count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    
    switch (self.owner) {
        case QuestOwnerTypeCurrent:
            return [[self.questManager.myQuests objectForKey:[self.allQuestTypes objectAtIndex:section]] count];
            break;
        case QuestOwnerTypeOthers:
            return [[self.questManager.otherQuests objectForKey:[self.allQuestTypes objectAtIndex:section]] count];
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    PFObject *quest = nil;
    
    switch (self.owner) {
        case QuestOwnerTypeCurrent:
            quest = [((NSArray *)[self.questManager.myQuests objectForKey:[self.allQuestTypes objectAtIndex:indexPath.section]]) objectAtIndex:indexPath.row];
            break;
        case QuestOwnerTypeOthers:
            quest = [((NSArray *)[self.questManager.otherQuests objectForKey:[self.allQuestTypes objectAtIndex:indexPath.section]]) objectAtIndex:indexPath.row];

            break;
        default:
            break;
    }

    cell.textLabel.text = quest.name;
    cell.detailTextLabel.text = quest.details;
    
    return  cell;
    
}  

- (IBAction)showQuestSheet:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Quest Types" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", nil];
   // actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    actionSheet.delegate = nil;
    switch (buttonIndex)
    {
        case 0:
        [self performSegueWithIdentifier: @"TakePhotoSegue" sender: self];
            break;
        case 1:
            break;

    }
}


@end
