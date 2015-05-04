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

@interface QuestTableViewController ()<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>
#pragma mark - Properties

@property(nonatomic,strong) QuestManager *questManager;
@property(nonatomic,strong) NSArray *allQuestTypes;
@property(nonatomic) QuestOwnerType owner;

@property(nonatomic) NSInteger questType;
@property(nonatomic,strong) UISearchController *searchController;
@property(nonatomic,strong) NSMutableArray *questItems;
@property (nonatomic, strong) QuestResultTableViewController *resultsTableController;



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
    [self requestData];
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
    [self.questItems removeAllObjects];
    for (NSString *type in self.allQuestTypes) {
        [self.questItems addObject:[self.questManager questListOfType:type forOwner:self.owner]];
    }
    [self.tableView reloadData];
}

#pragma mark - Table View Data Source Methods

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.questItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self.questItems objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = kCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSArray *quests = [self.questItems objectAtIndex:indexPath.section];
    QuestInfo *quest = [quests objectAtIndex:indexPath.row];

    cell.textLabel.text = quest.questName;
    cell.detailTextLabel.text = quest.questDetails;
    
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
            self.questType = TakePhoto;
            [self performSegueWithIdentifier:kQuestSegue sender: self];
        }
            break;
        case 1:
        {
            self.questType = ViewPhoto;
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
    QuestViewController *destination = (QuestViewController *)[segue destinationViewController];
    destination.questType = self.questType;
}

@end
