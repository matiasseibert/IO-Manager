//
//  detailMic.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/12/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Microphone.h"
#import "overlayControl.h"

@interface detailMic : UIViewController <UITextFieldDelegate, UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate, overlayControl, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISwitch *phantomSwitch;
@property (weak, nonatomic) IBOutlet UITextField *typeField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleButton;
@property (weak, nonatomic) IBOutlet UIImageView *micImage;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (nonatomic, strong) id delegate;

- (IBAction)changeImage:(id)sender;
- (id)initWithMicrophone:(Microphone *)mic;

@end
