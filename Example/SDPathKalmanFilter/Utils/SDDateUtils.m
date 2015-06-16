//
// Created by Marek Matulski on 16/06/15.
// Copyright (c) 2015 Marek Matulski. All rights reserved.
//

#import "SDDateUtils.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>


@implementation SDDateUtils {

}

+ (ISO8601DateFormatter *)serverISO8601DateTimeFormatter {
    static dispatch_once_t once;
    static ISO8601DateFormatter* dateTimeFormatter;
    dispatch_once(&once, ^{
        dateTimeFormatter = [[ISO8601DateFormatter alloc] init];
        dateTimeFormatter.format = ISO8601DateFormatCalendar;
        dateTimeFormatter.includeTime = YES;
    });

    return dateTimeFormatter;
}

/*
    Converts NSString in ISO8601 format to NSDate
 */
+ (NSDate *)dateFromString:(NSString *)formattedDate {
    if(!formattedDate){
        return nil;
    }

    return [[self serverISO8601DateTimeFormatter] dateFromString:formattedDate];
}

@end