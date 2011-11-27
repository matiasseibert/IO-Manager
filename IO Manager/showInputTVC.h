//
//  showInputTVC.h
//  IO Manager
//
//  Created by Matias Seibert on 11/21/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Input.h"

@protocol inputHelp <NSObject>

- (void)showDetailForInput:(Input *)input;

@end

@interface showInputTVC : UITableViewController

@property (strong, nonatomic) id delegate;

- (id)initWithShow:(NSString *)name;

@end
