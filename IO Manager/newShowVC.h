//
//  newShowVC.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/1/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "overlayControl.h"
#import "DataManager.h"
#import "numInputView.h"

@interface newShowVC : UIViewController <UITextFieldDelegate, overlayControl>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *consoleField;
@property (weak, nonatomic) IBOutlet UITextField *inField;
@property (weak, nonatomic) IBOutlet UITextField *outField;

@property (nonatomic, strong) id delegate;

- (IBAction)editingDidEnd:(id)sender;
@end
