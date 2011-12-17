//
//  newPatchPoint.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/4/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "overlayControl.h"
#import "masterControl.h"
#import "DataManager.h"
#import "numInputView.h"

@interface newPatchPoint : UIViewController <UITextFieldDelegate, UIPopoverControllerDelegate, overlayControl>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UITextField *outputField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (nonatomic, strong) id delegate;

- (void)donePressed:(id)sender;
- (void)cancelPressed:(id)sender;
- (IBAction)editingEnded:(id)sender;
- (IBAction)killKeyboard:(id)sender;
@end
