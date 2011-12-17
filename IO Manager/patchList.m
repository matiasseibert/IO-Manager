//
//  patchList.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/6/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "patchList.h"

@interface patchList()
@property (nonatomic, strong) NSArray *patches;
@property (nonatomic, strong) NSString *myShow;
@property (nonatomic, strong) UIPopoverController *curPopover;

@end

@implementation patchList
@synthesize delegate;
@synthesize patches, myShow, curPopover;

- (id)initWithShow:(NSString *)name {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        myShow = name;
        patches = [[DataManager sharedInstance] getPatchesForShow:myShow];
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
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPatch:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.title = @"Patches";
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
	return NO;
}

- (void)addPatch:(id)sender {
    if (self.curPopover == nil) {
        newPatchPoint *newPatch = [[newPatchPoint alloc] initWithNibName:@"newPatchPoint" bundle:[NSBundle mainBundle]];
        newPatch.delegate = self;
        UINavigationController *container = [[UINavigationController alloc] initWithRootViewController:newPatch];
        self.curPopover = [[UIPopoverController alloc] initWithContentViewController:container];
        [self.curPopover setPopoverContentSize:CGSizeMake(320, 304)];
        [self.curPopover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    
}

#pragma mark - overlayControl Delegate 

- (void)clearPopover {
    [self.curPopover dismissPopoverAnimated:YES];
    self.curPopover = nil;
    self.patches = [[DataManager sharedInstance] getPatchesForShow:[delegate getShowName]];
    [self.tableView reloadData];
}

- (void)clearModalview {
    [self dismissModalViewControllerAnimated:YES];
    self.patches = [[DataManager sharedInstance] getPatchesForShow:[delegate getShowName]];
    [self.tableView reloadData];
}

#pragma mark - inputUpdate Delegate

- (void)updateListing {
    DataManager *dataManager = [DataManager sharedInstance];
    self.patches = [dataManager getPatchesForShow:[delegate getShowName]];
    [self.tableView reloadData];
}

#pragma mark - masterControl Delegate

- (NSString *)getShowName {
    return self.myShow;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.patches count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    PatchPoint *curPatch = [self.patches objectAtIndex:[indexPath row]];
    cell.textLabel.text = curPatch.name;
    cell.detailTextLabel.text = curPatch.location;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    [delegate showDetailForPatch:[self.patches objectAtIndex:[indexPath row]] withDelegate:self];
}

@end
