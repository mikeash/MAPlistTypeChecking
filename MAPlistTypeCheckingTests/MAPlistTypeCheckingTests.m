//
//  MAPlistTypeCheckingTests.m
//  MAPlistTypeCheckingTests
//
//  Created by Michael Ash on 8/31/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import "MAPlistTypeCheckingTests.h"

#import "MAErrorReportingArray.h"
#import "MAErrorReportingDictionary.h"
#import "MAErrorReportingObject.h"
#import "NSObject+MAErrorReporting.h"


@implementation MAPlistTypeCheckingTests {
    MAErrorReportingDictionary *_dict;
}

- (void)setUp
{
    [super setUp];
    
    _dict = [[MAErrorReportingDictionary alloc] initWithParent: nil dictionary: @{
        @"string" : @"abc",
        @"number" : @42,
        @"dictionary" : @{
            @"string" : @"abcdef",
            @"array" : @[ @"a", @2 ]
        }
    }];
}

- (void)assertErrorCode: (NSInteger)code
{
    NSError *error = [_dict error];
    STAssertNotNil(error, @"Error should exist");
    STAssertEqualObjects([error domain], MAErrorReportingContainersErrorDomain, @"Error does not have the proper domain");
    STAssertEquals([error code], code, @"Error has incorrect code");
    [_dict setError: nil];
}

- (void)testNonexistent
{
    id obj;
    
    obj = [NSString ma_castRequiredObject: _dict[@"doesnotexist"]];
    STAssertNil(obj, @"Nonexistent object should not exist");
    [self assertErrorCode: MAErrorReportingContainersMissingRequiredKey];
    
    obj = [NSString ma_castRequiredObject: _dict[@"dictionary"][@"doesnotexist"]];
    STAssertNil(obj, @"Nonexistent object should not exist");
    [self assertErrorCode: MAErrorReportingContainersMissingRequiredKey];
    
    obj = [NSString ma_castOptionalObject: _dict[@"doesnotexist"]];
    STAssertNil(obj, @"Nonexistent object should not exist");
    STAssertNil([_dict error], @"Nonexistent optional object should not cause an error");
}

- (void)testMatchingTypes
{
    id obj;
    
    obj = [NSString ma_castRequiredObject: _dict[@"string"]];
    STAssertEqualObjects(obj, @"abc", @"Incorrect object obtained from dictionary");
    STAssertNotNil(obj, @"Existing object of correct type should not be nil");
    STAssertNil([_dict error], @"Error should be nil after fetching existing object of correct type");
    
    obj = [NSString ma_castOptionalObject: _dict[@"string"]];
    STAssertEqualObjects(obj, @"abc", @"Incorrect object obtained from dictionary");
    STAssertNil([_dict error], @"Error should be nil after fetching existing object of correct type");
    
    obj = [NSNumber ma_castRequiredObject: _dict[@"number"]];
    STAssertEqualObjects(obj, @42, @"Incorrect object obtained from dictionary");
    STAssertNil([_dict error], @"Error should be nil after fetching existing object of correct type");
    
    obj = [NSDictionary ma_castRequiredObject: _dict[@"dictionary"]];
    STAssertNotNil(obj, @"Existing object of correct type should not be nil");
    STAssertNil([_dict error], @"Error should be nil after fetching existing object of correct type");
    
    obj = [NSString ma_castRequiredObject: _dict[@"dictionary"][@"string"]];
    STAssertEqualObjects(obj, @"abcdef", @"Incorrect object obtained from dictionary");
    STAssertNil([_dict error], @"Error should be nil after fetching existing object of correct type");
    
    obj = [NSArray ma_castRequiredObject: _dict[@"dictionary"][@"array"]];
    STAssertEquals([obj count], (NSUInteger)2, @"Incorrect array count");
    STAssertNil([_dict error], @"Error should be nil after fetching existing object of correct type");
    
    obj = [NSString ma_castRequiredObject: _dict[@"dictionary"][@"array"][0]];
    STAssertEqualObjects(obj, @"a", @"Incorrect object obtained from dictionary");
    STAssertNil([_dict error], @"Error should be nil after fetching existing object of correct type");
    
    obj = [NSNumber ma_castRequiredObject: _dict[@"dictionary"][@"array"][1]];
    STAssertEqualObjects(obj, @2, @"Incorrect object obtained from dictionary");
    STAssertNil([_dict error], @"Error should be nil after fetching existing object of correct type");
}

- (void)testMismatchedTypes
{
    id obj;
    
    obj = [NSNumber ma_castRequiredObject: _dict[@"string"]];
    STAssertNil(obj, @"Incorrect type should produce a nil object");
    [self assertErrorCode: MAErrorReportingContainersWrongValueType];
    
    obj = [NSArray ma_castOptionalObject: _dict[@"string"]];
    STAssertNil(obj, @"Incorrect type should produce a nil object");
    [self assertErrorCode: MAErrorReportingContainersWrongValueType];
    
    obj = [NSString ma_castRequiredObject: _dict[@"number"]];
    STAssertNil(obj, @"Incorrect type should produce a nil object");
    [self assertErrorCode: MAErrorReportingContainersWrongValueType];
    
    obj = [NSData ma_castRequiredObject: _dict[@"dictionary"]];
    STAssertNil(obj, @"Incorrect type should produce a nil object");
    [self assertErrorCode: MAErrorReportingContainersWrongValueType];
    
    obj = [NSSet ma_castRequiredObject: _dict[@"dictionary"][@"string"]];
    STAssertNil(obj, @"Incorrect type should produce a nil object");
    [self assertErrorCode: MAErrorReportingContainersWrongValueType];
    
    obj = [NSNumber ma_castRequiredObject: _dict[@"dictionary"][@"array"]];
    STAssertNil(obj, @"Incorrect type should produce a nil object");
    [self assertErrorCode: MAErrorReportingContainersWrongValueType];
    
    obj = [NSNumber ma_castRequiredObject: _dict[@"dictionary"][@"array"][0]];
    STAssertNil(obj, @"Incorrect type should produce a nil object");
    [self assertErrorCode: MAErrorReportingContainersWrongValueType];
    
    obj = [NSString ma_castRequiredObject: _dict[@"dictionary"][@"array"][1]];
    STAssertNil(obj, @"Incorrect type should produce a nil object");
    [self assertErrorCode: MAErrorReportingContainersWrongValueType];
}

@end
