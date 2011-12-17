//
//  showListingTVC.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/1/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "newShowVC.h"
#import "masterControl.h"
#import "overlayControl.h"
#import "showMasterVC.h"
#import "Show.h"

@interface showListingTVC : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, UIPopoverControllerDelegate, overlayControl>

@property (nonatomic, strong) id delegate;

@end
