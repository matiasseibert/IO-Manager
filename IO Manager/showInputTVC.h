//
//  showInputTVC.h
//  IO Manager
//
//  Created by Matias Seibert on 11/21/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Input.h"
#import "overlayControl.h"
#import "inputUpdate.h"
#import "masterControl.h"
#import "numInputView.h"

@interface showInputTVC : UITableViewController <UIPopoverControllerDelegate, overlayControl, inputUpdate, masterControl>

@property (strong, nonatomic) id delegate;

- (id)initWithShow:(NSString *)name;

@end
