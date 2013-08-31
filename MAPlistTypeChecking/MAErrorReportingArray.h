//
//  MAErrorReportingArray.h
//  MAPlistTypeChecking
//
//  Created by Michael Ash on 8/30/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAErrorReportingArray : NSArray

- (id)initWithParent: (id)parent array: (NSArray *)array;

@property (nonatomic) NSError *error;

@end
