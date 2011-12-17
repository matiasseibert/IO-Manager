//
//  patchPointPopover.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/12/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "PatchPoint.h"
#import "Console.h"
#import "Show.h"
#import "channelsInPatch.h"
#import "overlayControl.h"
#import "channelsInConsole.h"

@interface patchPointPopover : UITableViewController
@property (nonatomic, strong) id delegate;

- (id)initWithShow:(Show *)show;
@end
