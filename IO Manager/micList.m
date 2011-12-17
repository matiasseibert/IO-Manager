//
//  micList.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/9/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "micList.h"

@interface micList()
@property (nonatomic, strong) NSArray *mics;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSString *savedSearchTerm;
@property (nonatomic, strong) UIPopoverController *curPopover;
@end

@implementation micList
@synthesize mics;
@synthesize searchResults, savedSearchTerm;
@synthesize delegate;
@synthesize curPopover;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
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
    self.mics = [[DataManager sharedInstance] getMicrophones];
    self.searchResults = [[NSMutableArray alloc] initWithCapacity:[self.mics count]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMicrophone:)];
    self.title = @"Mics";
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

- (void)addMicrophone:(id)sender {
    if (self.curPopover == nil) {
        createMicView *newMicModalVC = [[createMicView alloc] initWithNibName:@"createMicView" bundle:[NSBundle mainBundle]];
        [newMicModalVC setDelegate:self];
        newMicModalVC.nameToUse = nil;
        [newMicModalVC setReturnsToInputView:NO];
        [newMicModalVC setTitle:@"Create New"];
        
        UINavigationController *container = [[UINavigationController alloc] initWithRootViewController:newMicModalVC];
        
        self.curPopover = [[UIPopoverController alloc] initWithContentViewController:container];
        
        [self.curPopover setPopoverContentSize:CGSizeMake(320, 358)];
        [self.curPopover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section
    //NSLog(@"mic count: %d", [self.mics count]);
    if (tableView != self.tableView)
        return [self.searchResults count];
    else
        return [self.mics count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    Microphone *curMic;
    if (tableView != self.tableView)
        curMic = [searchResults objectAtIndex:[indexPath row]];
    else
        curMic = [self.mics objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    curMic = [self.mics objectAtIndex:[indexPath row]];
    cell.textLabel.text = curMic.name;
    
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
    [delegate showDetailForMic:[self.mics objectAtIndex:[indexPath row]] withDelegate:self];
}

#pragma mark Search Display Controller Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    DataManager *dataManager = [DataManager sharedInstance];
    
    // Clear old search results...
    [self.searchResults removeAllObjects];
    
    self.searchResults = [dataManager searchForMicrophoneByName:searchString];
    
    return YES;
}

- (void)clearPopover {
    if (self.curPopover != nil) 
        [self.curPopover dismissPopoverAnimated:YES];
    
    self.curPopover = nil;
    self.mics = [[DataManager sharedInstance] getMicrophones];
    [self.tableView reloadData];
}

- (void)updateListing {
    self.mics = [[DataManager sharedInstance] getMicrophones];
    [self.tableView reloadData];
}

@end
