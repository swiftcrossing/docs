#import "SmartDebug.h"

void SmartDebug(const char *fileName, int lineNumber, NSString *functionName, NSString *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    
    static NSDateFormatter *debugFormatter = nil;
    if (debugFormatter == nil) {
        debugFormatter = [[NSDateFormatter alloc] init];
        [debugFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    }
    
    NSString *msg = [[NSString alloc] initWithFormat:fmt arguments:args];
    NSString *filePath = [[NSString alloc] initWithUTF8String:fileName];
    NSString *timestamp = [debugFormatter stringFromDate:[NSDate date]];
    
    fprintf(stdout, "%s [%s:%d][%s] %s\n",
            [timestamp UTF8String],
            [[filePath lastPathComponent] UTF8String],
            lineNumber,
            [functionName UTF8String],
            [msg UTF8String]);
    
    va_end(args);
}

void SmartDebugWithTag(NSString *tag, const char *fileName, int lineNumber, NSString *functionName, NSString *fmt, ...)
{
    NSString *settingsFilePath = [[NSBundle mainBundle] pathForResource:@"SmartDebug" ofType:@"plist"];
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:settingsFilePath];
    
    if (![[settingsDictionary objectForKey:tag] boolValue])
    {
        return;
    }
    
    va_list args;
    va_start(args, fmt);
    
    static NSDateFormatter *debugFormatter = nil;
    if (debugFormatter == nil) {
        debugFormatter = [[NSDateFormatter alloc] init];
        [debugFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    }
    
    if (!tag)
    {
        tag = @"";
    }
    
    NSString *msg = [[NSString alloc] initWithFormat:fmt arguments:args];
    NSString *filePath = [[NSString alloc] initWithUTF8String:fileName];
    NSString *timestamp = [debugFormatter stringFromDate:[NSDate date]];
    
    fprintf(stdout, "%s [%s:%d][%s](%s) %s\n",
            [timestamp UTF8String],
            [[filePath lastPathComponent] UTF8String],
            lineNumber,
            [functionName UTF8String],
            [tag UTF8String],
            [msg UTF8String]);
    
    va_end(args);
}
