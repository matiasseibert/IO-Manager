//
//  inputUpdate.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/5/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Input.h"

@protocol inputUpdate <NSObject>

@optional
- (void)setMicNamed:(NSString *)name;
- (void)choseExisting;
- (void)createNewInPopover;
- (Input *)getInput;

@end
