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

@interface showMDVC : UISplitViewController <showHelp, inputHelp>

@property (nonatomic, strong) NSString *showName;

@end
