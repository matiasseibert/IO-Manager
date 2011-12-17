//
//  patcherView.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/10/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatchPoint.h"
#import "Connection.h"
#import "Input.h"
#import "Console.h"
#import "DataManager.h"
#import "overlayControl.h"
#import "masterControl.h"

@interface patcherView : UIViewController <UITextFieldDelegate, UIPopoverControllerDelegate, overlayControl, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) id delegate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segSwitch;
@property (weak, nonatomic) IBOutlet UITextField *snakeOneField;
@property (weak, nonatomic) IBOutlet UITextField *snakeTwoField;

- (IBAction)donePressed:(id)sender;
- (id)initWithPatchPoint:(PatchPoint *)firstPatch;
- (IBAction)segChanged:(id)sender;
@end
