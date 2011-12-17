//
//  numInputView.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/9/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "numInputView.h"
#import <math.h>

@interface numInputView()
@property (nonatomic) NSInteger myNumber;
- (void)addNum:(NSInteger)number;
@end

@implementation numInputView
@synthesize numField, delegate, myNumber;

- (id)initWithValue:(NSInteger)value
{
    self = [super initWithNibName:@"numInputView" bundle:[NSBundle mainBundle]];
    if (self) {
        myNumber = value;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)addNum:(NSInteger)number {
    self.myNumber = 10 * self.myNumber;
    self.myNumber = self.myNumber + number;
    self.numField.text = [NSString stringWithFormat:@"%d", self.myNumber];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.myNumber > 0) {
        self.numField.text = [NSString stringWithFormat:@"%d", self.myNumber];
    }
    self.contentSizeForViewInPopover = CGSizeMake(320, 352);
}

- (void)viewDidUnload
{
    [self setNumField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)onePressed:(id)sender {
    [self addNum:1];
}

- (IBAction)twoPressed:(id)sender {
    [self addNum:2];
}

- (IBAction)threePressed:(id)sender {
    [self addNum:3];
}

- (IBAction)fourPressed:(id)sender {
    [self addNum:4];
}

- (IBAction)fivePressed:(id)sender {
    [self addNum:5];
}

- (IBAction)sixPressed:(id)sender {
    [self addNum:6];
}

- (IBAction)sevenPressed:(id)sender {
    [self addNum:7];
}

- (IBAction)eightPressed:(id)sender {
    [self addNum:8];
}

- (IBAction)ninePressed:(id)sender {
    [self addNum:9];
}

- (IBAction)zeroPressed:(id)sender {
    [self addNum:0];
}

- (IBAction)backPressed:(id)sender {
    if (self.myNumber > 9) {
        NSInteger ones = self.myNumber%10;
        self.myNumber -= ones;
        self.myNumber = self.myNumber/10;
    }
    else {
        self.myNumber = 0;
    }
    
    if (self.myNumber > 0) {
        self.numField.text = [NSString stringWithFormat:@"%d", self.myNumber];
    }
    else
        self.numField.text = @"";
}

- (IBAction)cancelPressed:(id)sender {
    [delegate clearPopover];
}

- (IBAction)donePressed:(id)sender {
    [delegate receiveNum:self.myNumber];
    [delegate clearPopover];
}

@end
