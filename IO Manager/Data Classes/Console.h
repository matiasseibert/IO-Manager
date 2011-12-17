//
//  Console.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/12/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Connection, Show;

@interface Console : NSManagedObject

@property (nonatomic, retain) NSNumber * maxChannels;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * numOutputs;
@property (nonatomic, retain) NSOrderedSet *inputs;
@property (nonatomic, retain) NSOrderedSet *outputs;
@property (nonatomic, retain) Show *show;
@end

@interface Console (CoreDataGeneratedAccessors)

- (void)insertObject:(Connection *)value inInputsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromInputsAtIndex:(NSUInteger)idx;
- (void)insertInputs:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeInputsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInInputsAtIndex:(NSUInteger)idx withObject:(Connection *)value;
- (void)replaceInputsAtIndexes:(NSIndexSet *)indexes withInputs:(NSArray *)values;
- (void)addInputsObject:(Connection *)value;
- (void)removeInputsObject:(Connection *)value;
- (void)addInputs:(NSOrderedSet *)values;
- (void)removeInputs:(NSOrderedSet *)values;
- (void)insertObject:(Connection *)value inOutputsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromOutputsAtIndex:(NSUInteger)idx;
- (void)insertOutputs:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeOutputsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInOutputsAtIndex:(NSUInteger)idx withObject:(Connection *)value;
- (void)replaceOutputsAtIndexes:(NSIndexSet *)indexes withOutputs:(NSArray *)values;
- (void)addOutputsObject:(Connection *)value;
- (void)removeOutputsObject:(Connection *)value;
- (void)addOutputs:(NSOrderedSet *)values;
- (void)removeOutputs:(NSOrderedSet *)values;
@end
