//
//  showListingTVC.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/1/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "showListingTVC.h"

@interface showListingTVC()

@property (nonatomic, strong) NSArray *showNames;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSString *savedSearchTerm;
@property (nonatomic, strong) UIPopoverController *curPopover;
@end

@implementation showListingTVC
@synthesize delegate;
@synthesize showNames, searchResults, savedSearchTerm, curPopover;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    showNames = [[DataManager sharedInstance] getShowList];
    
    searchResults = [[NSMutableArray alloc] initWithCapacity:[showNames count]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newShow:)];
    
    // Restore search term
    if ([self savedSearchTerm])
    {
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }
    self.title = @"My Shows";
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [delegate showBlankDetail];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView != self.tableView)
        return [searchResults count];
    else
        return [showNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    Show *curShow;
    if (tableView != self.tableView)
        curShow = [searchResults objectAtIndex:[indexPath row]];
    else
        curShow = [showNames objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.text = curShow.name;
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:curShow.lastOpened dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    if(dateString == nil)
        dateString = @"Never";
    NSString *subTitle = [NSString stringWithFormat:@"Last Opened: %@", dateString];
    cell.detailTextLabel.text = subTitle;
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Show *curShow;
    if (tableView != self.tableView)
        curShow = [searchResults objectAtIndex:[indexPath row]];
    else
        curShow = [showNames objectAtIndex:[indexPath row]];
    
    [delegate loadShow:curShow.name];
    showMasterVC *masterList = [[showMasterVC alloc] initWithNibName:@"showMasterVC" bundle:[NSBundle mainBundle]];
    [masterList setDelegate:self.delegate];
    
    [self.navigationController pushViewController:masterList animated:YES];
}

#pragma mark Search Display Controller Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    DataManager *dataManager = [DataManager sharedInstance];
    
    // Clear old search results...
    [self.searchResults removeAllObjects];
    
    self.searchResults = [dataManager searchForShowByName:searchString];
    
    return YES;
}

#pragma mark overlayControl Delegate

- (void)clearModalview {
    [self dismissModalViewControllerAnimated:YES];
    self.showNames = [[DataManager sharedInstance] getShowList];
    [self.tableView reloadData];
}

- (void)clearPopover {
    [self.curPopover dismissPopoverAnimated:YES];
    self.curPopover = nil;
    self.showNames = [[DataManager sharedInstance] getShowList];
    [self.tableView reloadData];
}

#pragma mark button Delegate
- (void)newShow:(id)sender {
    if (self.curPopover != nil) {
        [self clearPopover];
    }
    else {
        newShowVC *newShow = [[newShowVC alloc] initWithNibName:@"newShowVC" bundle:[NSBundle mainBundle]];
        [newShow setDelegate:self];
        
        UINavigationController *container = [[UINavigationController alloc] initWithRootViewController:newShow];
        newShow.title = @"Create Show";
        self.curPopover = [[UIPopoverController alloc] initWithContentViewController:container];
        [self.curPopover setDelegate:self];
        [self.curPopover setPopoverContentSize:CGSizeMake(320, 352)];
        [self.curPopover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}
@end
