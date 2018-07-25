//
//  NSDecimalNumber+Common.m
//  Accouting
//
//  Created by WANG Haojiao on 14-6-11.
//  Copyright (c) 2014年 WANG Haojiao. All rights reserved.
//

#import "NSDecimalNumber+DFCalculator.h"

@implementation NSDecimalNumber (DFCalculator)

- (BOOL)isNegative {
    return [self compare:[NSDecimalNumber zero]]==NSOrderedAscending;
}

- (BOOL)isPositive {
    return [self compare:[NSDecimalNumber zero]]==NSOrderedDescending;
}

- (NSDecimalNumber*)negativeValue {
    return [[NSDecimalNumber zero] minusBy:self];
}

- (NSDecimalNumber*)addBy:(NSDecimalNumber *)number {
    if ([self isEqualToNumber:[NSDecimalNumber notANumber]]) {
        return [[NSDecimalNumber zero] addBy:number];
    }
    
    if ([number isEqualToNumber:[NSDecimalNumber notANumber]]||!number) {
        return self;
    }
    
    return [self decimalNumberByAdding:number];
}

- (NSDecimalNumber*)minusBy:(NSDecimalNumber *)number {
    if ([self isEqualToNumber:[NSDecimalNumber notANumber]]) {
        return [number negativeValue];
    }
    
    if ([number isEqualToNumber:[NSDecimalNumber notANumber]]||!number) {
        return self;
    }
    
    return [self decimalNumberBySubtracting:number];
}

- (NSDecimalNumber*)multiplyBy:(NSDecimalNumber *)number {
    if (!number) {
        return self;
    }
    
    return [self decimalNumberByMultiplyingBy:number];
}

- (NSDecimalNumber*)divideBy:(NSDecimalNumber *)number {
    if ([self isEqualToNumber:[NSDecimalNumber notANumber]]) {
        return [NSDecimalNumber zero];
    }
    
    if (!number||[number isEqualToNumber:[NSDecimalNumber notANumber]]||[number isEqualToNumber:[NSDecimalNumber zero]]) {
        if ([number isEqualToNumber:[NSDecimalNumber zero]]) {
            return [NSDecimalNumber one];
        }
        
        return [NSDecimalNumber zero];
    }
    
    return [self decimalNumberByDividingBy:number];
}

@end
