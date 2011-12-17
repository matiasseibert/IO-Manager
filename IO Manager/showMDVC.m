//
//  showMDVC.m
//  IO Manager
//
//  Created by Matias Seibert on 11/21/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "showMDVC.h"


@interface showMDVC()
@property (nonatomic, strong) UINavigationController *masterNavController;
@property (nonatomic, strong) UIViewController *curDetail;
@property (nonatomic, strong) NSString *showName;
@end

@implementation showMDVC
@synthesize showName, curDetail, masterNavController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage *icon = [UIImage imageNamed:@"bookmark.png"];
        UITabBarItem *tabIcon = [[UITabBarItem alloc] initWithTitle:@"Shows" image:icon tag:1];
        self.tabBarItem = tabIcon;
        showListingTVC *mainList = [[showListingTVC alloc] initWithNibName:@"showListingTVC" bundle:[NSBundle mainBundle]];
        
        // We'll get this from a plist eventually...
        // It'll be the most recent show.
        //showName = @"Sample";

        [mainList setDelegate:self];
        
        masterNavController = [[UINavigationController alloc] initWithRootViewController:mainList];

        [masterNavController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
        blankDetailVC *emptyDetail = [[blankDetailVC alloc] initWithNibName:@"blankDetailVC" bundle:[NSBundle mainBundle]];
        
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
    self.tabBarItem.title = @"Shows";
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

#pragma mark - masterControl Delegate

- (NSString *)getShowName {
    return self.showName;
}

- (void)showDetailForInput:(Input *)input withDelegate:(id)delegate
{
    //inputDetail *newInputDetail = [[inputDetail alloc] initWithInput:input];
    detailInput *newInputDetail = [[detailInput alloc] initWithInput:input];
    [newInputDetail setDelegate:delegate];
    self.curDetail = newInputDetail;
    self.viewControllers = [NSArray arrayWithObjects:self.masterNavController, self.curDetail, nil];
}

- (void)showDetailForPatch:(PatchPoint *)patch withDelegate:(id)delegate {
    detailPatch *newPatchDetail = [[detailPatch alloc] initWithPatch:patch];
    [newPatchDetail setDelegate:delegate];
    self.curDetail = newPatchDetail;
    self.viewControllers = [NSArray arrayWithObjects:self.masterNavController, self.curDetail, nil];
}

- (void)showDetailForShowWithDelegate:(id)delegate {
    detailShow *newDetailShow = [[detailShow alloc] initWithShow:self.showName];
    [newDetailShow setDelegate:delegate];
    self.curDetail = newDetailShow;
    self.viewControllers = [NSArray arrayWithObjects:self.masterNavController, self.curDetail, nil];
}

- (void)showBlankDetail {
    blankDetailVC *newBlankDetail = [[blankDetailVC alloc] initWithNibName:@"blankDetailVC" bundle:[NSBundle mainBundle]];
    self.curDetail = newBlankDetail;
    self.viewControllers = [NSArray arrayWithObjects:self.masterNavController, self.curDetail, nil];
}

- (void)showDetailForConsole {
    detailConsole *newDetail = [[detailConsole alloc] initWithShow:self.showName];
    self.curDetail = newDetail;
    self.viewControllers = [NSArray arrayWithObjects:self.masterNavController, self.curDetail, nil];
}

- (void)loadShow:(NSString *)name 
{
    self.showName = name;
    DataManager *dataManager = [DataManager sharedInstance];
    [dataManager updateShowLastLoaded:name];
}

@end
