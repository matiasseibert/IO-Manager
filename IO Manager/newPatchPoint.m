//
//  newPatchPoint.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/4/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "newPatchPoint.h"

@interface newPatchPoint()
@property (nonatomic) BOOL editingInput;
@property (nonatomic) BOOL editingOutput;
@property (nonatomic) NSInteger inputs;
@property (nonatomic) NSInteger outputs;
@property (nonatomic, strong) UIPopoverController *curPopover;
@end

@implementation newPatchPoint
@synthesize nameField;
@synthesize inputField;
@synthesize outputField;
@synthesize locationField;
@synthesize delegate;
@synthesize editingInput, editingOutput, inputs, outputs;
@synthesize curPopover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.inputs = 0;
    self.outputs = 0;
    [self setContentSizeForViewInPopover:CGSizeMake(320, 302)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.title = @"Create Output";
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setLocationField:nil];
    [self setInputField:nil];
    [self setLocationField:nil];
    [self setOutputField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)donePressed:(id)sender {
    
    NSNumber *maxIn = [NSNumber numberWithInt:self.inputs];
    NSNumber *maxOut = [NSNumber numberWithInt:self.outputs];
    NSString *name = self.nameField.text;
    NSString *location = self.locationField.text;
    NSString *showName = [delegate getShowName];
    
    NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", maxIn, @"maxIn", maxOut, @"maxOut", location, @"location", @"patch", @"type", showName, @"showName", nil];
    
    [[DataManager sharedInstance] createPatchPointWithInfo:item];
    
    [delegate clearPopover];
}

- (void)cancelPressed:(id)sender {
    [delegate clearPopover];
}

- (IBAction)editingEnded:(id)sender {
    [self resignFirstResponder];
    [sender resignFirstResponder];
    [self.view endEditing:YES];
}

- (IBAction)killKeyboard:(id)sender {
    [sender resignFirstResponder];
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.inputField) {
        numInputView *numIn = [[numInputView alloc] initWithValue:self.inputs];
        [numIn setDelegate:self];
        self.editingInput = YES;
        //numIn.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:numIn action:@selector(donePressed:)];
        numIn.title = @"Number of Inputs";
        numIn.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:numIn action:@selector(cancelPressed:)];
        [self setContentSizeForViewInPopover:CGSizeMake(320, 352)];
        [self.navigationController pushViewController:numIn animated:YES];
        return NO;
    }
    if (textField == self.outputField) {
        numInputView *numIn = [[numInputView alloc] initWithValue:self.outputs];
        [numIn setDelegate:self];
        self.editingOutput = YES;
        //numIn.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:numIn action:@selector(donePressed:)];
        numIn.title = @"Number of Outputs";

        numIn.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:numIn action:@selector(cancelPressed:)];
        [self setContentSizeForViewInPopover:CGSizeMake(320, 352)];
        [self.navigationController pushViewController:numIn animated:YES];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.editingInput = NO;
    self.editingOutput = NO;
}

#pragma mark overlayControl 

- (void)clearPopover {
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.editingOutput = NO;
    self.editingInput = NO;
    [self setContentSizeForViewInPopover:CGSizeMake(320, 302)];
}

- (void)receiveNum:(NSInteger)num {
    if (self.editingInput) {
        self.inputs = num;
        self.inputField.text = [NSString stringWithFormat:@"%d", self.inputs];
    }
    
    if (self.editingOutput) {
        self.outputs = num;
        self.outputField.text = [NSString stringWithFormat:@"%d", self.outputs];
    }
    self.editingOutput = NO;
    self.editingInput = NO;
}

@end
