//
//  showMasterVC.m
//  IO Manager
//
//  Created by Matias Seibert on 11/21/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "showMasterVC.h"

@interface showMasterVC()

@property (nonatomic, retain) NSArray *categories;

@end

@implementation showMasterVC
@synthesize delegate;
@synthesize categories;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSArray *connectionsArray = [NSArray arrayWithObjects:@"Inputs", @"Patches", @"Console", nil];
        NSArray *infoArray = [NSArray arrayWithObjects:@"Equipment List", @"System Diagram", @"Notes", nil];
        NSArray *designArray = [NSArray arrayWithObjects:@"Scenes", @"Cues", nil];
        
        NSDictionary *connectionsDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Connections", @"name", connectionsArray, @"rows", nil];
        //NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Info", @"name", infoArray, @"rows", nil];
        //NSDictionary *designDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Design", @"name", designArray, @"rows", nil];
        
        categories = [NSArray arrayWithObjects:connectionsDict, nil];
        
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
//    UIBarButtonItem *loadShowButton = [[UIBarButtonItem alloc] initWithTitle:@"Load Show" style:UIBarButtonItemStylePlain target:self action:@selector(loadShow:)];
//    self.navigationItem.rightBarButtonItem = loadShowButton;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = [delegate getShowName];
    [delegate showDetailForShowWithDelegate:self];

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
    return [categories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[categories objectAtIndex:section] objectForKey:@"rows"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[[categories objectAtIndex:[indexPath section]] objectForKey:@"rows"] objectAtIndex:[indexPath row]];
    
    if ([indexPath section] == 0)
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[categories objectAtIndex:section] objectForKey:@"name"];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([indexPath section] == 0) {
        if ([indexPath row] == 0) {
            showInputTVC *inputView = [[showInputTVC alloc] initWithShow:[delegate getShowName]];
            [inputView setDelegate:delegate];
            [self.navigationController pushViewController:inputView animated:YES];
        }
        if ([indexPath row] == 1) {
            // push new patchList 
            patchList *patchesView = [[patchList alloc] initWithShow:[delegate getShowName]];
            [patchesView setDelegate:delegate];
            [self.navigationController pushViewController:patchesView animated:YES];
        }
        if ([indexPath row] == 2) {
            [delegate showDetailForConsole];
        }
    }
    else
    {
        // tell the delegate to display a view controller.
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - masterControl Delegate

-(void)loadShow:(NSString *)name {
    [delegate loadShow:name];
    self.title = name;
}

@end
