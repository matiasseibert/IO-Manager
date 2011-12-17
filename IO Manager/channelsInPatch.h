//
//  channelsInPatch.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/12/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "PatchPoint.h"
#import "inputUpdate.h"
#import "overlayControl.h"

@interface channelsInPatch : UITableViewController
@property (nonatomic, strong) id delegate;

- (id)initWithPatch:(PatchPoint *)patch;
@end
