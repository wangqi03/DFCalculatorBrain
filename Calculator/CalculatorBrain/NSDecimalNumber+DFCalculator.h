//
//  NSDecimalNumber+Common.h
//  Accouting
//
//  Created by WANG Haojiao on 14-6-11.
//  Copyright (c) 2014年 WANG Haojiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (DFCalculator)

- (BOOL)isNegative;
- (BOOL)isPositive;
- (NSDecimalNumber*)negativeValue;
- (NSDecimalNumber*)addBy:(NSDecimalNumber*)number;
- (NSDecimalNumber*)minusBy:(NSDecimalNumber*)number;
- (NSDecimalNumber*)multiplyBy:(NSDecimalNumber*)number;
- (NSDecimalNumber*)divideBy:(NSDecimalNumber*)number;

@end
