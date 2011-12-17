//
//  channelsInPatch.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/12/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "channelsInPatch.h"

@interface channelsInPatch()
@property (nonatomic, strong) NSArray *channels;
@property (nonatomic, strong) PatchPoint *myPatch;
@end

@implementation channelsInPatch
@synthesize delegate, channels, myPatch;

- (id)initWithPatch:(PatchPoint *)patch
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        myPatch = patch;
        channels = [[DataManager sharedInstance] getOpenInputChannelsForPatch:myPatch];
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
    self.title = @"Open Channels";
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    
    self.navigationItem.rightBarButtonItem = cancel;
    
    //[self setContentSizeForViewInPopover:CGSizeMake(320, 314)];
                               
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
    return [self.channels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Channel %d", [[self.channels objectAtIndex:[indexPath row]] intValue]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataManager *dataManager = [DataManager sharedInstance];
    
    NSInteger c = [[self.channels objectAtIndex:[indexPath row]] intValue];
    
    [dataManager connectInput:[delegate getInput] toPatch:self.myPatch inChannel:c];
    
    [delegate clearPopover];
}

- (void)cancelPressed:(id)sender {
    [delegate clearPopover];
}

@end
