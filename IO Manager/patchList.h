//
//  patchList.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/6/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "PatchPoint.h"
#import "newPatchPoint.h"
#import "overlayControl.h"
#import "inputUpdate.h"
#import "masterControl.h"

@interface patchList : UITableViewController <UIPopoverControllerDelegate, overlayControl, inputUpdate, masterControl>

@property (nonatomic, strong) id delegate;

- (id)initWithShow:(NSString *)name;

@end
