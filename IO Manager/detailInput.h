//
//  detailInput.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/5/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Input.h"
#import "Microphone.h"
#import "DataManager.h"
#import "micPicker.h"
#import "createMicView.h"
#import "inputUpdate.h"
#import "overlayControl.h"
#import "fullImageView.h"
#import "patchPointPopover.h"

@interface detailInput : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, inputUpdate, overlayControl>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleButton;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *micField;
@property (weak, nonatomic) IBOutlet UITextField *standField;
@property (weak, nonatomic) IBOutlet UITextField *accField;
@property (weak, nonatomic) IBOutlet UITextField *cableField;
@property (weak, nonatomic) IBOutlet UIImageView *placementImage;
@property (weak, nonatomic) IBOutlet UIImageView *micImage;
@property (weak, nonatomic) IBOutlet UILabel *isPhantom;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@property (nonatomic, strong) id delegate;

- (id)initWithInput:(Input *)input;
- (IBAction)micBeganTyping:(id)sender;
- (IBAction)micEndedTyping:(id)sender;
- (IBAction)changePlacementImage:(id)sender;
- (IBAction)showPlacementImage:(id)sender;
- (IBAction)showMicImage:(id)sender;
- (IBAction)micFieldChanged:(id)sender;
- (IBAction)editingDidEnd:(id)sender;
- (IBAction)editConnection:(id)sender;

@end
