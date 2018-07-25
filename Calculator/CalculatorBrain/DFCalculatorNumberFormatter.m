//
//  DFCalculatorNumberFormatter.m
//  csapp
//
//  Created by wanghaojiao on 2018/3/11.
//  Copyright © 2018年 CMHK. All rights reserved.
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

@end
