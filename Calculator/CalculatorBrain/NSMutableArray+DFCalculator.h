//
//  NSMutableArray+DFCalculator.h
//  Accouting
//
//  Created by wanghaojiao on 2018/3/11.
//  Copyright © 2018年 WANG Haojiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (DFCalculator)

- (BOOL)lastObjectIsNumber;
- (BOOL)lastObjectIsOperation;
- (NSString*)popFirst;

@end
