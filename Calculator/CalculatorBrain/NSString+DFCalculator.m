//
//  NSString+DFCalculator.m
//  Accouting
//
//  Created by wanghaojiao on 2018/3/11.
//  Copyright © 2018年 WANG Haojiao. All rights reserved.
//

#import "NSString+DFCalculator.h"
#import "DFCalculatorBrain.h"

@implementation NSString (DFCalculator)

- (BOOL)isANumber {
    return ![self isAnOperationMark];
}

- (BOOL)isAnOperationMark {
    return [self isEqualToString:DFCalculatorOperatorPlus]||[self isEqualToString:DFCalculatorOperatorMinus]||[self isEqualToString:DFCalculatorOperatorMultiply]||[self isEqualToString:DFCalculatorOperatorDivide];
}

- (NSDecimalNumber*)decimalValue {
    return [NSDecimalNumber decimalNumberWithString:self];
}

@end
