//
//  Input.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/3/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Connection, Show;

@interface Input : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * micName;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString * cableLength;
@property (nonatomic, retain) NSString *accessories;
@property (nonatomic, retain) NSString *standNotes;
@property (nonatomic, retain) Connection *connection;
@property (nonatomic, retain) Show *show;

@end
