#ifdef SMART_DEBUG
#define PrintLog(tag, format...) SmartDebugWithTag(tag, __FILE__, __LINE__, NSStringFromSelector(_cmd), format)
#define CMD_STR NSStringFromSelector(_cmd)
#else
#define PrintLog(format, ...)
#define CMD_STR
#endif

#import <Foundation/Foundation.h>

void SmartDebug(const char *fileName, int lineNumber, NSString *functionName, NSString *fmt, ...);
void SmartDebugWithTag(NSString *tag, const char *fileName, int lineNumber, NSString *functionName, NSString *fmt, ...);
