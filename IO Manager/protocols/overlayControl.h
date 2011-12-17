//
//  overlayControl.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/5/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol overlayControl <NSObject>

@optional
- (void)clearPopover;
- (void)clearModalview;
- (void)receiveNum:(NSInteger)num;
- (void)updateListing;

@end
