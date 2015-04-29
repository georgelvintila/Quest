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

@end

@implementation QuestTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _questManager = [QuestManager sharedManager];
        _allQuestTypes = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.questManager requestAllItemsForOwner:QuestOwnerTypeOthers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kMyQuestQuerySuccesNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)reloadData
{
    self.allQuestTypes = self.questManager.allQuestTypes;
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
     return [[self.questManager.myQuests objectForKey:[self.allQuestTypes objectAtIndex:section]] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    PFObject *quest = [((NSArray *)[self.questManager.myQuests objectForKey:[self.allQuestTypes objectAtIndex:indexPath.section]]) objectAtIndex:indexPath.row];
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
