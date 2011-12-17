//
//  newInputVC.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/2/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "newInputVC.h"

@interface newInputVC()
@property (nonatomic) NSInteger hundreds;
@property (nonatomic) NSInteger tens;
@property (nonatomic) NSInteger ones;
@property (nonatomic) NSInteger number;
@end

@implementation newInputVC
@synthesize delegate;
@synthesize buttonTitle;
@synthesize myPicker;
@synthesize hundreds, tens, ones, number;

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
    self.number = 1;
    self.ones = 1;
    self.buttonTitle.text = [NSString stringWithFormat:@"%d", self.number];
    [self.myPicker selectRow:(self.hundreds/100) inComponent:0 animated:NO];
    [self.myPicker selectRow:(self.tens/10) inComponent:1 animated:NO];
    [self.myPicker selectRow:self.ones inComponent:2 animated:NO];
}

- (void)viewDidUnload
{
    [self setButtonTitle:nil];
    [self setMyPicker:nil];
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
    self.number = ones + tens + hundreds;
    if (self.number > 0) {
        [[DataManager sharedInstance] createInputs:self.number inShow:[delegate getShowName]];
        [delegate clearPopover];
    }
    else
        [delegate clearPopover];
}

- (IBAction)cancelPressed:(id)sender {
    [delegate clearPopover];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    // set the degree based on component
    if (component == 0)
    {
        self.hundreds = 100 * row;
    }
    if (component == 1)
    {
        self.tens = 10 * row;
    }
    if (component == 2)
    {    
        self.ones = row;
    }
    self.number = self.hundreds + self.tens + self.ones;
    self.buttonTitle.text = [NSString stringWithFormat:@"%d", self.number];
    
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
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
        return 2;
    else
        return 10;
}

@end
