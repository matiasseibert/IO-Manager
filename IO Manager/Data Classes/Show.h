//
//  Show.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/4/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Connection, Console, Input, Output, PatchPoint;

@interface Show : NSManagedObject

@property (nonatomic, retain) NSDate * lastOpened;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *connections;
@property (nonatomic, retain) NSSet *inputs;
@property (nonatomic, retain) NSSet *outputs;
@property (nonatomic, retain) NSSet *patches;
@property (nonatomic, retain) Console *console;
@end

@interface Show (CoreDataGeneratedAccessors)

- (void)addConnectionsObject:(Connection *)value;
- (void)removeConnectionsObject:(Connection *)value;
- (void)addConnections:(NSSet *)values;
- (void)removeConnections:(NSSet *)values;

- (void)addInputsObject:(Input *)value;
- (void)removeInputsObject:(Input *)value;
- (void)addInputs:(NSSet *)values;
- (void)removeInputs:(NSSet *)values;

- (void)addOutputsObject:(Output *)value;
- (void)removeOutputsObject:(Output *)value;
- (void)addOutputs:(NSSet *)values;
- (void)removeOutputs:(NSSet *)values;

- (void)addPatchesObject:(PatchPoint *)value;
- (void)removePatchesObject:(PatchPoint *)value;
- (void)addPatches:(NSSet *)values;
- (void)removePatches:(NSSet *)values;

@end
