//
//  Output.h
//  IO Manager
//
//  Created by Matias Seibert on 11/26/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Connection, Show;

@interface Output : NSManagedObject

@property (nonatomic, retain) Connection *connection;
@property (nonatomic, retain) Show *show;

@end
