//
//  Microphone.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/4/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Microphone : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSArray  * settings;
@property (nonatomic, retain) UIImage * image;
@property (nonatomic, retain) NSNumber * needsPhantom;

@end
