//
//  VersionUtil.m
//
//  Created by nolan.warner on 10/1/13.
//  Copyright (c) 2013 nolan.warner. All rights reserved.
//

#import "VersionUtil.h"

static const NSString *kSystemVersionString5_1 = @"5.1";
static const NSString *kSystemVersionString6_0 = @"6.0";
static const NSString *kSystemVersionString6_1 = @"6.1";
static const NSString *kSystemVersionString7_0 = @"7.0";
static const NSString *kSystemVersionString7_1 = @"7.1";

typedef NS_ENUM(NSInteger, SystemVersionComparator)
{
    SystemVersionComparatorGreaterThan = 0,
    SystemVersionComparatorGreaterThanOrEqualTo,
    SystemVersionComparatorLessThan,
    SystemVersionComparatorLessThanOrEqualTo,
};

@implementation VersionUtil

/**
 * 使用のシステムバージョンがversionより大きいか判定します。
 *
 * @param version 比較に使うシステムバージョン
 */
+ (BOOL)isCurrentSystemVersionGreaterThanVersion:(SystemVersion)version
{
    BOOL isCurrentSystemVersionGreaterThanVersion = [VersionUtil doesSystemVersionString:[[UIDevice currentDevice] systemVersion]
                                                                         matchComparator:SystemVersionComparatorGreaterThan
                                                                                  forRhs:version];
    
    return isCurrentSystemVersionGreaterThanVersion;
}

/**
 * 使用のシステムバージョンがversion以上か判定します。
 *
 * @param version 比較に使うシステムバージョン
 */
+ (BOOL)isCurrentSystemVersionGreaterThanOrEqualToVersion:(SystemVersion)version
{
    BOOL isCurrentSystemVersionGreaterThanOrEqualToVersion = [VersionUtil doesSystemVersionString:[[UIDevice currentDevice] systemVersion]
                                                                                  matchComparator:SystemVersionComparatorGreaterThanOrEqualTo
                                                                                           forRhs:version];
    
    return isCurrentSystemVersionGreaterThanOrEqualToVersion;
}

/**
 * 使用のシステムバージョンがversion未満か判定します。
 *
 * @param version 比較条件に使うシステムバージョン
 */
+ (BOOL)isCurrentSystemVersionLessThanVersion:(SystemVersion)version
{
    BOOL isCurrentSystemVersionLessThanVersion = [VersionUtil doesSystemVersionString:[[UIDevice currentDevice] systemVersion]
                                                                      matchComparator:SystemVersionComparatorLessThan
                                                                               forRhs:version];
    
    return isCurrentSystemVersionLessThanVersion;
}

/**
 * 使用のシステムバージョンがversion以下か判定します。
 *
 * @param version 比較に使うシステムバージョン
 */
+ (BOOL)isCurrentSystemVersionLessThanOrEqualToVersion:(SystemVersion)version
{
    BOOL isCurrentSystemVersionLessThanOrEqualToVersion = [VersionUtil doesSystemVersionString:[[UIDevice currentDevice] systemVersion]
                                                                               matchComparator:SystemVersionComparatorLessThanOrEqualTo
                                                                                        forRhs:version];
    
    return isCurrentSystemVersionLessThanOrEqualToVersion;
}

/**
 * 使用のシステムバージョンとversionが比較条件に等しいか判定します。
 *
 * @param comparator 比較条件
 * @param version 比較に使うシステムバージョン
 */
+ (BOOL)doesSystemVersionString:(NSString *)lhs matchComparator:(SystemVersionComparator)comparator forRhs:(SystemVersion)rhs
{
    NSDictionary *versionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                       kSystemVersionString5_1, [NSNumber numberWithInt:SystemVersion5_1],
                                       kSystemVersionString6_0, [NSNumber numberWithInt:SystemVersion6_0],
                                       kSystemVersionString6_1, [NSNumber numberWithInt:SystemVersion6_1],
                                       kSystemVersionString7_0, [NSNumber numberWithInt:SystemVersion7_0],
                                       kSystemVersionString7_1, [NSNumber numberWithInt:SystemVersion7_1],
                                       nil];
   
    NSString *versionString = [versionDictionary objectForKey:[NSNumber numberWithInt:rhs]];
    
    NSComparisonResult comparisonResult = [lhs compare:versionString];
    
    BOOL doesMatchCondition = NO;
    
    switch (comparator) {
        case SystemVersionComparatorGreaterThan:
            doesMatchCondition = comparisonResult == NSOrderedDescending;
            break;
        case SystemVersionComparatorGreaterThanOrEqualTo:
            doesMatchCondition = comparisonResult != NSOrderedAscending;
            break;
        case SystemVersionComparatorLessThan:
            doesMatchCondition = comparisonResult == NSOrderedAscending;
            break;
        case SystemVersionComparatorLessThanOrEqualTo:
            doesMatchCondition = comparisonResult != NSOrderedDescending;
            break;
            
        default:
            break;
    }
    
    return doesMatchCondition;
}

@end
