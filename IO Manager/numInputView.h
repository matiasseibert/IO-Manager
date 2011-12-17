//
//  numInputView.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/9/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "overlayControl.h"

@interface numInputView : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *numField;
@property (nonatomic, strong) id delegate;
- (IBAction)onePressed:(id)sender;
- (IBAction)twoPressed:(id)sender;
- (IBAction)threePressed:(id)sender;
- (IBAction)fourPressed:(id)sender;
- (IBAction)fivePressed:(id)sender;
- (IBAction)sixPressed:(id)sender;
- (IBAction)sevenPressed:(id)sender;
- (IBAction)eightPressed:(id)sender;
- (IBAction)ninePressed:(id)sender;
- (IBAction)zeroPressed:(id)sender;

- (IBAction)backPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)donePressed:(id)sender;

- (id)initWithValue:(NSInteger)value;

@end
