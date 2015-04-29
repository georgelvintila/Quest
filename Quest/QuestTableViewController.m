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
@property(nonatomic,strong) NSMutableArray *allQuestTypes;

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
    [self.questManager requestMyQuests];
    [self.allQuestTypes addObjectsFromArray:self.questManager.myQuests.allKeys];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kMyQuestQuerySuccesNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)reloadData
{
    [self.allQuestTypes addObjectsFromArray:self.questManager.myQuests.allKeys];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
