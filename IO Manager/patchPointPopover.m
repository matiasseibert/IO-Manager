//
//  patchPointPopover.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/12/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "patchPointPopover.h"

@interface patchPointPopover()

@property (nonatomic, strong) NSArray *patchList;
@property (nonatomic, strong) Console *console; 
@property (nonatomic, strong) Show *myShow;
@end

@implementation patchPointPopover
@synthesize delegate, patchList, console, myShow;

- (id)initWithShow:(Show *)show
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        myShow = show;
        console = myShow.console;
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
    self.patchList = [[DataManager sharedInstance] getPatchesForShow:myShow.name];

    self.title = @"Connect to";
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    
    self.navigationItem.rightBarButtonItem = cancel;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"numRows: %d", [self.patchList count] + 1);
    return [self.patchList count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSInteger row = [indexPath row];
    
    if (row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"FOH: %@", self.console.name];
        //NSLog(@"Getting Row 0");
        
    }
    else {
        //NSLog(@"Getting row: %d, patchList index: %d", row, row-1);
        cell.textLabel.text = [[self.patchList objectAtIndex:(row-1)] name];
        cell.detailTextLabel.text = [[self.patchList objectAtIndex:(row-1)] location];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    if (row == 0) {
        channelsInConsole *next = [[channelsInConsole alloc] initWithConsole:self.console];
        [next setDelegate:delegate];
        [self.navigationController pushViewController:next animated:NO];
    }
    else {
        channelsInPatch *next = [[channelsInPatch alloc] initWithPatch:[self.patchList objectAtIndex:row-1]];
        [next setDelegate:delegate];
        [self.navigationController pushViewController:next animated:NO];
    }
}

- (void)cancelPressed:(id)sender {
    [delegate clearPopover];
}

@end
