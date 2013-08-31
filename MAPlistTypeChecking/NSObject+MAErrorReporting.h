//
//  NSObject+MAErrorReporting.h
//  MAPlistTypeChecking
//
//  Created by Michael Ash on 8/30/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const MAErrorReportingContainersErrorDomain;

enum {
    MAErrorReportingContainersMissingRequiredKey,
    MAErrorReportingContainersWrongValueType
};


@interface NSObject (MAErrorReporting)

+ (instancetype)ma_castRequiredObject: (id)obj;
+ (instancetype)ma_castOptionalObject: (id)obj;

@end
