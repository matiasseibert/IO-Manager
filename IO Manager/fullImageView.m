//
//  fullImageView.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/6/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "fullImageView.h"

@interface fullImageView()
@property (nonatomic, strong) UIImage *myImage;
@end

@implementation fullImageView
@synthesize imageview, delegate;
@synthesize myImage;

- (id)initWithImage:(UIImage *)image {
    self = [super initWithNibName:@"fullImageView" bundle:[NSBundle mainBundle]];
    if (self) {
        myImage = image;
    }
    return self;
}

- (IBAction)donePressed:(id)sender {
    [delegate clearModalview];
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
    self.imageview.image = self.myImage;
}

- (void)viewDidUnload
{
    [self setImageview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
