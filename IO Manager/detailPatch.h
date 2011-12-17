//
//  detailPatch.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/7/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "overlayControl.h"
#import "PatchPoint.h"
#import "inputUpdate.h"
#import "DataManager.h"
#import "numInputView.h"
#import "patcherView.h"
#import "masterControl.h"

@interface detailPatch : UIViewController <UIPopoverControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, overlayControl, masterControl>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *outLabel;
@property (nonatomic, strong) id delegate;
@property (weak, nonatomic) IBOutlet UIView *drawingView;

- (id)initWithPatch:(PatchPoint *)patch;

- (IBAction)editingEnded:(id)sender;
- (IBAction)inputTapped:(id)sender;
- (IBAction)outputTapped:(id)sender;
- (IBAction)showPatcher:(id)sender;

@end
