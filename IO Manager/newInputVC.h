//
//  newInputVC.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/2/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "overlayControl.h"
#import "inputUpdate.h"
#import "masterControl.h"
#import "DataManager.h"

@interface newInputVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) id delegate;
@property (weak, nonatomic) IBOutlet UILabel *buttonTitle;
@property (weak, nonatomic) IBOutlet UIPickerView *myPicker;

- (IBAction)donePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

@end
