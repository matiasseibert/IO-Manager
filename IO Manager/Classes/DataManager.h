//
//  DataManager.h
//  CoreDataDemo
//
//  Created by John Hannan on 10/11/10.
//  Copyright 2010 Penn State University. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Connection.h"
#import "Input.h"
#import "Show.h"
#import "PatchPoint.h"
#import "Output.h"
#import "Microphone.h"
#import "Console.h"

@interface DataManager : NSObject {}

// Returns the 'singleton' instance of this class
+ (id)sharedInstance;

// Getters
- (Show *)getShowByName:(NSString *)name;
- (NSArray *)getInputsForShow:(NSString *)name;
- (NSMutableArray *)getSignalPathForInput:(Input *)input;
- (NSMutableArray *)searchForShowByName:(NSString *)name;
- (NSMutableArray *)searchForMicrophoneByName:(NSString *)name;
- (NSArray *)getPatchesForShow:(NSString *)name;
- (NSMutableArray *)getShowList;
- (Microphone *)getMicrophoneForName:(NSString *)name;
- (NSArray *)getMicrophones;
- (BOOL)micExistsNamed:(NSString *)name;
- (NSString *)getInputNumber:(NSInteger)num forPatch:(PatchPoint *)patch;
- (NSString *)getOutputNumber:(NSInteger)num forPatch:(PatchPoint *)patch;
- (NSString *)getPatchInNumber:(NSInteger)num forPatch:(PatchPoint *)patch;
- (NSString *)getPatchOutNumber:(NSInteger)num forPatch:(PatchPoint *)patch;
- (NSString *)getInDetailOfChannel:(NSInteger)num forPatch:(PatchPoint *)patch;
- (NSString *)getOutDetailOfChannel:(NSInteger)num forPatch:(PatchPoint *)patch;
- (NSString *)getChannel:(NSInteger)channel simpleForConsole:(Console *)console;
- (NSArray *)getOpenInputChannelsForPatch:(PatchPoint *)patch;
- (NSArray *)getOpenInputChannelsForConsole:(Console *)console;
- (NSString *)getInputDetailForChannel:(NSInteger)channel inShow:(NSString *)name;
- (NSString *)getChannel:(NSInteger)channel detailForConsole:(Console *)console;

// Creators
- (void)createPatchPointWithInfo:(NSDictionary *)patchInfo;
- (void)createShowWithName:(NSString *)name;
- (void)createInputs:(NSInteger)number inShow:(NSString *)name;
- (void)createMicrophoneFromInfo:(NSDictionary *)info;
- (void)connectInput:(Input *)input toConsole:(Console *)console inChannel:(NSInteger)channel;
- (void)connectInput:(Input *)input toPatch:(PatchPoint *)patch inChannel:(NSInteger)channel;
- (void)connectPatch:(PatchPoint *)patch channel:(NSInteger)ch1 toConsole:(Console *)console channel:(NSInteger)ch2;
- (void)connectInPatch:(PatchPoint *)one toPatch:(PatchPoint *)two from:(NSInteger)numOne to:(NSInteger)numTwo;
- (void)connectOutPatch:(PatchPoint *)one toPatch:(PatchPoint *)two from:(NSInteger)numOne to:(NSInteger)numTwo;
- (void)createConsole:(NSString *)name withIns:(NSInteger)ins andOuts:(NSInteger)outs inShow:(NSString *)show;

// Setters
- (void)updateShowLastLoaded:(NSString *)name;
- (void)setShowName:(NSString *)name forShow:(Show *)show;
- (void)setName:(NSString *)name forConsole:(Console *)console;
- (void)setName:(NSString *)name forInput:(Input *)input;
- (void)setMicName:(NSString *)name forInput:(Input *)input;
- (void)setStandNotes:(NSString *)note forInput:(Input *)input;
- (void)setAccessories:(NSString *)acc forInput:(Input *)input;
- (void)setCableNotes:(NSString *)notes forInput:(Input *)input;
- (void)setName:(NSString *)name forPatch:(PatchPoint *)patch;
- (void)setLocation:(NSString *)loc forPatch:(PatchPoint *)patch;

// Deleters
- (void)deleteInput:(Input *)input;

@end
