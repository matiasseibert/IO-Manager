//
//  consolePatcher.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/12/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "consolePatcher.h"

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

@interface consolePatcher()
@property (nonatomic, strong) PatchPoint *myPatch;
@property (nonatomic, strong) Console *myConsole;
@property (nonatomic, strong) NSArray *patchPoints;
@property (nonatomic, strong) UIPopoverController *curPopover;
@property (nonatomic, strong) UIButton *selectedLeft;
@property (nonatomic, strong) UIButton *selectedRight;
@property (nonatomic) BOOL editingLeft;
@property (nonatomic) BOOL editingRight;
@property (nonatomic) NSInteger yStart;

- (void)updateLeftButtons;
- (void)updateRightButtons;
- (void)clearLeftElements;
- (void)clearRightElements;
- (void)createButtonTitled:(NSString *)title atX:(NSInteger)x_index atY:(NSInteger)y_index onSide:(BOOL)leftSide withTag:(NSInteger)tag;
- (void)createLabelTitled:(NSString *)title atX:(NSInteger)x_index atY:(NSInteger)y_index onSide:(BOOL)leftSide withTag:(NSInteger)tag;
- (void)buttonPressed:(id)sender;
- (void)makeConnection;
@end

@implementation consolePatcher
@synthesize patchField;
@synthesize consoleLabel;
@synthesize delegate;
@synthesize myPatch, myConsole, patchPoints;
@synthesize curPopover, selectedLeft, selectedRight;
@synthesize editingLeft, editingRight, yStart;

- (id)initWithConsole:(Console *)console
{
    self = [super initWithNibName:@"consolePatcher" bundle:[NSBundle mainBundle]];
    if (self) {
        myConsole = console;
        patchPoints = [[DataManager sharedInstance] getPatchesForShow:console.show.name];
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
    // Do any additional setup after loading the view from its nib.
    self.yStart = START_Y;
    [self updateLeftButtons];
    self.consoleLabel.text = self.myConsole.name;
}

- (void)viewDidUnload
{
    [self setPatchField:nil];
    [self setConsoleLabel:nil];
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
        
    UITableViewController *patcherTable = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [patcherTable.tableView setDelegate:self];
    [patcherTable.tableView setDataSource:self];
    
    UINavigationController *container = [[UINavigationController alloc] initWithRootViewController:patcherTable];
    patcherTable.title = @"Select Patcher";
    self.curPopover = [[UIPopoverController alloc] initWithContentViewController:container];
    [self.curPopover setPopoverContentSize:CGSizeMake(320, 358)];
    [self.curPopover presentPopoverFromRect:self.patchField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

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

    if (cur == self.myPatch)
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    cell.textLabel.text = cur.name;
    cell.detailTextLabel.text = cur.location;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.myPatch = [self.patchPoints objectAtIndex:[indexPath row]];
    self.patchField.text = self.myPatch.name;
    [self clearRightElements];
    [self updateRightButtons];
    [self clearPopover];
}

#pragma mark - overlayControl Delegate

- (void)clearPopover {
    if (self.curPopover != nil) {
        [self.curPopover dismissPopoverAnimated:YES];
        self.curPopover = nil;
    }
}

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
    [newButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
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
    
    NSInteger end = [self.myConsole.maxChannels intValue];
    
    for (int i = 1; i <= end; i++) {
        if (x == 8) {
            x = 0;
            y++;
        }
        NSString *title = [[DataManager sharedInstance] getChannel:i simpleForConsole:self.myConsole];
        
        [self createButtonTitled:title atX:x atY:y onSide:YES withTag:LEFT_TAG+i];
        
        NSString *labelTitle = [NSString stringWithFormat:@"%d", i];
        [self createLabelTitled:labelTitle atX:x atY:y onSide:YES withTag:LEFT_TAG];
        x++;
    }
    self.yStart = START_Y;
}

- (void)updateRightButtons {
    NSInteger index = 0;
    NSInteger index_y = 0;
    
    NSInteger end = [self.myPatch.maxIn intValue];
    
    for (int i = 1; i <= end; i++) {
        if (index == 8) {
            index = 0;
            index_y++;
        }
        NSString *title = nil;

        title = [[DataManager sharedInstance] getOutputNumber:i forPatch:self.myPatch];
        
        [self createButtonTitled:title atX:index atY:index_y onSide:NO withTag:RIGHT_TAG+i];
        NSString *labelTitle = [NSString stringWithFormat:@"%d", i];
        [self createLabelTitled:labelTitle atX:index atY:index_y onSide:NO withTag:RIGHT_TAG];
        index++;
    }

    self.yStart = START_Y;
}

- (void)clearLeftElements {
    for (UIView *v in self.view.subviews) {
        if (v.tag >= LEFT_TAG && v.tag <= RIGHT_TAG)
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
    if (pressed.tag >= LEFT_TAG && pressed.tag < RIGHT_TAG) {
        if (self.selectedLeft == pressed) {
            [self.selectedLeft setSelected:NO];
            self.selectedLeft = nil;
        }
        else {
            if (self.selectedLeft != nil) {
                [self.selectedLeft setSelected:NO];
                self.selectedLeft = pressed;
                [self.selectedLeft setSelected:YES];
            }
            else {
                self.selectedLeft = pressed;
                [self.selectedLeft setSelected:YES];
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
                [self.selectedRight setSelected:YES];
            }
            else {
                self.selectedRight = pressed;
                [self.selectedRight setSelected:YES];
            }
        }
    }
    
    if (self.selectedLeft != nil && self.selectedRight != nil) {
        [self makeConnection];
    }
}

- (void)makeConnection {
    NSInteger conNumLeft, conNumRight;
    
    if (self.selectedLeft.tag > LEFT_TAG && self.selectedLeft.tag < LEFT_OUT_TAG) 
        conNumLeft = self.selectedLeft.tag - LEFT_TAG;
    
    if (self.selectedRight.tag > RIGHT_TAG && self.selectedRight.tag < RIGHT_OUT_TAG) 
        conNumRight = self.selectedRight.tag - RIGHT_TAG;

    NSString *title1 = self.selectedLeft.titleLabel.text;
    NSString *title2 = self.selectedRight.titleLabel.text;
    
    // make the connection. 
    
    [[DataManager sharedInstance] connectPatch:self.myPatch channel:conNumRight toConsole:self.myConsole channel:conNumLeft];
    
    title1 = [NSString stringWithFormat:@"p %d", conNumRight];
    title2 = [NSString stringWithFormat:@"c %d", conNumLeft];
    
    [self.selectedLeft setTitle:title1 forState:UIControlStateNormal];
    [self.selectedLeft setTitle:title1 forState:UIControlStateHighlighted];
    [self.selectedLeft setTitle:title1 forState:UIControlStateSelected];
    
    [self.selectedRight setTitle:title2 forState:UIControlStateNormal];
    [self.selectedRight setTitle:title2 forState:UIControlStateHighlighted];
    [self.selectedRight setTitle:title2 forState:UIControlStateSelected];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.selectedLeft.transform = CGAffineTransformScale(self.selectedLeft.transform, 1.2, 1.2);
        self.selectedRight.transform = CGAffineTransformScale(self.selectedRight.transform, 1.2, 1.2);
        self.selectedRight.transform = CGAffineTransformScale(self.selectedLeft.transform, .83, .83);
        selectedLeft.transform = CGAffineTransformScale(self.selectedRight.transform, .83, .83);
    } completion:nil];
    
    [self.selectedLeft setSelected:NO];
    [self.selectedRight setSelected:NO];
    self.selectedLeft = nil;
    self.selectedRight = nil;
    
}

@end
