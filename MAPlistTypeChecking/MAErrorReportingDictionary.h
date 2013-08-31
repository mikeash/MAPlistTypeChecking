//
//  MAErrorReportingDictionary.h
//  MAPlistTypeChecking
//
//  Created by Michael Ash on 8/30/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAErrorReportingDictionary : NSDictionary

- (id)initWithDictionary: (NSDictionary *)dictionary;
- (id)initWithParent: (id)parent dictionary: (NSDictionary *)dictionary key: (id)key;

@property (nonatomic) NSError *error;

- (void)addError: (NSError *)error;
- (NSArray *)errors;

@property (readonly) id key;

@end
