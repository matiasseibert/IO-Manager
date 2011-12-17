//
//  Connection.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/11/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Console, Input, Output, PatchPoint, Show;

@interface Connection : NSManagedObject

@property (nonatomic, retain) NSNumber * channelFemale;
@property (nonatomic, retain) NSNumber * channelMale;
@property (nonatomic, retain) NSNumber * isPatchOut;
@property (nonatomic, retain) Console *consoleIn;
@property (nonatomic, retain) Console *consoleOut;
@property (nonatomic, retain) PatchPoint *input;
@property (nonatomic, retain) PatchPoint *output;
@property (nonatomic, retain) Show *show;
@property (nonatomic, retain) Input *sourceInput;
@property (nonatomic, retain) Output *speakerOutput;

@end
