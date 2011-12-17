//
//  createMicView.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/3/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "overlayControl.h"
#import "inputUpdate.h"

@interface createMicView : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *typeField;
@property (weak, nonatomic) IBOutlet UISwitch *phantomSwitch;
@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) NSString *nameToUse;
@property (nonatomic) BOOL returnsToInputView;

- (IBAction)donePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)editingDidEnd:(id)sender;

@end
