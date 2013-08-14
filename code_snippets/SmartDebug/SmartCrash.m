//
//  SmartCrash.m
//
//  Created by Nolan Warner on 8/8/13.
//  Copyright (c) 2013 Nolan Warner All rights reserved.
//

#import "SmartCrash.h"
#include <sys/types.h>
#include <sys/sysctl.h>

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

#pragma mark - Helper Methods

+ (NSString *)platformString
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);

    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
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
