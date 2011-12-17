//
//  showMDVC.h
//  IO Manager
//
//  Created by Matias Seibert on 11/21/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "showMasterVC.h"
#import "showInputTVC.h"
#import "showListingTVC.h"
#import "blankDetailVC.h"
#import "DataManager.h"
#import "detailInput.h"
#import "detailPatch.h"
#import "detailShow.h"
#import "detailConsole.h"

#import "protocols/masterControl.h"

@interface showMDVC : UISplitViewController <masterControl>

@end
