//
//  DFCalculatorNumberFormatter.m
//
//  Created by wanghaojiao on 2018/3/11.
//

#import "DFCalculatorNumberFormatter.h"

@implementation DFCalculatorNumberFormatter

- (NSString*)formattedNumberFromNumberString:(NSString *)string isEditing:(BOOL)isEditing {
    if (isEditing) {
        return string;
    } else {
        NSArray* oops = [string componentsSeparatedByString:@"."];
        if (oops.count>1) {
            return string;
        } else {
            return [oops objectAtIndex:0];
        }
    }
}

- (NSString*)displayStringFromOperator:(DFCalculatorOperator *)op {
    return op;
}

- (NSString*)floatDotString {
    if (!_floatDotString) {
        NSString* onePointOne = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:1.1] numberStyle:NSNumberFormatterDecimalStyle];
        _floatDotString = [onePointOne stringByReplacingOccurrencesOfString:@"1" withString:@""];
    }
    return _floatDotString;
}

@end
