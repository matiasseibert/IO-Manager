//
//  patcherView.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/10/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "patcherView.h"

#define START_Y 130
#define START_X 18
#define START_XR 530
#define DELTA_Y 73
#define DELTA_X 62
#define BUTTON_WIDTH 44
#define BUTTON_HEIGHT 44
#define LABEL_WIDTH 42
#define LABEL_HEIGHT 21
#define LEFT_TAG 100
#define LEFT_OUT_TAG 200
#define RIGHT_TAG 300
#define RIGHT_OUT_TAG 400

@interface patcherView()
@property (nonatomic, strong) PatchPoint *patchOne;
@property (nonatomic, strong) PatchPoint *patchTwo;
@property (nonatomic, strong) NSArray *patchPoints;
@property (nonatomic) NSInteger yStart;
@property (nonatomic, strong) UIPopoverController *curPopover;
@property (nonatomic, strong) UIButton *selectedLeft;
@property (nonatomic, strong) UIButton *selectedRight;

@property (nonatomic) BOOL editingPatchOne;
@property (nonatomic) BOOL editingPatchTwo;

- (void)updateLeftButtons;
- (void)updateRightButtons;
- (void)clearLeftElements;
- (void)clearRightElements;
- (void)createButtonTitled:(NSString *)title atX:(NSInteger)x_index atY:(NSInteger)y_index onSide:(BOOL)leftSide withTag:(NSInteger)tag;
- (void)createLabelTitled:(NSString *)title atX:(NSInteger)x_index atY:(NSInteger)y_index onSide:(BOOL)leftSide withTag:(NSInteger)tag;
- (void)buttonPressed:(id)sender;
- (void)makeConnection;
@end

@implementation patcherView
@synthesize segSwitch;
@synthesize snakeOneField;
@synthesize snakeTwoField;
@synthesize delegate;
@synthesize patchOne, patchTwo, patchPoints;
@synthesize curPopover;
@synthesize editingPatchOne, editingPatchTwo;
@synthesize yStart;
@synthesize selectedLeft, selectedRight;

- (id)initWithPatchPoint:(PatchPoint *)firstPatch
{
    self = [super initWithNibName:@"patcherView" bundle:[NSBundle mainBundle]];
    if (self) {
        patchOne = firstPatch;
        patchPoints = [[DataManager sharedInstance] getPatchesForShow:[delegate getShowName]];
    }
    return self;
}

- (IBAction)segChanged:(id)sender {
    [self clearLeftElements];
    [self clearRightElements];
    [self updateLeftButtons];
    [self updateRightButtons];
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
    // Do any additional setup after loading the view from its nib.
    //patchPoints = [[DataManager sharedInstance] getPatchesForShow:[delegate getShowName]];
    self.yStart = START_Y;
    self.snakeOneField.text = self.patchOne.name;
    [self updateLeftButtons];
}

- (void)viewDidUnload
{
    [self setSegSwitch:nil];
    [self setSnakeOneField:nil];
    [self setSnakeTwoField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)donePressed:(id)sender {
    [delegate clearModalview];
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (self.curPopover != nil) {
        [self clearPopover];
    }
    
    self.patchPoints = [[DataManager sharedInstance] getPatchesForShow:[delegate getShowName]];
    
    if (textField == self.snakeOneField) {
        
        UITableViewController *patcherTable = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        [patcherTable.tableView setDelegate:self];
        [patcherTable.tableView setDataSource:self];
        
        UINavigationController *container = [[UINavigationController alloc] initWithRootViewController:patcherTable];
        patcherTable.title = @"Select Patcher";
        self.curPopover = [[UIPopoverController alloc] initWithContentViewController:container];
        [self.curPopover setPopoverContentSize:CGSizeMake(320, 358)];
        [self.curPopover presentPopoverFromRect:self.snakeOneField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        self.editingPatchOne = YES;
    }
    
    if (textField == self.snakeTwoField) {
        UITableViewController *patcherTable = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        [patcherTable.tableView setDelegate:self];
        [patcherTable.tableView setDataSource:self];
        
        UINavigationController *container = [[UINavigationController alloc] initWithRootViewController:patcherTable];
        patcherTable.title = @"Select Patcher";

        self.curPopover = [[UIPopoverController alloc] initWithContentViewController:container];
        [self.curPopover setPopoverContentSize:CGSizeMake(320, 358)];
        [self.curPopover presentPopoverFromRect:self.snakeTwoField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        self.editingPatchTwo = YES;
    }
    
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.patchPoints count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    PatchPoint *cur = [self.patchPoints objectAtIndex:[indexPath row]];
    
    if (self.editingPatchOne) {
        if (cur == self.patchOne) 
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    if (self.editingPatchTwo) {
        if (cur == self.patchTwo)
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    cell.textLabel.text = cur.name;
    cell.detailTextLabel.text = cur.location;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editingPatchOne) {
        if (self.patchTwo == [self.patchPoints objectAtIndex:[indexPath row]]) {
            self.patchTwo = self.patchOne;
            self.snakeTwoField.text = self.patchOne.name;
            [self clearRightElements];
            [self updateRightButtons];
        }
        self.patchOne = [self.patchPoints objectAtIndex:[indexPath row]];
        self.snakeOneField.text = self.patchOne.name;
        self.editingPatchOne = NO;
        [self clearLeftElements];
        [self updateLeftButtons];
        [self clearPopover];
    }
    
    if (self.editingPatchTwo) {
        if (self.patchOne == [self.patchPoints objectAtIndex:[indexPath row]]) {
            self.patchOne = self.patchTwo;
            self.snakeOneField.text = self.patchTwo.name;
            [self clearLeftElements];
            [self updateLeftButtons];
        }
        self.patchTwo = [self.patchPoints objectAtIndex:[indexPath row]];
        self.snakeTwoField.text = self.patchTwo.name;
        self.editingPatchTwo = NO;
        [self clearRightElements];
        [self updateRightButtons];
        [self clearPopover];
    }
}

#pragma mark - overlayControl Delegate

- (void)clearPopover {
    if (self.curPopover != nil) {
        [self.curPopover dismissPopoverAnimated:YES];
        self.curPopover = nil;
    }
    self.editingPatchOne = NO;
    self.editingPatchTwo = NO;
}

// WARNING!!! Bad code below.
// ...unfold at your own peril.

- (void)createButtonTitled:(NSString *)title atX:(NSInteger)x_index atY:(NSInteger)y_index onSide:(BOOL)leftSide withTag:(NSInteger)tag {
    UIButton *newButton = [[UIButton alloc] init];
    
    if (leftSide) {
        [newButton setFrame:CGRectMake(START_X + (x_index * DELTA_X), self.yStart+LABEL_HEIGHT + (y_index * DELTA_Y), BUTTON_WIDTH, BUTTON_HEIGHT)];
    }
    else {
        [newButton setFrame:CGRectMake(START_XR + (x_index * DELTA_X), self.yStart+LABEL_HEIGHT + (y_index * DELTA_Y), BUTTON_WIDTH, BUTTON_HEIGHT)];
    }
    [newButton setBackgroundImage:[UIImage imageNamed:@"circleUnpressed.png"] forState:UIControlStateNormal];
    [newButton setBackgroundImage:[UIImage imageNamed:@"circlePressed.png"] forState:UIControlStateHighlighted];
    [newButton setBackgroundImage:[UIImage imageNamed:@"circlePressed.png"] forState:UIControlStateSelected];
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton setTitle:title forState:UIControlStateSelected];
    [newButton setTitle:title forState:UIControlStateHighlighted];
    [newButton setTag:tag];
    newButton.titleLabel.font = [UIFont systemFontOfSize:14];    
    [newButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:newButton];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        newButton.transform = CGAffineTransformScale(newButton.transform, 1.2, 1.2);
        newButton.transform = CGAffineTransformScale(newButton.transform, .83, .83);
    } completion:nil];
}

- (void)createLabelTitled:(NSString *)title atX:(NSInteger)x_index atY:(NSInteger)y_index onSide:(BOOL)leftSide withTag:(NSInteger)tag {
    UILabel *newLabel = [[UILabel alloc] init];
    [newLabel setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.0]];
    if (leftSide) {
        [newLabel setFrame:CGRectMake(START_X + (x_index * DELTA_X), self.yStart + (y_index * DELTA_Y), LABEL_WIDTH, LABEL_HEIGHT)];
    }
    else {
        [newLabel setFrame:CGRectMake(START_XR + (x_index * DELTA_X), self.yStart + (y_index * DELTA_Y), LABEL_WIDTH, LABEL_HEIGHT)];
    }
    newLabel.font = [UIFont boldSystemFontOfSize:12];
    newLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    newLabel.text = title;
    [newLabel setTextAlignment:UITextAlignmentCenter];
    [newLabel setTag:tag];
    [self.view addSubview:newLabel];
}

- (void)updateLeftButtons {
    
    // mad button and label creation.
    NSInteger x = 0;
    NSInteger y = 0;

    NSInteger end = [self.patchOne.maxIn intValue];
    
    for (int i = 1; i <= end; i++) {
        if (x == 8) {
            x = 0;
            y++;
        }
        NSString *title = nil;
        if (self.segSwitch.selectedSegmentIndex == 0) 
            title = [[DataManager sharedInstance] getOutputNumber:i forPatch:self.patchOne];
        else
            title = [[DataManager sharedInstance] getInputNumber:i forPatch:self.patchOne];
        [self createButtonTitled:title atX:x atY:y onSide:YES withTag:LEFT_TAG+i];
        NSString *labelTitle = [NSString stringWithFormat:@"%d", i];
        [self createLabelTitled:labelTitle atX:x atY:y onSide:YES withTag:LEFT_TAG];
        x++;
    }
    /*
    index = 0;
    self.yStart = START_Y + (DELTA_Y * (index_y + 1));
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(START_X-18, self.yStart, 513, 32)];
    [newLabel setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.0]];
    newLabel.font = [UIFont boldSystemFontOfSize:16];
    newLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    newLabel.text = @"Outputs";
    [newLabel setTextAlignment:UITextAlignmentCenter];
    [newLabel setTag:LEFT_TAG];
    [self.view addSubview:newLabel];
    index_y = 0;
    self.yStart += 32;
    
    end = [self.patchOne.maxOut intValue];
    
    for (int i = 1; i <= end; i++) {
        if (index == 8) {
            index = 0;
            index_y++;
        }
        
        NSString *title;
        if (self.segSwitch.selectedSegmentIndex == 0)
            title = [[DataManager sharedInstance] getPatchOutNumber:i forPatch:self.patchOne];
        else
            title = [[DataManager sharedInstance] getPatchInNumber:i forPatch:self.patchOne];
        
        [self createButtonTitled:title atX:index atY:index_y onSide:YES withTag:LEFT_OUT_TAG + i];
        
        NSString *labelTitle = [NSString stringWithFormat:@"%d", i];
        [self createLabelTitled:labelTitle atX:index atY:index_y onSide:YES withTag:LEFT_OUT_TAG];
        
        index++;
    }*/
    self.yStart = START_Y;
}

- (void)updateRightButtons {    
    NSInteger x = 0;
    NSInteger y = 0;
    
    NSInteger end = [self.patchTwo.maxIn intValue];
    
    for (int i = 1; i <= end; i++) {
        if (x == 8) {
            x = 0;
            y++;
        }
        NSString *title = nil;
        if (self.segSwitch.selectedSegmentIndex == 1) 
            title = [[DataManager sharedInstance] getOutputNumber:i forPatch:self.patchTwo];
        else
            title = [[DataManager sharedInstance] getInputNumber:i forPatch:self.patchTwo];
        
        [self createButtonTitled:title atX:x atY:y onSide:NO withTag:RIGHT_TAG+i];
        NSString *labelTitle = [NSString stringWithFormat:@"%d", i];
        [self createLabelTitled:labelTitle atX:x atY:y onSide:NO withTag:RIGHT_TAG];
        x++;
    }
    /*
    index = 0;
    self.yStart = START_Y + (DELTA_Y * (index_y + 1));
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(START_XR-18, self.yStart, 513, 32)];
    [newLabel setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.0]];
    newLabel.font = [UIFont boldSystemFontOfSize:16];
    newLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    newLabel.text = @"Outputs";
    [newLabel setTextAlignment:UITextAlignmentCenter];
    [newLabel setTag:RIGHT_TAG];
    [self.view addSubview:newLabel];
    index_y = 0;
    self.yStart += 32;
    
    end = [self.patchTwo.maxOut intValue];
    
    for (int i = 1; i <= end; i++) {
        if (index == 8) {
            index = 0;
            index_y++;
        }
        NSString *title;
        
        if (self.segSwitch.selectedSegmentIndex == 1)
            title = [[DataManager sharedInstance] getPatchOutNumber:i forPatch:self.patchTwo];
        else
            title = [[DataManager sharedInstance] getPatchInNumber:i forPatch:self.patchTwo];
        
        [self createButtonTitled:title atX:index atY:index_y onSide:NO withTag:RIGHT_OUT_TAG + i];
        NSString *labelTitle = [NSString stringWithFormat:@"%d", i];
        [self createLabelTitled:labelTitle atX:index atY:index_y onSide:NO withTag:RIGHT_OUT_TAG];
        index++;
    }*/
    self.yStart = START_Y;
}

- (void)clearLeftElements {
    
    for (UIView *v in self.view.subviews) {
        if (v.tag >= LEFT_TAG && v.tag < RIGHT_TAG)
            [v removeFromSuperview];
        
    }
}

- (void)clearRightElements {
    
    for (UIView *v in self.view.subviews) {
        if (v.tag >= RIGHT_TAG && v.tag <= RIGHT_OUT_TAG + 100)
            [v removeFromSuperview];
    }
}

- (void)buttonPressed:(id)sender {
    UIButton *pressed = sender;
    
    if (pressed.selected)
        [pressed setSelected:NO];
    else
        [pressed setSelected:YES];
        
    if (pressed.tag >= LEFT_TAG && pressed.tag < RIGHT_TAG) {
        if (self.selectedLeft == pressed) {
            self.selectedLeft = nil;
        }
        else {
            if (self.selectedLeft != nil) {
                [self.selectedLeft setSelected:NO];
                self.selectedLeft = pressed;
            }
            else {
                self.selectedLeft = pressed;
            }
        }
    }
    
    if (pressed.tag >= RIGHT_TAG && pressed.tag < RIGHT_OUT_TAG+100) {
        if (self.selectedRight == pressed) {
            [self.selectedRight setSelected:NO];
            self.selectedRight = nil;
        }
        else {
            if (self.selectedRight != nil) {
                [self.selectedRight setSelected:NO];
                self.selectedRight = pressed;
            }
            else {
                self.selectedRight = pressed;
            }
        }
    }
    
    if (self.selectedLeft != nil && self.selectedRight != nil) {
        [self makeConnection];
    }
}

- (void)makeConnection {
        
    NSInteger conNumLeft, conNumRight;
    BOOL patchingLeftOutput = NO;
    BOOL patchingRightOutput = NO;
    
    if (self.selectedLeft.tag > LEFT_TAG && self.selectedLeft.tag < LEFT_OUT_TAG) 
        conNumLeft = self.selectedLeft.tag - LEFT_TAG;
    
    if (self.selectedLeft.tag > LEFT_OUT_TAG && self.selectedLeft.tag < LEFT_OUT_TAG+100) {
        conNumLeft = self.selectedLeft.tag - LEFT_OUT_TAG;
        patchingLeftOutput = YES;
    }
    
    if (self.selectedRight.tag > RIGHT_TAG && self.selectedRight.tag < RIGHT_OUT_TAG) 
        conNumRight = self.selectedRight.tag - RIGHT_TAG;
    if (self.selectedRight.tag > RIGHT_OUT_TAG && self.selectedRight.tag < RIGHT_OUT_TAG+100) {
        conNumRight = self.selectedRight.tag - RIGHT_OUT_TAG;
        patchingRightOutput = YES;
    }
    
    NSString *title1 = self.selectedLeft.titleLabel.text;
    NSString *title2 = self.selectedRight.titleLabel.text;
    
    if (!patchingLeftOutput && !patchingRightOutput) {
        if (self.segSwitch.selectedSegmentIndex == 0)
            [[DataManager sharedInstance] connectInPatch:self.patchOne toPatch:self.patchTwo from:conNumLeft to:conNumRight];
        else
            [[DataManager sharedInstance] connectInPatch:self.patchTwo toPatch:self.patchOne from:conNumRight to:conNumLeft];
        
        title1 = [NSString stringWithFormat:@"%d", conNumRight];
        title2 = [NSString stringWithFormat:@"%d", conNumLeft];
    }
    if ((patchingLeftOutput && !patchingRightOutput) || (!patchingLeftOutput && patchingRightOutput)) {
        // unsafe condition, display error
    }
    if (patchingLeftOutput && patchingRightOutput) {
        if (self.segSwitch.selectedSegmentIndex == 0)
            [[DataManager sharedInstance] connectOutPatch:self.patchOne toPatch:self.patchTwo from:conNumLeft to:conNumRight];
        else
            [[DataManager sharedInstance] connectOutPatch:self.patchTwo toPatch:self.patchOne from:conNumRight to:conNumLeft];
        
        title1 = [NSString stringWithFormat:@"%d", conNumRight];
        title2 = [NSString stringWithFormat:@"%d", conNumLeft];
    }
    
    [self.selectedLeft setTitle:title1 forState:UIControlStateNormal];
    [self.selectedLeft setTitle:title1 forState:UIControlStateHighlighted];
    [self.selectedLeft setTitle:title1 forState:UIControlStateSelected];
    
    [self.selectedRight setTitle:title2 forState:UIControlStateNormal];
    [self.selectedRight setTitle:title2 forState:UIControlStateHighlighted];
    [self.selectedRight setTitle:title2 forState:UIControlStateSelected];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.selectedLeft.transform = CGAffineTransformScale(self.selectedLeft.transform, 1.2, 1.2);
        self.selectedRight.transform = CGAffineTransformScale(self.selectedRight.transform, 1.2, 1.2);
        self.selectedLeft.transform = CGAffineTransformScale(self.selectedLeft.transform, .83, .83);
        self.selectedRight.transform = CGAffineTransformScale(self.selectedRight.transform, .83, .83);
    } completion:nil];
    
    [self.selectedLeft setSelected:NO];
    [self.selectedRight setSelected:NO];
    self.selectedLeft = nil;
    self.selectedRight = nil;
}

@end
