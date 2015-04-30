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

#pragma mark - Properties

@property(nonatomic,strong) QuestManager *questManager;
@property(nonatomic,strong) NSArray *allQuestTypes;
@property(nonatomic) QuestOwnerType owner;

@end

#pragma mark -

@implementation QuestTableViewController

#pragma mark - Instantiation

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

#pragma mark - Base Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:kQuestDataChangedNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQuestDataChangedNotification object:nil];
}

#pragma mark - Data Methods

-(void) requestData
{
    [self.questManager requestAllItemsForOwner:self.owner];

}

-(void)reloadData:(NSNotification*)notification
{
    self.allQuestTypes = [self.questManager allQuestTypesForOwner:self.owner];
    [self.tableView reloadData];
}

#pragma mark - Table View Data Source Methods

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

    return [self.allQuestTypes count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self.questManager questListOfType:self.allQuestTypes[section] forOwner:self.owner] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    Quest *quest = [((NSArray *)[self.questManager questListOfType:self.allQuestTypes[indexPath.section] forOwner:self.owner]) objectAtIndex:indexPath.row];

    cell.textLabel.text = quest.name;
    cell.detailTextLabel.text = quest.details;
    
    return  cell;
}  

#pragma mark - Action Methods

- (IBAction)showQuestSheet:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Quest Types" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", nil];
   // actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];    
}

#pragma mark - Action Sheet Delegate Methods

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
        default:
            break;
    }
}

@end
