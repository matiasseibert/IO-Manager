//
//  showMasterVC.h
//  IO Manager
//
//  Created by Matias Seibert on 11/21/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol showHelp <NSObject>

- (void)setDetailForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)getShowName;

@end

@interface showMasterVC : UITableViewController

@property (strong, nonatomic) id delegate;

@end
