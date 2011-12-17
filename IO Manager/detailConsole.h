//
//  detailConsole.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/12/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Console.h"
#import "Show.h"
#import "DataManager.h"
#import "consolePatcher.h"
#import "overlayControl.h"

@interface detailConsole : UIViewController <UITextFieldDelegate, overlayControl>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleButton;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (nonatomic, strong) id delegate;
- (IBAction)editPressed:(id)sender;

- (IBAction)nameDidFinishEditing:(id)sender;
- (id)initWithShow:(NSString *)show;

@end
