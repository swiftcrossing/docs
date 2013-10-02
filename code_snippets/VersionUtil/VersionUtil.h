//
//  VersionUtil.h
//
//  Created by nolan.warner on 10/1/13.
//  Copyright (c) 2013 nolan.warner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SystemVersion)
{
    SystemVersion5_1 = 0,
    SystemVersion6_0,
    SystemVersion6_1,
    SystemVersion7_0,
    SystemVersion7_1,
};

@interface VersionUtil : NSObject

+ (BOOL)isCurrentSystemVersionGreaterThanVersion:(SystemVersion)version;
+ (BOOL)isCurrentSystemVersionGreaterThanOrEqualToVersion:(SystemVersion)version;
+ (BOOL)isCurrentSystemVersionLessThanVersion:(SystemVersion)version;
+ (BOOL)isCurrentSystemVersionLessThanOrEqualToVersion:(SystemVersion)version;

@end
