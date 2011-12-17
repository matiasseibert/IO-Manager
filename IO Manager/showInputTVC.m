//
//  showInputTVC.m
//  IO Manager
//
//  Created by Matias Seibert on 11/21/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "showInputTVC.h"

@interface showInputTVC()

@property (strong, nonatomic) NSArray *inputList;
@property (strong, nonatomic) NSString *showName;
@property (strong, nonatomic) UIPopoverController *curPopover;
@property (nonatomic, strong) NSIndexPath *curSelected;
@end

@implementation showInputTVC
@synthesize delegate;
@synthesize inputList, showName;
@synthesize curPopover;
@synthesize curSelected;

- (id)initWithShow:(NSString *)name
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        showName = name;
        DataManager *dataManager = [DataManager sharedInstance];
        inputList = [dataManager getInputsForShow:showName];
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
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addInput:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.title = @"Inputs";
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Button Methods

- (void)addInput:(id)sender {
    if (self.curPopover != nil)
        [self clearPopover];
    numInputView *numInput = [[numInputView alloc] initWithValue:1];
    [numInput setDelegate:self];
    UINavigationController *container = [[UINavigationController alloc] initWithRootViewController:numInput];
    numInput.title = @"Inputs to Create";
    self.curPopover = [[UIPopoverController alloc] initWithContentViewController:container];
    [self.curPopover setPopoverContentSize:CGSizeMake(320, 387)];
    [self.curPopover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
    return [inputList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Input *myInput = [inputList objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d. %@", [myInput.number intValue], myInput.name];
    cell.detailTextLabel.text = myInput.micName; 
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Use the delegate to do this:
    self.curSelected = indexPath;
    [delegate showDetailForInput:[inputList objectAtIndex:[indexPath row]] withDelegate:self];
    
}

#pragma mark - overlayControl Delegate 

- (void)clearPopover {
    [self.curPopover dismissPopoverAnimated:YES];
    self.curPopover = nil;
    self.inputList = [[DataManager sharedInstance] getInputsForShow:self.showName];
    [self.tableView reloadData];
}

- (void)receiveNum:(NSInteger)num {
    if (num > 0)
        [[DataManager sharedInstance] createInputs:num inShow:self.showName];
}

#pragma mark - inputUpdate Delegate

- (void)updateListing {
    DataManager *dataManager = [DataManager sharedInstance];
    self.inputList = [dataManager getInputsForShow:self.showName];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:curSelected animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - masterControl Delegate

- (NSString *)getShowName {
    return self.showName;
}

@end
