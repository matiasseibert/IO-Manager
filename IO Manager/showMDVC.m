//
//  showMDVC.m
//  IO Manager
//
//  Created by Matias Seibert on 11/21/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "showMDVC.h"
#import "blankDetailVC.h"
#import "DataManager.h"

@implementation showMDVC
@synthesize showName;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        showMasterVC *mainList = [[showMasterVC alloc] initWithNibName:@"showMasterVC.xib" bundle:[NSBundle mainBundle]];
        
        [mainList setDelegate:self];
        
        UINavigationController *masterNavController = [[UINavigationController alloc] initWithRootViewController:mainList];
        
        masterNavController.title = showName;
        
        blankDetailVC *emptyDetail = [[blankDetailVC alloc] initWithNibName:@"blankDetailVC.xib" bundle:[NSBundle mainBundle]];
        
        self.viewControllers = [NSArray arrayWithObjects:masterNavController, emptyDetail, nil];
        NSLog(@"We're here");
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

#pragma mark - show help delegate

- (void)setDetailForIndexPath:(NSIndexPath *)indexPath 
{
    
}

- (NSString *)getShowName {
    return self.showName;
}

#pragma mark - show input delegate

- (void)showDetailForInput:(Input *)input
{
    
}

@end
