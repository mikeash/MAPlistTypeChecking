//
//  MAPlistTypeCheckingTests.m
//  MAPlistTypeCheckingTests
//
//  Created by Michael Ash on 8/31/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "MAErrorReportingArray.h"
#import "MAErrorReportingDictionary.h"
#import "MAErrorReportingObject.h"
#import "NSObject+MAErrorReporting.h"


@interface MAPlistTypeCheckingTests : SenTestCase
@end

@implementation MAPlistTypeCheckingTests {
    MAErrorReportingDictionary *_dict;
}

- (void)setUp
{
    [super setUp];
    
    _dict = [[MAErrorReportingDictionary alloc] initWithDictionary: @{
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
    [self assertErrorCode: code keyPath: nil];
}

- (void)assertErrorCode: (NSInteger)code keyPath: (NSArray *)keyPath
{
    NSError *error = [_dict error];
    STAssertNotNil(error, @"Error should exist");
    STAssertEqualObjects([error domain], MAErrorReportingContainersErrorDomain, @"Error does not have the proper domain");
    STAssertEquals([error code], code, @"Error has incorrect code");
    if(keyPath)
        STAssertEqualObjects([error userInfo][MAErrorReportingContainersKeyPathUserInfoKey], keyPath, @"Error does not have correct key path");
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

- (void)testErrorAccumulation
{
    [NSString ma_castRequiredObject: _dict[@"doesnotexist"]];
    [NSString ma_castRequiredObject: _dict[@"dictionary"][@"doesnotexist"]];
    [NSString ma_castOptionalObject: _dict[@"doesnotexist"]];
    [NSNumber ma_castRequiredObject: _dict[@"string"]];
    [NSArray ma_castOptionalObject: _dict[@"string"]];
    [NSString ma_castRequiredObject: _dict[@"number"]];
    [NSData ma_castRequiredObject: _dict[@"dictionary"]];
    [NSSet ma_castRequiredObject: _dict[@"dictionary"][@"string"]];
    [NSNumber ma_castRequiredObject: _dict[@"dictionary"][@"array"]];
    [NSNumber ma_castRequiredObject: _dict[@"dictionary"][@"array"][0]];
    [NSString ma_castRequiredObject: _dict[@"dictionary"][@"array"][1]];
    
    NSArray *errors = [_dict errors];
    STAssertEquals([errors count], (NSUInteger)10, @"Wrong number of errors");
    int i = 0;
    for(NSError *error in errors)
    {
        STAssertEqualObjects([error domain], MAErrorReportingContainersErrorDomain, @"Incorrect error domain");
        NSInteger code = i < 2 ? MAErrorReportingContainersMissingRequiredKey : MAErrorReportingContainersWrongValueType;
        STAssertEquals([error code], code, @"Incorrect error code at index %d error is %@, errors are %@", i, error, errors);
        i++;
    }
}

- (void)testKeyPaths
{
    [NSString ma_castRequiredObject: _dict[@"doesnotexist"]];
    [self assertErrorCode: MAErrorReportingContainersMissingRequiredKey keyPath: @[ @"doesnotexist" ]];
    
    [NSNumber ma_castRequiredObject: _dict[@"string"]];
    [self assertErrorCode: MAErrorReportingContainersWrongValueType keyPath: @[ @"string" ]];
    
    [NSNumber ma_castOptionalObject: _dict[@"string"]];
    [self assertErrorCode: MAErrorReportingContainersWrongValueType keyPath: @[ @"string" ]];
    
    [NSString ma_castRequiredObject: _dict[@"dictionary"][@"doesnotexist"]];
    [self assertErrorCode: MAErrorReportingContainersMissingRequiredKey keyPath: @[ @"dictionary", @"doesnotexist"]];
    
    [NSNumber ma_castRequiredObject: _dict[@"dictionary"][@"string"]];
    [self assertErrorCode: MAErrorReportingContainersWrongValueType keyPath: @[ @"dictionary", @"string" ]];
    
    [NSNumber ma_castRequiredObject: _dict[@"dictionary"][@"array"][0]];
    [self assertErrorCode: MAErrorReportingContainersWrongValueType keyPath: @[ @"dictionary", @"array", @0 ]];
    
    [NSString ma_castRequiredObject: _dict[@"dictionary"][@"array"][1]];
    [self assertErrorCode: MAErrorReportingContainersWrongValueType keyPath: @[ @"dictionary", @"array", @1 ]];
}

@end
