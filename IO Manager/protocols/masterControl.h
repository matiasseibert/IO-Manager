//
//  masterControl.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/5/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Input.h"
#import "PatchPoint.h"
#import "Show.h"
#import "Microphone.h"

@protocol masterControl <NSObject>

@optional
- (void)loadShow:(NSString *)name;
- (NSString *)getShowName;
- (void)showDetailForInput:(Input *)input withDelegate:(id)delegate;
- (void)showDetailForPatch:(PatchPoint *)patch withDelegate:(id)delegate;
- (void)showDetailForShowWithDelegate:(id)delegate;
- (void)showBlankDetail;
- (void)showDetailForConsole;
- (void)showDetailForMic:(Microphone *)mic withDelegate:(id)delegate;
@end
