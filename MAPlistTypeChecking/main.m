//
//  main.m
//  MAPlistTypeChecking
//
//  Created by Michael Ash on 8/30/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MAErrorReportingDictionary.h"
#import "NSObject+MAErrorReporting.h"


int main(int argc, const char * argv[])
{
    @autoreleasepool {
        MAErrorReportingDictionary *dict = [[MAErrorReportingDictionary alloc] initWithParent: nil dictionary: @{
                                            @"string" : @"abc",
                                            @"number" : @42,
                                            @"dictionary" : @{
                                            @"string" : @"abc",
                                            @"array" : @[ @"a", @2 ]
                                            },
                                            }];
        
        void (^Check)(char *, id) = ^(char *expr, id value) {
            NSLog(@"%s %@ %@", expr, value, [dict error]);
            [dict setError: nil];
        };
#define Check(x) Check(#x, x)
        Check([NSString ma_castRequiredObject: dict[@"nonexistent"]]);
        Check([NSString ma_castOptionalObject: dict[@"nonexistent"]]);
        Check([NSString ma_castRequiredObject: dict[@"string"]]);
        Check([NSString ma_castOptionalObject: dict[@"string"]]);
        Check([NSNumber ma_castOptionalObject: dict[@"string"]]);
        Check([NSString ma_castRequiredObject: dict[@"number"]]);
        Check([NSNumber ma_castRequiredObject: dict[@"number"]]);
        Check([NSString ma_castRequiredObject: dict[@"dictionary"]]);
        Check([NSDictionary ma_castRequiredObject: dict[@"dictionary"]]);
        Check([NSString ma_castRequiredObject: dict[@"dictionary"][@"nonexistent"]]);
        Check([NSString ma_castOptionalObject: dict[@"dictionary"][@"nonexistent"]]);
        Check([NSString ma_castRequiredObject: dict[@"dictionary"][@"string"]]);
        Check([NSNumber ma_castRequiredObject: dict[@"dictionary"][@"string"]]);
        Check([NSString ma_castRequiredObject: dict[@"dictionary"][@"array"]]);
        Check([NSString ma_castOptionalObject: dict[@"dictionary"][@"array"]]);
        Check([NSArray ma_castRequiredObject: dict[@"dictionary"][@"array"]]);
        Check([NSString ma_castRequiredObject: dict[@"dictionary"][@"array"][0]]);
        Check([NSNumber ma_castRequiredObject: dict[@"dictionary"][@"array"][0]]);
        Check([NSString ma_castRequiredObject: dict[@"dictionary"][@"array"][1]]);
        Check([NSNumber ma_castRequiredObject: dict[@"dictionary"][@"array"][1]]);
#undef Check
    }
    return 0;
}

