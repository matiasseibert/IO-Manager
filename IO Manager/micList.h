//
//  micList.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/9/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "masterControl.h"
#import "Microphone.h"
#import "DataManager.h"
#import "createMicView.h"
#import "overlayControl.h"
#import "masterControl.h"

@interface micList : UITableViewController <UIPopoverControllerDelegate, overlayControl, masterControl>
@property (nonatomic, strong) id delegate;
@end
