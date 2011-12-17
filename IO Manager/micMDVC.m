//
//  micMDVC.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/9/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "micMDVC.h"

@interface micMDVC()
@property (nonatomic, strong) UINavigationController *masterNavController;
@property (nonatomic, strong) UIViewController *curDetail;
@end

@implementation micMDVC
@synthesize masterNavController, curDetail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage *icon = [UIImage imageNamed:@"microphone.png"];
        UITabBarItem *tabIcon = [[UITabBarItem alloc] initWithTitle:@"Mic Locker" image:icon tag:2];
        self.tabBarItem = tabIcon;
        micList *mainList = [[micList alloc] initWithNibName:@"micList" bundle:[NSBundle mainBundle]];
                
        [mainList setDelegate:self];
        
        
        masterNavController = [[UINavigationController alloc] initWithRootViewController:mainList];
        
        [masterNavController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
        blankMicView *emptyDetail = [[blankMicView alloc] initWithNibName:@"blankMicView" bundle:[NSBundle mainBundle]];
        
        curDetail = emptyDetail;
        
        self.viewControllers = [NSArray arrayWithObjects:masterNavController, curDetail, nil];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)showDetailForMic:(Microphone *)mic withDelegate:(id)delegate {
    detailMic *nextDetail = [[detailMic alloc] initWithMicrophone:mic];
    [nextDetail setDelegate:delegate];
    
    self.curDetail = nextDetail;
    self.viewControllers = [NSArray arrayWithObjects:self.masterNavController, self.curDetail, nil];
}

@end
