//
//  DFCalculatorBrain.m
//  Accouting
//
//  Created by wanghaojiao on 2018/3/11.
//  Copyright © 2018年 WANG Haojiao. All rights reserved.
//

#import "DFCalculatorBrain.h"
#import "NSMutableArray+DFCalculator.h"
#import "NSString+DFCalculator.h"
#import "NSDecimalNumber+DFCalculator.h"
#import "DFCalculatorNumberFormatter.h"

@interface DFCalculatorBrain()

@property (nonatomic,strong) NSMutableArray* numbersAndOperations;
@property (nonatomic,strong) DFCalculatorBrainUpdatingDisplayBlock updatingBlock;

@end

@interface NSMutableArray (DFOperatorReverse)
- (NSMutableArray*)reverseOperators;
@end

@implementation DFCalculatorBrain

- (void)setDefaultValue:(NSDecimalNumber *)value {
    [self.numbersAndOperations removeAllObjects];
    [self.numbersAndOperations addObject:[NSString stringWithFormat:@"%@",value]];
    [self refreshDisplay];
}

- (void)clearInput {
    [self.numbersAndOperations removeAllObjects];
    [self.numbersAndOperations addObject:@"0"];
    [self refreshDisplay];
}

#pragma mark - Actions
- (BOOL)clickedDigit:(NSString *)digit {
    
    //logic
    if (![self.numbersAndOperations lastObjectIsNumber]) {
        [self.numbersAndOperations addObject:digit];
    } else {
        if (![self appendNumber:digit]) {
            return NO;
        }
    }
    
    //ui
    [self refreshDisplay];
    return YES;
}

- (BOOL)clickedDot {
    //logic
    if (![self.numbersAndOperations lastObjectIsNumber]) {
        [self.numbersAndOperations addObject:@"."];
    } else {
        if (![self appendNumber:@"."]) {
            return NO;
        }
    }
    
    //ui
    [self refreshDisplay];
    return YES;
}

- (BOOL)clickedOperator:(DFCalculatorOperator *)calculatorOperator {
    if ([calculatorOperator isEqualToString:[self.numbersAndOperations lastObject]]) {
        return NO;
    }
    
    //logic
    if ([calculatorOperator isEqualToString:DFCalculatorOperatorMinus]) {
        if (![self.numbersAndOperations count]||[self.numbersAndOperations lastObjectIsNumber]) {
            [self.numbersAndOperations addObject:calculatorOperator];
        } else {
            [self.numbersAndOperations removeLastObject];
            [self.numbersAndOperations addObject:calculatorOperator];
        }
    } else {
        if ([self.numbersAndOperations lastObjectIsNumber]) {
            [self.numbersAndOperations addObject:calculatorOperator];
        } else {
            [self.numbersAndOperations removeLastObject];
            [self.numbersAndOperations addObject:calculatorOperator];
        }
    }
    
    //ui
    [self refreshDisplay];
    
    return YES;
}

- (BOOL)clickedDelete {
    //logic
    BOOL onlyZero=(self.numbersAndOperations.count==1)&&[[self.numbersAndOperations lastObject] isEqualToString:@"0"];
    if (!self.numbersAndOperations.count||onlyZero) {
        return NO;
    }
    if ([self.numbersAndOperations lastObjectIsNumber]) {
        [self removeNumber];
    } else {
        [self.numbersAndOperations removeObjectAtIndex:self.numbersAndOperations.count-1];
    }
    
    [self refreshDisplay];
    return YES;
}

- (NSDecimalNumber*)getResult {
    NSDecimalNumber* number = [[self class] getResultFromStack:self.calculatorStack];
    
    NSString* numberString = nil;
    if (self.isCurrency) {
        numberString = [NSString stringWithFormat:@"%.2f",number.doubleValue];
        
        NSArray* com = [numberString componentsSeparatedByString:@"."];
        if ([[com lastObject] doubleValue]==0) {
            numberString = [com firstObject];
        }
        
    } else {
        numberString = [NSString stringWithFormat:@"%f",number.doubleValue];
        
        NSArray<NSString*>* com = [numberString componentsSeparatedByString:@"."];
        if ([[com lastObject] doubleValue]==0) {
            numberString = [com firstObject];
        } else if ([com lastObject].length>self.precision) {
            numberString = [[com firstObject] stringByAppendingFormat:@".%@",[[com lastObject] substringToIndex:self.precision]];
        }
        
    }
    
    if (self.numbersAndOperations.count == 1 && [self.numbersAndOperations.lastObject isEqualToString:numberString]) {
        
    } else {
        self.numbersAndOperations = [@[numberString] mutableCopy];
        [self refreshDisplay];
    }
    
    return number;
}

+ (NSDecimalNumber*)getResultFromStack:(NSArray<NSString *> *)stack {
    
    NSMutableArray<NSString*>* stackCopy = [stack mutableCopy];
    NSString* item = [stackCopy popFirst];
    
    if ([item isANumber]) {
        return [self getResultFromNumber:[item decimalValue] withOp:[stackCopy popFirst] andStack:stackCopy];
    } else {
        return [self getResultFromNumber:[NSDecimalNumber zero] withOp:item andStack:stackCopy];
    }
    
}

+ (NSDecimalNumber*)getResultFromNumber:(NSDecimalNumber*)number withOp:(DFCalculatorOperator*)op andStack:(NSMutableArray<NSString *> *)stack {
    
    NSDecimalNumber* result = number;
    
    
    NSString* nextItem = [stack popFirst];
    NSString* nextOp = [stack popFirst];
    
    if (!nextItem) {
        return result;
    }
    
    if ([op isEqualToString:DFCalculatorOperatorPlus]) {
        result = [result addBy:[self getResultFromNumber:[nextItem decimalValue] withOp:nextOp andStack:stack]];
    } else if ([op isEqualToString:DFCalculatorOperatorMinus]) {
        
        if ([nextOp isEqualToString:DFCalculatorOperatorPlus]) {
            nextOp = DFCalculatorOperatorMinus;
        } else if ([nextOp isEqualToString:DFCalculatorOperatorMinus]) {
            nextOp = DFCalculatorOperatorPlus;
        }
        
        result = [result minusBy:[self getResultFromNumber:[nextItem decimalValue] withOp:nextOp andStack:[stack reverseOperators]]];
    } else if ([op isEqualToString:DFCalculatorOperatorMultiply]) {
        result = [result multiplyBy:[nextItem decimalValue]];
        return [self getResultFromNumber:result withOp:nextOp andStack:stack];
    } else if ([op isEqualToString:DFCalculatorOperatorDivide]) {
        result = [result divideBy:[nextItem decimalValue]];
        return [self getResultFromNumber:result withOp:nextOp andStack:stack];
    }

    return result;
}

#pragma mark - Assist
- (BOOL)appendNumber:(NSString*)number {
    NSString* lastNumber;
    
    if (!self.numbersAndOperations.count) {
        lastNumber=@"0";
    } else {
        lastNumber=[self.numbersAndOperations lastObject];
    }
    
    //in case clicking a dot
    if ([number isEqualToString:@"."]) {
        //ingore input if a dot already exists
        if ([lastNumber rangeOfString:@"."].length) {
            return NO;
        }
    }
    
    //in case clicking a number
    else {
        //in case appending number to a "float"
        if ([lastNumber rangeOfString:@"."].length) {
            //ignore number if reaches minimum precision
            if (self.isCurrency) {
                if (lastNumber.length-[lastNumber rangeOfString:@"."].location>2) {
                    return NO;
                }
            } else if (lastNumber.length-[lastNumber rangeOfString:@"."].location>self.precision) {
                return NO;
            }
        }
        
        //in case of integer
        else {
            //ignore if both are 0
            if ([lastNumber isEqualToString:@"0"]) {
                
                if ([number isEqualToString:@"0"]) {
                    
                } else {
                    lastNumber=number;
                    if (self.numbersAndOperations.count) {
                        [self.numbersAndOperations replaceObjectAtIndex:self.numbersAndOperations.count-1 withObject:lastNumber];
                    } else {
                        [self.numbersAndOperations addObject:lastNumber];
                    }
                }
                
                return YES;
            }
            
            //limit length of input
            if (lastNumber.length>=9) {
                return NO;
            }
        }
    }
    
    lastNumber=[lastNumber stringByAppendingString:number];
    
    if (self.numbersAndOperations.count) {
        [self.numbersAndOperations replaceObjectAtIndex:self.numbersAndOperations.count-1 withObject:lastNumber];
    } else {
        [self.numbersAndOperations addObject:lastNumber];
    }
    
    return YES;
}

- (void)removeNumber {
    NSString* lastNumber=[self.numbersAndOperations lastObject];
    
    lastNumber = [lastNumber substringToIndex:lastNumber.length-1];
    
    if (![lastNumber rangeOfString:@"."].length) {
        
    } else {
        NSString* subString=[lastNumber substringFromIndex:[lastNumber rangeOfString:@"."].location];
        double subStringValue=subString.doubleValue;
        if (subStringValue>0) {
            
        } else {
            lastNumber = [lastNumber stringByReplacingOccurrencesOfString:subString withString:@""];
        }
    }
    
    if (!lastNumber.length) {
        [self.numbersAndOperations removeObjectAtIndex:self.numbersAndOperations.count-1];
    } else {
        [self.numbersAndOperations replaceObjectAtIndex:self.numbersAndOperations.count-1 withObject:lastNumber];
    }
}

- (void)clickedEquals {
    //tbc...
}

- (void)refreshDisplay {
    self.calculatorStack = self.numbersAndOperations;
}

#pragma mark - kvo
- (void)listenToStackDisplayChangeWithBlock:(DFCalculatorBrainUpdatingDisplayBlock)block {
    [self stopListening];
    if (block) {
        self.updatingBlock = block;
        [self addObserver:self forKeyPath:@"calculatorStack" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)stopListening {
    if (self.updatingBlock) {
        self.updatingBlock = nil;
        [self removeObserver:self forKeyPath:@"calculatorStack"];
    }
}

- (void)dealloc {
    [self stopListening];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self && [keyPath isEqualToString:@"calculatorStack"]) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        [self.calculatorStack enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isAnOperationMark]) {
                [array addObject:obj];
            } else {
                [array addObject:[self.formatter formattedNumberFromNumberString:obj isEditing:(idx == self.calculatorStack.count-1)]];
            }
        }];
        self.updatingBlock(array);
    }
}


#pragma mark - Getters
- (NSMutableArray*)numbersAndOperations {
    if (!_numbersAndOperations) {
        _numbersAndOperations = [[NSMutableArray alloc] init];
    }
    return _numbersAndOperations;
}

- (NSInteger)precision {
    if (!_precision) {
        _precision = 6;
    }
    return _precision;
}

- (NSInteger)numberLengthLimit {
    if (!_numberLengthLimit) {
        _numberLengthLimit = 9;
    }
    return _numberLengthLimit;
}

- (DFCalculatorNumberFormatter*)formatter {
    if (!_formatter) {
        _formatter = [[DFCalculatorNumberFormatter alloc] init];
    }
    return _formatter;
}

@end

@implementation NSMutableArray (DFOperatorReverse)
- (NSMutableArray*)reverseOperators {
    NSMutableArray* reversed = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    for (NSInteger i=0; i<self.count; i++) {
        if ([[self objectAtIndex:i] isEqualToString:DFCalculatorOperatorMinus]) {
            [reversed addObject:DFCalculatorOperatorPlus];
        } else if ([[self objectAtIndex:i] isEqualToString:DFCalculatorOperatorPlus]) {
            [reversed addObject:DFCalculatorOperatorMinus];
        } else {
            [reversed addObject:[self objectAtIndex:i]];
        }
    }
    
    return reversed;
}
@end

