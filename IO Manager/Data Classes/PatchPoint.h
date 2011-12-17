//
//  PatchPoint.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/6/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Connection, Show;

@interface PatchPoint : NSManagedObject

@property (nonatomic, retain) NSNumber * maxIn;
@property (nonatomic, retain) NSNumber * maxOut;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSOrderedSet *connectionsIn;
@property (nonatomic, retain) NSOrderedSet *connectionsOut;
@property (nonatomic, retain) Show *show;
@end

@interface PatchPoint (CoreDataGeneratedAccessors)

- (void)insertObject:(Connection *)value inConnectionsInAtIndex:(NSUInteger)idx;
- (void)removeObjectFromConnectionsInAtIndex:(NSUInteger)idx;
- (void)insertConnectionsIn:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeConnectionsInAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInConnectionsInAtIndex:(NSUInteger)idx withObject:(Connection *)value;
- (void)replaceConnectionsInAtIndexes:(NSIndexSet *)indexes withConnectionsIn:(NSArray *)values;
- (void)addConnectionsInObject:(Connection *)value;
- (void)removeConnectionsInObject:(Connection *)value;
- (void)addConnectionsIn:(NSOrderedSet *)values;
- (void)removeConnectionsIn:(NSOrderedSet *)values;
- (void)insertObject:(Connection *)value inConnectionsOutAtIndex:(NSUInteger)idx;
- (void)removeObjectFromConnectionsOutAtIndex:(NSUInteger)idx;
- (void)insertConnectionsOut:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeConnectionsOutAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInConnectionsOutAtIndex:(NSUInteger)idx withObject:(Connection *)value;
- (void)replaceConnectionsOutAtIndexes:(NSIndexSet *)indexes withConnectionsOut:(NSArray *)values;
- (void)addConnectionsOutObject:(Connection *)value;
- (void)removeConnectionsOutObject:(Connection *)value;
- (void)addConnectionsOut:(NSOrderedSet *)values;
- (void)removeConnectionsOut:(NSOrderedSet *)values;
@end
