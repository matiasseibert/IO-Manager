//
//  channelsInConsole.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/12/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Console.h"
#import "DataManager.h"
#import "overlayControl.h"
#import "inputUpdate.h"

@interface channelsInConsole : UITableViewController

@property (nonatomic, strong) id delegate;

- (id)initWithConsole:(Console *)console;
@end
