//
//  micPicker.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/3/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "inputUpdate.h"
#import "overlayControl.h"
#import "Microphone.h"
#import "DataManager.h"
#import "createMicView.h"

@interface micPicker : UITableViewController
@property (nonatomic, strong) id delegate;

- (void)updateSearchTerm:(NSString *)name;
- (void)pushCreateMicView;

@end
