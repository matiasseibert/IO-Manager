//
//  detailConsole.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/12/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "detailConsole.h"

#define START_YL1 131
#define START_YL2 157
#define START_X 7
#define DELTA_Y 66
#define DELTA_X 86
#define LABEL_WIDTH 86
#define L1_HEIGHT 26
#define L2_HEIGHT 20
#define DETAIL_TAG 100

@interface detailConsole()
@property (nonatomic, strong) Show *myShow;
@property (nonatomic, strong) Console *myConsole;

- (void)drawDetails;
- (void)createLabelTitled:(NSString *)title atX:(NSInteger)x atY:(NSInteger)y fromStart:(NSInteger)start withFont:(UIFont *)font andHeight:(NSInteger)height;
- (void)clearDetails;
@end

@implementation detailConsole
@synthesize titleButton;
@synthesize nameField;
@synthesize delegate;
@synthesize myShow, myConsole;

- (id)initWithShow:(NSString *)name
{
    self = [super initWithNibName:@"detailConsole" bundle:[NSBundle mainBundle]];
    if (self) {
        myShow = [[DataManager sharedInstance] getShowByName:name];
        myConsole = myShow.console;
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
    
    self.titleButton.title = self.myConsole.name;
    self.nameField.text = self.myConsole.name;
    [self drawDetails];
}

- (void)viewDidUnload
{
    [self setTitleButton:nil];
    [self setNameField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)editPressed:(id)sender {
    consolePatcher *patcher = [[consolePatcher alloc] initWithConsole:self.myConsole];
    [patcher setDelegate:self];
    [patcher setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentModalViewController:patcher animated:YES];
}

- (IBAction)nameDidFinishEditing:(id)sender {
    [[DataManager sharedInstance] setName:self.nameField.text forConsole:self.myConsole];
    self.titleButton.title = self.myConsole.name;
    self.nameField.text = self.myConsole.name;
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark overlayControl Delegate

- (void)clearModalview {
    [self dismissModalViewControllerAnimated:YES];
    [self clearDetails];
    [self drawDetails];
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
    NSInteger end = [self.myConsole.maxChannels intValue];
    
    NSInteger x = 0;
    NSInteger y = 0;
    
    for (int i = 1; i <= end; i++) {
        if (x == 8) {
            x = 0;
            y++;
        }
        NSString *l1 = [NSString stringWithFormat:@"%d. %@", i, [dataManager getInputDetailForChannel:i inShow:self.myShow.name]];
        
        [self createLabelTitled:l1
                            atX:x atY:y
                      fromStart:START_YL1
                       withFont:[UIFont boldSystemFontOfSize:14]
                      andHeight:L1_HEIGHT];
        
        
        NSString *l2 = [dataManager getChannel:i detailForConsole:self.myConsole];
        [self createLabelTitled:l2
                            atX:x atY:y
                      fromStart:START_YL2
                       withFont:[UIFont systemFontOfSize:12]
                      andHeight:L2_HEIGHT];
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
