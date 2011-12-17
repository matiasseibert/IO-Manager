//
//  detailShow.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/10/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "masterControl.h"
#import "Show.h"
#import "DataManager.h"

@interface detailShow : UIViewController <masterControl, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (nonatomic, strong) id delegate;
- (IBAction)nameEndedEditing:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nameButton;

- (id)initWithShow:(NSString *)show;
@end
