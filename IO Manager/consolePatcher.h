//
//  consolePatcher.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/12/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "overlayControl.h"
#import "Console.h"

@interface consolePatcher : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, overlayControl>
@property (nonatomic, strong) id delegate;
@property (weak, nonatomic) IBOutlet UITextField *patchField;
@property (weak, nonatomic) IBOutlet UILabel *consoleLabel;

- (IBAction)donePressed:(id)sender;
- (id)initWithConsole:(Console *)console;
@end
