//
//  showMasterVC.h
//  IO Manager
//
//  Created by Matias Seibert on 11/21/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "showInputTVC.h"
#import "patchList.h"
#import "masterControl.h"

@interface showMasterVC : UITableViewController <masterControl>

@property (strong, nonatomic) id delegate;

@end
