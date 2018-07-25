//
//  DFCalculatorNumberFormatter.h
//
//  Created by wanghaojiao on 2018/3/11.
//

#import <Foundation/Foundation.h>
#import "DFCalculatorBrain.h"

@interface DFCalculatorNumberFormatter : NSObject

//you can override this. isEditing indicates whether the user is still typing the number
- (NSString*)formattedNumberFromNumberString:(NSString*)string isEditing:(BOOL)isEditing;
- (NSString*)displayStringFromOperator:(DFCalculatorOperator*)op;

@end
