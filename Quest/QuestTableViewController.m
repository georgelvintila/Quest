//
//  QuestTableViewController.m
//  Quest
//
//  Created by Georgel Vintila on 27/04/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestTableViewController.h"
#import "QuestManager.h"
#import "QuestResultTableViewController.h"
#import "QuestViewController.h"
#import "QuestDetailsViewController.h"

@interface QuestTableViewController ()<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>
#pragma mark - Properties

@property(nonatomic,strong) QuestManager *questManager;
@property(nonatomic,strong) NSArray *allQuestTypes;
@property(nonatomic) QuestOwnerType owner;

@property(nonatomic) NSInteger questType;
@property(nonatomic,strong) UISearchController *searchController;
@property(nonatomic,strong) NSMutableArray *questItems;
@property (nonatomic, strong) QuestResultTableViewController *resultsTableController;

@property (nonatomic, weak) UIViewController* destinationViewController;

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
        _questItems = [NSMutableArray new];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:kQuestDataChangedNotification object:nil];
    
    _resultsTableController = [[QuestResultTableViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchController.searchBar.autocorrectionType =  UITextAutocorrectionTypeNo;
    self.searchController.searchBar.spellCheckingType = UITextSpellCheckingTypeNo;
    
    // refresh controller
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshContent) forControlEvents:UIControlEventValueChanged];
    
    [self requestData];
}

- (void)refreshContent {
    [self requestData];
    [self.tableView reloadData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSLog(@"appear: %@", self.destinationViewController);
    
    // if we had a segue
    if (self.destinationViewController) {
        self.destinationViewController = nil;
        
        // it's not hidden
        [self.tabBarController.tabBar setHidden:NO];
        
        // move the tab bar down
        CGRect frameOld = self.tabBarController.tabBar.frame;
        CGRect frameNew = CGRectMake(frameOld.origin.x, frameOld.origin.y + frameOld.size.height, frameOld.size.width, frameOld.size.height);
        
        self.tabBarController.tabBar.frame = frameNew;
        
        // animate the tab bar coming up
        [UIView animateWithDuration:0.3 animations:^{
            self.tabBarController.tabBar.frame = frameOld;
        }];
    }
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    NSLog(@"dissapear: %@", self.destinationViewController);
    if (self.destinationViewController) {
       [self.tabBarController.tabBar setHidden:YES];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQuestDataChangedNotification object:nil];
}

#pragma mark - Deletion of elements


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.questManager deleteQuestOfType:self.allQuestTypes[indexPath.section] atIndex:indexPath.item];
        [self reloadData:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.owner == QuestOwnerTypeOthers)
        return NO;
    return YES;
}


#pragma mark - Data Methods

-(void) requestData
{
    [self.questManager requestAllItemsForOwner:self.owner];

}

-(void)reloadData:(NSNotification*)notification
{
    self.allQuestTypes = [self.questManager allQuestTypesForOwner:self.owner];
    [self.questItems removeAllObjects];
    for (NSString *type in self.allQuestTypes) {
    [self.questItems addObject:[self.questManager questListOfType:type forOwner:self.owner]];
    }
    
    [self.tableView reloadData];
    
    [self.refreshControl endRefreshing];
}

#pragma mark - Table View Data Source Methods

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([self.questItems[section] count])
    {
        UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCellHeaderIdentifier];
        if(!view)
        {
            view = [[UIView alloc] init];
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 0, 0)];
        view.backgroundColor = [UIColor headerBackgroundColor];
        label.text = [self.allQuestTypes objectAtIndex:section];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor tintGreenColor];
        [view addSubview:label];
        [label sizeToFit];
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([self.questItems[section] count])
    {
        return 25;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.owner == QuestOwnerTypeOthers)
    {
        NSArray *quests = [self.questItems objectAtIndex:indexPath.section];
        QuestInfo *quest = [quests objectAtIndex:indexPath.row];
        QuestDetailsViewController *questDetailsViewController = (QuestDetailsViewController*)self.destinationViewController;
        questDetailsViewController.questInfo = quest;
    }
    else if(self.owner == QuestOwnerTypeCurrent)
    {
        NSString *questTypeString = [self.allQuestTypes objectAtIndex:indexPath.section];
        if (questTypeString == kQuestTypeTakePhotoQuest) {
            self.questType = QuestTypeTakePhoto;
        }
        else
            if (questTypeString == kQuestTypeViewPhotoQuest)
            {
                self.questType = QuestTypeViewPhoto;
            }
    
        NSArray *quests = [self.questItems objectAtIndex:indexPath.section];
        
        QuestViewController *questViewController = (QuestViewController *)self.destinationViewController;
        questViewController.questType = self.questType;
        
        questViewController.questIndex = indexPath.row;
        questViewController.editMode = YES;
        switch (self.questType) {
            case QuestTypeTakePhoto:
            {
                TakePhotoQuestInfo *quest = [quests objectAtIndex:indexPath.row];
                questViewController.takePhotoQuestInfo = quest;
            }
                break;
                
            default:
                break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.questItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[self.questItems objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = kCellIdentifierQuest;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
   
    NSArray *quests = [self.questItems objectAtIndex:indexPath.section];
    QuestInfo *quest = [quests objectAtIndex:indexPath.row];

    cell.textLabel.text = quest.questName;
    cell.detailTextLabel.text = quest.questDetails;
    
    [cell viewWithTag:kCellIncompleteTag].hidden = quest.questComplete;
    
    return  cell;
}  


#pragma mark - Action Methods

- (IBAction)showQuestSheet:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Quest Types" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"View Photo", nil];
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
        {
            self.questType = QuestTypeTakePhoto;
            [self performSegueWithIdentifier:kQuestSegue sender: self];
        }
            break;
        case 1:
        {
            self.questType = QuestTypeViewPhoto;
            [self performSegueWithIdentifier:kQuestSegue sender: self];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - Search Results Updating Methods

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = self.searchController.searchBar.text;
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *allFilteredItems = [NSMutableArray new];
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }

    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems)
    {
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"questName"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        lhs = [NSExpression expressionForKeyPath:@"questDetails"];
        rhs = [NSExpression expressionForConstantValue:searchString];
        finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    for (NSUInteger index = 0; index <[self.questItems count]; index ++)
    {
        NSArray * searchResults = [self.questItems objectAtIndex: index];
        NSCompoundPredicate *finalCompoundPredicate =
        [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
        searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
        [allFilteredItems addObject: searchResults];
        
    }
    // hand over the filtered results to our search results table
    QuestResultTableViewController *tableController = (QuestResultTableViewController *)self.searchController.searchResultsController;
    tableController.questItems = allFilteredItems;
    [tableController.tableView reloadData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.destinationViewController = segue.destinationViewController;
}

@end
