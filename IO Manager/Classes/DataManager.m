//
//  DataManager.m
//  CoreDataDemo
//
//  Created by John Hannan on 10/11/10.
//  Copyright 2010 Penn State University. All rights reserved.
//

#import "DataManager.h"

@interface DataManager ()
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

- (NSString *)applicationDocumentsDirectory;
- (void)saveContext;
// Checks to see if any database exists on disk
- (BOOL)databaseExists;

// Returns an array of objects already in the database for the given Entity Name and Predicate
- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate sortedBy:(NSString *)descriptor;
@end

@implementation DataManager
@synthesize managedObjectContext=_managedObjectContext;
@synthesize managedObjectModel=_managedObjectModel;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;

#pragma mark - Initialization
+(void)createDatabaseFor:(DataManager *)dataManager {
    
    NSManagedObjectContext *managedObjectContext = [dataManager managedObjectContext];
        
    Show *show = [NSEntityDescription insertNewObjectForEntityForName:@"Show" inManagedObjectContext:managedObjectContext];
    show.name = @"Example Show";
    
    Console *console = [NSEntityDescription insertNewObjectForEntityForName:@"Console" inManagedObjectContext:managedObjectContext];    
    console.name = @"A&H GL2800";
    console.maxChannels = [NSNumber numberWithInt:48];
    console.numOutputs = [NSNumber numberWithInt:16];
    console.show = show;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"microphones" ofType:@"plist"];
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary *item in plistArray) {
        Microphone *newMic = [NSEntityDescription insertNewObjectForEntityForName:@"Microphone" inManagedObjectContext:managedObjectContext];
        newMic.name = [item objectForKey:@"name"];
        newMic.type = [item objectForKey:@"type"];
        newMic.image = [UIImage imageNamed:[item objectForKey:@"image"]];
        newMic.needsPhantom = [item objectForKey:@"needsPhantom"];
    }

    [dataManager saveContext];
}


// We do not use alloc to create an instance of this object.  We use this class method
// Only one object ever created.  Database will be created the first time this app is run
+ (id)sharedInstance {
	static id singleton = nil;
	
	if (singleton == nil) {
		singleton = [[self alloc] init];
        if (![singleton databaseExists]) 
            [self createDatabaseFor:singleton];
    }
	
    return singleton;
}


#pragma mark - Save Context

- (void)saveContext {
    
    NSError *error = nil;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    

#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"IO_Manager" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"IO_Manager.sqlite"]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

- (NSString *)databasePath {
	return [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"IO_Manager.sqlite"];
}

- (BOOL)databaseExists {
	NSString	*path = [self databasePath];
	BOOL		databaseExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
	
	return databaseExists;
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Fetching Data 

- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate sortedBy:(NSString *)descriptor {
	NSManagedObjectContext	*context = [self managedObjectContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = entity;
	request.predicate = predicate;
    
    if (descriptor != @"") {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:descriptor ascending:YES];
	    
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [request setSortDescriptors:sortDescriptors];
    }
    
	NSArray	*results = [context executeFetchRequest:request error:nil];
	
	return results;
}

#pragma mark - Public Methods

// Get a show object by name:
- (Show *)getShowByName:(NSString *)name {
    DataManager *dataManager = [DataManager sharedInstance];
    NSPredicate *showPredicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    
    NSArray *showObjects = [dataManager fetchManagedObjectsForEntity:@"Show" withPredicate:showPredicate sortedBy:@"name"];

    Show *myShow = [showObjects objectAtIndex:0];
    
    return myShow;
}

// Return an array of inputs for a given show:
- (NSArray *)getInputsForShow:(NSString *)name {
    DataManager *dataManager = [DataManager sharedInstance];
    NSPredicate *inputPredicate = [NSPredicate predicateWithFormat:@"show.name == %@", name];
    
    NSArray *inputObjects = [dataManager fetchManagedObjectsForEntity:@"Input" withPredicate:inputPredicate sortedBy:@"number"];

    return inputObjects;
}

// Return an array of Patch Points for a given show:
- (NSArray *)getPatchesForShow:(NSString *)name {
    DataManager *dataManager = [DataManager sharedInstance];
    NSPredicate *patchesPredicate = [NSPredicate predicateWithFormat:@"show.name == %@", name];
    
    NSArray *patchObjects = [dataManager fetchManagedObjectsForEntity:@"PatchPoint" withPredicate:patchesPredicate sortedBy:@""];
    
    return patchObjects;
}

// Used by the load show modal view:
- (NSMutableArray *)searchForShowByName:(NSString *)name {
    DataManager *dataManager = [DataManager sharedInstance];
    NSArray *shows = [dataManager fetchManagedObjectsForEntity:@"Show" withPredicate:nil sortedBy:@"name"];
    NSMutableArray *searchResults = [[NSMutableArray alloc] initWithCapacity:[shows count]];
    
    for (Show *myShow in shows) {
        NSString *showName = myShow.name;
        
        if([showName rangeOfString:name options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [searchResults insertObject:myShow atIndex:[searchResults count]];
        }
    }
    
    return searchResults;
}

- (NSMutableArray *)searchForMicrophoneByName:(NSString *)name {
    NSArray *mics = [[DataManager sharedInstance] getMicrophones];
    
    NSMutableArray *searchResults = [[NSMutableArray alloc] initWithCapacity:[mics count]];
    
    
    if (name == @"" || name == nil)
        return [NSMutableArray arrayWithArray:mics];
    
    for (Microphone *mic in mics) {
        NSString *micName = mic.name;
        
        if ([micName rangeOfString:name options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [searchResults insertObject:mic atIndex:[searchResults count]];
        }
    }
    
    return searchResults;
}

- (NSMutableArray *)getShowList {
    DataManager *dataManager = [DataManager sharedInstance];
    NSArray *shows = [dataManager fetchManagedObjectsForEntity:@"Show" withPredicate:nil sortedBy:@"lastOpened"];
    NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:[shows count]];
    
    for (Show *myShow in shows) {
        [names addObject:myShow];
    }
    return names;
}

// Traverse the signal path of an input, up to a console.
- (NSMutableArray *)getSignalPathForInput:(Input *)input {
    
    NSMutableArray *signalPath = [[NSMutableArray alloc] initWithCapacity:10];
    
//    Connection *curConnection = input.connection;
//    PatchPoint *curPatchPoint = curConnection.output;
//    while(curConnection != nil && curPatchPoint.type != @"Console")
//    {
//        NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:curConnection.output, @"number", curPatchPoint.name, @"name", nil];
//        [signalPath addObject:item];
//        
//        // find the next connection:
//        for(Connection *c in curPatchPoint.connectionsOut) {
//            if (c.channelIn == curConnection.channelOut) {
//                curConnection = c;
//                curPatchPoint = c.output;
//                //break;
//            }
//        }
//    }
    
    return signalPath; 
}

- (Microphone *)getMicrophoneForName:(NSString *)name {
    DataManager *dataManager = [DataManager sharedInstance];
    NSPredicate *micPredicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSArray *mics = [dataManager fetchManagedObjectsForEntity:@"Microphone" withPredicate:micPredicate sortedBy:@"name"];
    return [mics objectAtIndex:0];
}

- (NSArray *)getMicrophones {
    DataManager *dataManager = [DataManager sharedInstance];
    NSArray *mics = [dataManager fetchManagedObjectsForEntity:@"Microphone" withPredicate:nil sortedBy:@"name"];
    return mics;
}

- (BOOL)micExistsNamed:(NSString *)name {
    NSArray *mics = [[DataManager sharedInstance] getMicrophones];
    for (Microphone *mic in mics) {
        if ([name rangeOfString:mic.name options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)getInputNumber:(NSInteger)num forPatch:(PatchPoint *)patch {
    for (Connection *c in patch.connectionsIn) {
        if (![c.isPatchOut boolValue] && [c.channelMale intValue] == num) {
            
            if (c.sourceInput != nil) {
                return [NSString stringWithFormat:@"in %d", [[c.sourceInput number] intValue]];
            }
            
            if (c.input != nil) {
                return [NSString stringWithFormat:@"%d", [c.channelFemale intValue]];
            }
        }
    }
    
    return @"--";
}

- (NSString *)getOutputNumber:(NSInteger)num forPatch:(PatchPoint *)patch {
    for (Connection *c in patch.connectionsOut) {
        if (![c.isPatchOut boolValue] && [c.channelFemale intValue] == num) {
            
            if (c.output != nil) {
                return [NSString stringWithFormat:@"%d", [c.channelMale intValue]];
            }
            
            if (c.consoleIn != nil) {
                return [NSString stringWithFormat:@"c %d", [c.channelMale intValue]];
            }
            
        }
    }
    return @"--";
}

- (NSString *)getPatchOutNumber:(NSInteger)num forPatch:(PatchPoint *)patch {
    for (Connection *c in patch.connectionsOut) {
        if ([c.isPatchOut boolValue] && [c.channelMale intValue] == num) {
            if (c.input != nil) {
                return [NSString stringWithFormat:@"%d", [c.channelFemale intValue]];
            }
            
            if (c.consoleOut != nil) {
                return [NSString stringWithFormat:@"c %d", [c.channelFemale intValue]];
            }
        }
    }
    
    return @"--";
}

- (NSString *)getPatchInNumber:(NSInteger)num forPatch:(PatchPoint *)patch {
    for (Connection *c in patch.connectionsIn) {
        if ([c.isPatchOut boolValue] && [c.channelFemale intValue] == num) {
            if (c.output != nil) {
                return [NSString stringWithFormat:@"%d", [c.channelMale intValue]];
            }
            
            if (c.consoleIn != nil) {
                return [NSString stringWithFormat:@"c %d", [c.channelMale intValue]];
            }
        }
    }
    
    return @"--";
}

- (NSString *)getInDetailOfChannel:(NSInteger)num forPatch:(PatchPoint *)patch {
    
    for (Connection *c in patch.connectionsIn) {
        if (![c.isPatchOut boolValue] && [c.channelMale intValue] == num) {
            
            if (c.input != nil) {
                return [NSString stringWithFormat:@"%@: %d", c.input.name, [c.channelFemale intValue]];
            }
            
            if (c.sourceInput != nil) {
                return [NSString stringWithFormat:@"%@ (%d)", c.sourceInput.name, [c.sourceInput.number intValue]];
            }
        }
    }
    
    return @"--";
}

- (NSString *)getOutDetailOfChannel:(NSInteger)num forPatch:(PatchPoint *)patch {
    for (Connection *c in patch.connectionsOut) {
        if (![c.isPatchOut boolValue] && [c.channelFemale intValue] == num) {
            
            if (c.output != nil) {
                return [NSString stringWithFormat:@"%@: %d", c.output.name, [c.channelMale intValue]];
            }
            
            if (c.consoleIn != nil) {
                return [NSString stringWithFormat:@"Console %d", [c.channelMale intValue]];
            }
        }
    }
    
    return @"--";
}

- (NSArray *)getOpenInputChannelsForPatch:(PatchPoint *)patch {
    NSInteger end = [patch.maxIn intValue];
    NSMutableArray *channels = [[NSMutableArray alloc] initWithCapacity:end];
    
    for (int i = 1; i <= end; i++) {
        BOOL found = NO;
        for (Connection *c in patch.connectionsIn) {
            if (![c.isPatchOut boolValue] && [c.channelMale intValue] == i) {
                //NSLog(@"found connection into %d", i);
                found = YES;
            }
        } 
        
        if (!found) {
            //NSLog(@"putting channel %d in the list.", i);
            [channels addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    return channels;
}

- (NSArray *)getOpenInputChannelsForConsole:(Console *)console {
    NSInteger end = [console.maxChannels intValue];
    NSMutableArray *channels = [[NSMutableArray alloc] initWithCapacity:end];
    
    for (int i = 1; i <= end; i++) {
        BOOL found = NO;
        for (Connection *c in console.inputs) {
            if (![c.isPatchOut boolValue] && [c.channelMale intValue] == i)
                found = YES;
        }
        
        if (!found)
            [channels addObject:[NSNumber numberWithInt:i]];
    }
    
    return channels;
}

- (NSString *)getInputDetailForChannel:(NSInteger)channel inShow:(NSString *)name {
    DataManager *dataManager = [DataManager sharedInstance];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"show.name == %@", name];
    NSArray *arr = [dataManager fetchManagedObjectsForEntity:@"Input" withPredicate:pred sortedBy:@"number"];

    for (Input *input in arr) {
        if ([input.number intValue] == channel)
            return input.name;
    }
    
    return @"No Input";
}

- (NSString *)getChannel:(NSInteger)channel detailForConsole:(Console *)console {
    NSString *title = @"Disconnected";
    for (Connection *c in console.inputs) {
        if ([c.channelMale intValue] == channel) {
            if (c.input != nil) {
                title = [NSString stringWithFormat:@"%@: %d", c.input.name, [c.channelFemale intValue]];
                return title;
            }
            
            if (c.sourceInput != nil) {
                title = @"Direct";
                return title;
            }
        }
    }
    
    return title;
}

- (NSString *)getChannel:(NSInteger)channel simpleForConsole:(Console *)console {
    NSString *title = @"--";
    for (Connection *c in console.inputs) {
        if ([c.channelMale intValue] == channel) {
            if (c.input != nil) {
                title = [NSString stringWithFormat:@"p %d", [c.channelFemale intValue]];
                return title;
            }
            
            if (c.sourceInput != nil) {
                title = [NSString stringWithFormat:@"dr %d", [c.sourceInput.number intValue]];
                return title;
            }
        }
    }
    
    return title;
}

// Creation methods:
- (void)createShowWithName:(NSString *)name {
    DataManager *dataManager = [DataManager sharedInstance];
    Show *show = [NSEntityDescription insertNewObjectForEntityForName:@"Show" inManagedObjectContext:dataManager.managedObjectContext];
    show.name = name;
    [dataManager saveContext];
}

- (void)createPatchPointWithInfo:(NSDictionary *)patchInfo {
    
    DataManager *dataManager = [DataManager sharedInstance];
    PatchPoint *patch = [NSEntityDescription insertNewObjectForEntityForName:@"PatchPoint" inManagedObjectContext:dataManager.managedObjectContext];
    Show *myShow = [dataManager getShowByName:[patchInfo valueForKey:@"showName"]];
    
    patch.name = [patchInfo valueForKey:@"name"];
    patch.maxIn = [patchInfo valueForKey:@"maxIn"];
    patch.maxOut = [patchInfo valueForKey:@"maxOut"];
    patch.show = myShow;
    patch.type = [patchInfo valueForKey:@"type"];
    patch.location = [patchInfo valueForKey:@"location"];
    
    [dataManager saveContext];
}

- (void)createInputs:(NSInteger)number inShow:(NSString *)name {
    DataManager *dataManager = [DataManager sharedInstance];
    Show *curShow = [dataManager getShowByName:name];
    NSArray *inputs = [dataManager getInputsForShow:name];
    Input *last = [inputs lastObject];
    NSInteger start;
    
    if (last != nil) 
        start = [last.number integerValue]+1;
    else
        start = 1;
    
    for (int i = start; i < start + number; i++) {
        Input *newInput = [NSEntityDescription insertNewObjectForEntityForName:@"Input" inManagedObjectContext:dataManager.managedObjectContext];
        newInput.number = [NSNumber numberWithInt:i];
        newInput.name = [NSString stringWithFormat:@"Input %d", i];
        newInput.show = curShow;
    }
    
    [dataManager saveContext];
}

- (void)createMicrophoneFromInfo:(NSDictionary *)info {
    DataManager *dataManager = [DataManager sharedInstance];
    Microphone *newMic = [NSEntityDescription insertNewObjectForEntityForName:@"Microphone" inManagedObjectContext:dataManager.managedObjectContext];
    
    newMic.name = [info objectForKey:@"name"];
    newMic.type = [info objectForKey:@"type"];
    newMic.needsPhantom = [info objectForKey:@"needsPhantom"];
    newMic.image = [info objectForKey:@"image"];
    newMic.settings = [info objectForKey:@"settings"];
    [dataManager saveContext];
}

- (void)connectInput:(Input *)input toPatch:(PatchPoint *)patch inChannel:(NSInteger)channel {
    DataManager *dataManager = [DataManager sharedInstance];
    
    Connection *new = [NSEntityDescription insertNewObjectForEntityForName:@"Connection" inManagedObjectContext:dataManager.managedObjectContext];
    
    new.sourceInput = input;
    new.output = patch;
    new.channelMale = [NSNumber numberWithInt:channel];
    new.channelFemale = input.number;
    new.show = input.show;
    [dataManager saveContext];
}

- (void)connectInput:(Input *)input toConsole:(Console *)console inChannel:(NSInteger)channel {
    DataManager *dataManager = [DataManager sharedInstance];
    
    Connection *new = [NSEntityDescription insertNewObjectForEntityForName:@"Connection" inManagedObjectContext:dataManager.managedObjectContext];
    
    new.sourceInput = input;
    new.consoleIn = console;
    new.channelMale = [NSNumber numberWithInt:channel];
    new.channelFemale = input.number;
    new.show = input.show;
    [dataManager saveContext];
}

- (void)createConsole:(NSString *)name withIns:(NSInteger)ins andOuts:(NSInteger)outs inShow:(NSString *)show {
    DataManager *dataManager = [DataManager sharedInstance];
    
    Console *new = [NSEntityDescription insertNewObjectForEntityForName:@"Console" inManagedObjectContext:dataManager.managedObjectContext];
    
    Show *myShow = [dataManager getShowByName:show];
    new.maxChannels = [NSNumber numberWithInt:ins];
    new.numOutputs = [NSNumber numberWithInt:outs];
    new.show = myShow;
    new.name = name;
    
    [dataManager saveContext];
}

// Update methods:
- (void)updateShowLastLoaded:(NSString *)name {
    Show *curShow = [[DataManager sharedInstance] getShowByName:name];
    curShow.lastOpened = [NSDate date];
    [[DataManager sharedInstance] saveContext];
}
- (void)connectInPatch:(PatchPoint *)one toPatch:(PatchPoint *)two from:(NSInteger)numOne to:(NSInteger)numTwo {
    DataManager *dataManager = [DataManager sharedInstance];
    
    // check for existing connection:
    Connection *existing = nil;
    for (Connection *c in one.connectionsOut) {
        if (![c.isPatchOut boolValue] && c.channelFemale == [NSNumber numberWithInt:numOne])
            existing = c;
    }
    
    if (existing == nil) {
        existing = [NSEntityDescription insertNewObjectForEntityForName:@"Connection" inManagedObjectContext:dataManager.managedObjectContext];
        existing.channelFemale = [NSNumber numberWithInt:numOne];
        existing.channelMale = [NSNumber numberWithInt:numTwo];
        existing.input = one;
        existing.output = two;
        existing.isPatchOut = [NSNumber numberWithBool:NO];
        existing.show = one.show;
    }
    else {
        existing.channelMale = [NSNumber numberWithInt:numTwo];
        existing.output = two;
    }
        
    [dataManager saveContext];
}

- (void)connectOutPatch:(PatchPoint *)one toPatch:(PatchPoint *)two from:(NSInteger)numOne to:(NSInteger)numTwo {
    DataManager *dataManager = [DataManager sharedInstance];
    
    // check for existing connection:
    Connection *existing = nil;
    for (Connection *c in one.connectionsIn) {
        if ([c.isPatchOut boolValue] && c.output == one && c.channelMale == [NSNumber numberWithInt:numOne])
            existing = c;
    }
    
    if (existing == nil) {
        existing = [NSEntityDescription insertNewObjectForEntityForName:@"Connection" inManagedObjectContext:dataManager.managedObjectContext];
        existing.channelFemale = [NSNumber numberWithInt:numTwo];
        existing.channelMale = [NSNumber numberWithInt:numOne];
        existing.input = two;
        existing.output = one;
        existing.isPatchOut = [NSNumber numberWithBool:YES];
        existing.show = one.show;
    }
    else {
        existing.channelMale = [NSNumber numberWithInt:numTwo];
        existing.input = two;
    }
    
    [dataManager saveContext];
}

- (void)connectPatch:(PatchPoint *)patch channel:(NSInteger)ch1 toConsole:(Console *)console channel:(NSInteger)ch2 {
    DataManager *dataManager = [DataManager sharedInstance];
    Connection *existing = nil;
    
    for (Connection *c in console.inputs) {
        if ((c.input == patch && [c.channelFemale intValue] == ch1))
            existing = c;
        
        if ([c.channelMale intValue] == ch2)
            existing = c;
    }
    
    if (existing == nil) {
        existing = [NSEntityDescription insertNewObjectForEntityForName:@"Connection" inManagedObjectContext:dataManager.managedObjectContext];
        
        existing.channelFemale = [NSNumber numberWithInt:ch1];
        existing.channelMale = [NSNumber numberWithInt:ch2];
        existing.input = patch;
        existing.consoleIn = console;
        existing.show = console.show;
        existing.isPatchOut = [NSNumber numberWithBool:NO];
    }
    else {
        existing.channelFemale = [NSNumber numberWithInt:ch1];
        existing.channelMale = [NSNumber numberWithInt:ch2];
        existing.input = patch;
        existing.isPatchOut = [NSNumber numberWithBool:NO];
    }
}


- (void)setShowName:(NSString *)name forShow:(Show *)show {
    show.name = name;
    [[DataManager sharedInstance] saveContext];
}

- (void)setName:(NSString *)name forConsole:(Console *)console {
    DataManager *dataManager = [DataManager sharedInstance];
    console.name = name;
    [dataManager saveContext];
}

- (void)setName:(NSString *)name forInput:(Input *)input {
    [input setName:name];
    [[DataManager sharedInstance] saveContext];
}

- (void)setMicName:(NSString *)name forInput:(Input *)input {
    [input setMicName:name];
    [[DataManager sharedInstance] saveContext];
}

- (void)setStandNotes:(NSString *)note forInput:(Input *)input {
    [input setStandNotes:note];
    [[DataManager sharedInstance] saveContext];
}

- (void)setAccessories:(NSString *)acc forInput:(Input *)input {
    [input setAccessories:acc];
    [[DataManager sharedInstance] saveContext];
}

- (void)setCableNotes:(NSString *)notes forInput:(Input *)input {
    [input setCableLength:notes];
    [[DataManager sharedInstance] saveContext];
}

- (void)setName:(NSString *)name forPatch:(PatchPoint *)patch {
    [patch setName:name];
    [[DataManager sharedInstance] saveContext];
}

- (void)setLocation:(NSString *)loc forPatch:(PatchPoint *)patch {
    [patch setLocation:loc];
    [[DataManager sharedInstance] saveContext];
}
// Delete methods:

- (void)deleteInput:(Input *)input {
    DataManager *dataManager = [DataManager sharedInstance];
    Connection *c = input.connection;
    [dataManager.managedObjectContext deleteObject:c];
    [dataManager.managedObjectContext deleteObject:input];
    [dataManager saveContext];
}


@end
