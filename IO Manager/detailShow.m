//
//  detailShow.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/10/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "detailShow.h"

@interface detailShow() 
@property (nonatomic, strong) Show *myShow;
@end

@implementation detailShow
@synthesize nameButton;
@synthesize nameField;
@synthesize delegate;
@synthesize myShow;

- (id)initWithShow:(NSString *)show
{
    self = [super initWithNibName:@"detailShow" bundle:[NSBundle mainBundle]];
    if (self) {
        myShow = [[DataManager sharedInstance] getShowByName:show];
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
    self.nameField.text = myShow.name;
    self.nameButton.title = myShow.name;
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setNameButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)nameEndedEditing:(id)sender {
    [[DataManager sharedInstance] setShowName:self.nameField.text forShow:self.myShow];
    [delegate loadShow:self.nameField.text];
}

#pragma mark UITextField Delegate 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
