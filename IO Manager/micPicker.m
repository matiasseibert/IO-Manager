//
//  micPicker.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/3/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "micPicker.h"

@interface micPicker() 
@property (nonatomic, strong) NSArray *micList;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic) BOOL hasMatch;
@end

@implementation micPicker
@synthesize micList, searchTerm, hasMatch;
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        DataManager *dataManager = [DataManager sharedInstance];
        micList = [dataManager searchForMicrophoneByName:nil];
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

- (void)viewWillAppear:(BOOL)animated {
    self.contentSizeForViewInPopover = CGSizeMake(320, 302);
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Choose Microphone";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (void)cancelPressed:(id)sender {
    [delegate clearPopover];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.micList count] == 0)
        return 1;
    
    return [self.micList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([self.micList count] != 0) {
        Microphone *curMic = [self.micList objectAtIndex:[indexPath row]];
        cell.textLabel.text = curMic.name;
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"Create \"%@\"", self.searchTerm];
    }
    
    return cell;
}

- (void)updateSearchTerm:(NSString *)name {
    self.micList = [[DataManager sharedInstance] searchForMicrophoneByName:name];
    self.hasMatch = [[DataManager sharedInstance] micExistsNamed:name];
    self.searchTerm = name;
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.micList count] != 0) {
        Microphone *curMic = [self.micList objectAtIndex:[indexPath row]];
        [delegate choseExisting];
        [delegate setMicNamed:curMic.name];
        [delegate clearPopover];
    }
    else {
        [delegate choseExisting];
        createMicView *newMicModalVC = [[createMicView alloc] initWithNibName:@"createMicView" bundle:[NSBundle mainBundle]];
        [newMicModalVC setDelegate:self.delegate];
        newMicModalVC.nameToUse = self.searchTerm;
        [newMicModalVC setReturnsToInputView:YES];
        [newMicModalVC setTitle:@"Create New"];
        [self.navigationController pushViewController:newMicModalVC animated:NO];
    }
}

- (void)pushCreateMicView {
    [delegate choseExisting];
    createMicView *newMicModalVC = [[createMicView alloc] initWithNibName:@"createMicView" bundle:[NSBundle mainBundle]];
    [newMicModalVC setDelegate:self.delegate];
    newMicModalVC.nameToUse = self.searchTerm;
    [newMicModalVC setReturnsToInputView:YES];
    [newMicModalVC setTitle:@"Create New"];
    [self.navigationController pushViewController:newMicModalVC animated:YES];
}

@end
