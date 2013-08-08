//
//  SmartCrash.m
//
//  Created by Nolan Warner on 8/8/13.
//  Copyright (c) 2013 Nolan Warner All rights reserved.
//

#import "SmartCrash.h"

@implementation SmartCrash

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // Start listening for exceptions.
        NSSetUncaughtExceptionHandler(&HandleException);
    }
    
    return self;
}

/**
 * Send stored crash log to desired location. 
 * <!>To be implemented<!>
 */
- (void)sendCrashLog
{
    NSMutableArray *crashLogArray = [SmartCrash crashLogArray];
    
#ifdef SMART_DEBUG
    NSLog(@"Current Crash Logs:");
    for (NSString *crashLog in crashLogArray)
    {
        NSLog(@"Log:\n%@", crashLog);
    }
#endif
    
    // TODO: Implement sending of crash log to desired location.
}

#pragma mark - FileIO Methods

/**
 * Read crashLogArray from PList and return it.
 *
 * @return Current crashLogArray.
 */
+ (NSMutableArray *)crashLogArray
{
    NSString *crashLogPListFile = [SmartCrash crashLogPListFile];
    NSMutableArray *crashLogArray = [NSMutableArray arrayWithContentsOfFile:crashLogPListFile];
    
    if (!crashLogArray)
    {
        crashLogArray = [NSMutableArray array];
    }
    
    return crashLogArray;
}

/**
 * Write new crashLogArray to crashLog.plist.
 *
 * @param crashLogArray Updated crashLog array with the most recent crash log appended.
 */
+ (void)writeToCrashLogPListFile:(NSMutableArray *)crashLogArray
{
    NSString *crashLogPListFile = [SmartCrash crashLogPListFile];
    
    [crashLogArray writeToFile:crashLogPListFile atomically:YES];
}

/**
 * Get crashLog.plist filepath.
 */
+ (NSString *)crashLogPListFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *crashLogPListFile= [documentsDirectory stringByAppendingPathComponent:@"CrashLog.plist"];
    
    return crashLogPListFile;
}

#pragma mark - Exception Handling Methods

/**
 * Exception Handler.
 *
 * @param exception Exception thrown by the system when a crash occurs. Using stacktrack and description.
 */
void HandleException(NSException *exception) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
    
    // Create crash log message
    NSString *platform    = [[UIDevice currentDevice] model];
    NSString *version     = [[UIDevice currentDevice] systemVersion];
    NSString *date        = [dateFormatter stringFromDate:[NSDate date]];
    NSString *description = [exception description];
    NSArray *backtrace    = [exception callStackSymbols];
    NSString *message     = [NSString stringWithFormat:@"Device: %@. OS: %@.\n%@\nDescription:\n%@\nBacktrace:\n%@",
                             platform,
                             version,
                             date,
                             description,
                             backtrace];
    
    // Save message to plist
    NSMutableArray *crashLogArray = [SmartCrash crashLogArray];
    
    [crashLogArray addObject:message];
    
    [SmartCrash writeToCrashLogPListFile:crashLogArray];
    
}

@end
