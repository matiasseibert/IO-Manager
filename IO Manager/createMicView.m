//
//  createMicView.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/3/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "createMicView.h"
#import "DataManager.h"

@interface createMicView()
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) UIPopoverController *curPopover;
@property (nonatomic, strong) NSString *myName;
@property (nonatomic, strong) NSString *myType;
@property (nonatomic) BOOL phantom;
@end

@implementation createMicView
@synthesize nameField;
@synthesize typeField;
@synthesize phantomSwitch;
@synthesize delegate;
@synthesize types, curPopover;
@synthesize returnsToInputView;
@synthesize nameToUse;
@synthesize myName, myType, phantom;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        types = [NSArray arrayWithObjects:@"Dynamic", @"Condensor", @"Ribbon", @"Passive DI", @"Active DI", @"Line in", nil];
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
    // Do any additional setup after loading the view from its nib.
    self.nameField.text = self.nameToUse;
    self.typeField.text = @"Dynamic";
    
    self.myName = self.nameToUse;
    self.myType = @"Dynamic";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.leftBarButtonItem = left;
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setPhantomSwitch:nil];
    [self setTypeField:nil];
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
    self.phantom = self.phantomSwitch.on;
    UIImage *image = nil;
    NSArray *settings = nil;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.myName, @"name", self.myType, @"type", [NSNumber numberWithBool:self.phantom], @"needsPhantom", image, @"image", settings, @"settings", nil];
    
    [[DataManager sharedInstance] createMicrophoneFromInfo:dict];
    
    if (self.returnsToInputView) {
        [delegate setMicNamed:self.myName];
    }
    else
        [delegate updateListing];
    
    [delegate clearPopover];
}

- (void)cancelPressed:(id)sender {
    if (self.returnsToInputView) {
        [delegate setMicNamed:nil];
    }
    else
        [delegate updateListing];
    
    [delegate clearPopover];
}

- (IBAction)editingDidEnd:(id)sender {
    self.myName = self.nameField.text;
    self.myType = self.typeField.text;
    [sender resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.myName = self.nameField.text;
    self.myType = self.typeField.text;
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.typeField) {
        UIPickerView *newPicker = [[UIPickerView alloc] init];
        [newPicker setDelegate:self];
        [newPicker setDataSource:self];
        [newPicker setFrame:CGRectMake(0, 338, 320, 200)];
        [newPicker setShowsSelectionIndicator:YES];
        [self.view addSubview:newPicker];
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            newPicker.transform = CGAffineTransformTranslate(newPicker.transform, 0, -216.0);
        } completion:nil];
        
        return NO;
    }
    else
        return YES;
    
    //return YES;
}

#pragma mark UIPickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.typeField.text = [self.types objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 300;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.types objectAtIndex:row];
}

#pragma mark UIPickerView Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.types count];
}

@end
