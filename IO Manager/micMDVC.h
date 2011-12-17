//
//  micMDVC.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/9/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "masterControl.h"
#import "overlayControl.h"
#import "micList.h"
#import "blankMicView.h"
#import "detailMic.h"

@interface micMDVC : UISplitViewController <masterControl, overlayControl>

@end
