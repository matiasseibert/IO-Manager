//
//  detailPatch.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/7/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "detailPatch.h"

#define START_YL1 195
#define START_YL2 221
#define START_YL3 241
#define START_X 7
#define DELTA_Y 76
#define DELTA_X 86
#define LABEL_WIDTH 86
#define L1_HEIGHT 26
#define L23_HEIGHT 20
#define DETAIL_TAG 100

@interface detailPatch()
@property (nonatomic, strong) UIPopoverController *curPopover;
@property (nonatomic, strong) PatchPoint *myPatch;
@property (nonatomic) BOOL editingInput;
@property (nonatomic) BOOL editingOutput;

- (void)drawDetails;
- (void)createLabelTitled:(NSString *)title atX:(NSInteger)x atY:(NSInteger)y fromStart:(NSInteger)start withFont:(UIFont *)font andHeight:(NSInteger)height;
@end

@implementation detailPatch
@synthesize nameField;
@synthesize locationField;
@synthesize numLabel;
@synthesize outLabel;
@synthesize curPopover, myPatch;
@synthesize editingInput, editingOutput;
@synthesize delegate;
@synthesize drawingView;

- (id)initWithPatch:(PatchPoint *)patch
{
    self = [super initWithNibName:@"detailPatch" bundle:[NSBundle mainBundle]];
    if (self) {
        myPatch = patch;
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
    self.navigationItem.title = self.myPatch.name;
    self.nameField.text = self.myPatch.name;
    self.locationField.text = self.myPatch.location;
    self.numLabel.text = [NSString stringWithFormat:@"%d", [self.myPatch.maxIn intValue]];
    self.outLabel.text = [NSString stringWithFormat:@"%d", [self.myPatch.maxOut intValue]];
    [self drawDetails];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self drawDetails];
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setLocationField:nil];
    [self setNumLabel:nil];
    [self setOutLabel:nil];
    [self setDrawingView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return NO;
}

- (IBAction)editingEnded:(id)sender {
    self.navigationItem.title = self.nameField.text;
    DataManager *dataManager = [DataManager sharedInstance];
    [dataManager setName:self.nameField.text forPatch:self.myPatch];
    [dataManager setLocation:self.locationField.text forPatch:self.myPatch];
    
    [delegate updateListing];
    [sender resignFirstResponder];
}

- (IBAction)inputTapped:(id)sender {
    if (self.curPopover != nil)
        [self clearPopover];
    else {
        /*
        numInputView *numInput = [[numInputView alloc] initWithValue:[self.myPatch.maxIn intValue]];
        [numInput setDelegate:self];
        UINavigationController *container = [[UINavigationController alloc] initWithRootViewController:numInput];
        numInput.title = @"Set Number of Inputs:";
        self.editingInput = YES;
        self.curPopover = [[UIPopoverController alloc] initWithContentViewController:container];
        [self.curPopover setPopoverContentSize:CGSizeMake(320, 387)];
        [self.curPopover presentPopoverFromRect:self.numLabel.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];*/
    }
}

- (IBAction)outputTapped:(id)sender {
    if (self.curPopover != nil)
        [self clearPopover];
    else {
        /*numInputView *numInput = [[numInputView alloc] initWithValue:[self.myPatch.maxOut intValue]];
        [numInput setDelegate:self];
        UINavigationController *container = [[UINavigationController alloc] initWithRootViewController:numInput];
        container.navigationItem.title = @"Set Number of Outputs:";
        self.editingOutput = YES;
        self.curPopover = [[UIPopoverController alloc] initWithContentViewController:container];
        [self.curPopover setPopoverContentSize:CGSizeMake(320, 387)];
        [self.curPopover presentPopoverFromRect:self.outLabel.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];*/
    }
}

- (IBAction)showPatcher:(id)sender {
    patcherView *new = [[patcherView alloc] initWithPatchPoint:self.myPatch];
    [new setDelegate:self];
    [new setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentModalViewController:new animated:YES];
}


#pragma mark overlayControl Delegate

- (void)clearPopover {
    if (self.curPopover != nil)
        [self.curPopover dismissPopoverAnimated:YES];
    self.curPopover = nil;
    self.editingInput = NO;
    self.editingOutput = NO;
}

- (void)clearModalview {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)receiveNum:(NSInteger)num {
    if (self.editingInput) {
        //NSInteger old = [self.myPatch.maxIn 
        self.myPatch.maxIn = [NSNumber numberWithInt:num];
        self.numLabel.text = [NSString stringWithFormat:@"%d", [self.myPatch.maxIn intValue]];
    }
    
    if (self.editingOutput) {
        self.myPatch.maxOut = [NSNumber numberWithInt:num];
        self.outLabel.text = [NSString stringWithFormat:@"%d", [self.myPatch.maxOut intValue]];
    }
}
#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger ins = [self.myPatch.maxIn intValue];
    NSInteger outs = [self.myPatch.maxOut intValue];
    NSInteger ones, tens, newNumber;
    
    if (self.editingInput) {
        ones = ins%10;
        tens = ins/10;
    }
    
    if (self.editingOutput) {
        ones = outs%10;
        tens = outs/10;
    }
    
    if (component == 0) {
        tens = row;
        newNumber = (tens*10) + ones;
    }
    if (component == 1) {
        ones = row;
        newNumber = (tens*10) + ones;
    }
    
    if (self.editingInput) {
        self.myPatch.maxIn = [NSNumber numberWithInt:newNumber];
        self.numLabel.text = [NSString stringWithFormat:@"%d", [self.myPatch.maxIn intValue]];
    }
    
    if (self.editingOutput) {
        self.myPatch.maxOut = [NSNumber numberWithInt:newNumber];
        self.outLabel.text = [NSString stringWithFormat:@"%d", [self.myPatch.maxOut intValue]];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 36.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d", row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 100.0;
}

#pragma mark - UIPickerViewDatasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.editingInput = NO;
    self.editingOutput = NO;
}

- (NSString *)getShowName {
    return [delegate getShowName];
}

- (void)createLabelTitled:(NSString *)title atX:(NSInteger)x atY:(NSInteger)y fromStart:(NSInteger)start withFont:(UIFont *)font andHeight:(NSInteger)height {
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(START_X + (x * DELTA_X), start + (y * DELTA_Y), LABEL_WIDTH, height)];
    [newLabel setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.0]];
    
    newLabel.font = font;
    newLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    newLabel.text = title;
    [newLabel setTextAlignment:UITextAlignmentCenter];
    [newLabel setTag:DETAIL_TAG];
    [self.view addSubview:newLabel];
}


- (void)drawDetails {
    DataManager *dataManager = [DataManager sharedInstance];
    NSInteger end = [self.myPatch.maxIn intValue];
    
    NSInteger x = 0;
    NSInteger y = 0;
    
    for (int i = 1; i <= end; i++) {
        if (x == 8) {
            x = 0;
            y++;
        }
        [self createLabelTitled:[NSString stringWithFormat:@"%d", i]
                            atX:x atY:y
                      fromStart:START_YL1
                       withFont:[UIFont boldSystemFontOfSize:14]
                      andHeight:L1_HEIGHT];
        
        [self createLabelTitled:[dataManager getInDetailOfChannel:i forPatch:self.myPatch]
                            atX:x atY:y
                      fromStart:START_YL2
                       withFont:[UIFont systemFontOfSize:12]
                      andHeight:L23_HEIGHT];
        
        [self createLabelTitled:[dataManager getOutDetailOfChannel:i forPatch:self.myPatch]
                            atX:x atY:y
                      fromStart:START_YL3
                       withFont:[UIFont systemFontOfSize:12]
                      andHeight:L23_HEIGHT];
         x++;
    }
}

- (void)clearDetails {
    for (UIView *view in self.view.subviews) {
        if (view.tag == DETAIL_TAG)
            [view removeFromSuperview];
    }
}

@end
