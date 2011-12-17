//
//  newShowVC.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/1/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "newShowVC.h"

@interface newShowVC()
@property (nonatomic) BOOL editingIn;
@property (nonatomic) BOOL editingOut;
@property (nonatomic) NSInteger ins;
@property (nonatomic) NSInteger outs;
@end

@implementation newShowVC
@synthesize titleField;
@synthesize consoleField;
@synthesize inField;
@synthesize outField;
@synthesize delegate;
@synthesize editingIn, editingOut, ins, outs;

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
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
    editingIn = NO;
    editingOut = NO;
    ins = 0;
    outs = 0;
    [self setContentSizeForViewInPopover:CGSizeMake(320, 354)];
}

- (void)viewDidUnload
{
    [self setTitleField:nil];
    [self setConsoleField:nil];
    [self setInField:nil];
    [self setOutField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)cancelPressed:(id)sender {
    [delegate clearPopover];
}

- (void)donePressed:(id)sender {
    NSString *newName = self.titleField.text;
    
    DataManager *dataManager = [DataManager sharedInstance];
    
    [dataManager createShowWithName:newName];
    [dataManager createConsole:self.consoleField.text withIns:self.ins andOuts:self.outs inShow:newName];
    [delegate clearPopover];
}

- (IBAction)editingDidEnd:(id)sender {
    [sender resignFirstResponder];
}


#pragma mark TextView Editing Notifications

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.inField) {
        [self.titleField resignFirstResponder];
        [self.consoleField resignFirstResponder];
        numInputView *numInput = [[numInputView alloc] initWithValue:0];
        [numInput setDelegate:self];
        
        [numInput setModalInPopover:YES];
        numInput.title = @"Number of Inputs";
        numInput.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:numInput action:@selector(donePressed:)];
        [self setContentSizeForViewInPopover:CGSizeMake(320, 352)];
        [self.navigationController pushViewController:numInput animated:YES];
        self.editingIn = YES;
        return NO;
    }
    if (textField == self.outField) {
        [self.titleField resignFirstResponder];
        [self.consoleField resignFirstResponder];
        numInputView *numInput = [[numInputView alloc] initWithValue:0];
        [numInput setDelegate:self];
        
        [numInput setModalInPopover:YES];
        numInput.title = @"Number of Outputs";
        numInput.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:numInput action:@selector(donePressed:)];
        [self.navigationController pushViewController:numInput animated:YES];
        self.editingOut = YES;
        return NO;
    }
    return YES;
}

- (void)receiveNum:(NSInteger)num {
    if (self.editingIn) 
        self.ins = num;
    
    if (self.editingOut) 
        self.outs = num;
    
    self.editingIn = NO;
    self.editingOut = NO;
    
    self.inField.text = [NSString stringWithFormat:@"%d", self.ins];
    self.outField.text = [NSString stringWithFormat:@"%d", self.outs];
}

- (void)clearPopover {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
