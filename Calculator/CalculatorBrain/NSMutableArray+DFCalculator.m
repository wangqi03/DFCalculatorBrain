//
//  NSMutableArray+DFCalculator.m
//  Accouting
//
//  Created by wanghaojiao on 2018/3/11.
//  Copyright © 2018年 WANG Haojiao. All rights reserved.
//

#import "NSMutableArray+DFCalculator.h"
#import "NSString+DFCalculator.h"

@implementation NSMutableArray (DFCalculator)

- (BOOL)lastObjectIsNumber {
    if (!self.count) {
        return NO;
    }
    
    return [((NSString*)self.lastObject) isANumber];
}

- (BOOL)lastObjectIsOperation {
    if (!self.count) {
        return NO;
    }
    
    return [((NSString*)self.lastObject) isAnOperationMark];
}

- (NSString*)popFirst {
    if (self.count) {
        NSString* first = self.firstObject;
        [self removeObjectAtIndex:0];
        return first;
    }
    return nil;
}

@end
