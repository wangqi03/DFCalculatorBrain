//
//  ViewController.m
//  Calculator
//
//  Created by wanghaojiao on 2018/7/25.
//  Copyright © 2018年 wang. All rights reserved.
//

#import "ViewController.h"
#import "DFCalculatorBrain.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (nonatomic,strong) DFCalculatorBrain* calculatorBrain;
@end

@implementation ViewController

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.calculatorBrain = [[DFCalculatorBrain alloc] init];
    [self.calculatorBrain listenToStackDisplayChangeWithBlock:^(NSArray<NSString *> *display) {
        self.displayLabel.text = [display componentsJoinedByString:@" "];
    }];
}

#pragma mark -
- (IBAction)clickedNumber:(UIButton *)sender {
    [self.calculatorBrain clickedDigit:[sender titleForState:UIControlStateNormal]];
}
- (IBAction)clickedDot:(id)sender {
    [self.calculatorBrain clickedDot];
}

#pragma mark -
- (IBAction)clickedPlus:(id)sender {
    [self.calculatorBrain clickedOperator:DFCalculatorOperatorPlus];
}

- (IBAction)clickedMinus:(id)sender {
    [self.calculatorBrain clickedOperator:DFCalculatorOperatorMinus];
}

- (IBAction)clickedMultiply:(id)sender {
    [self.calculatorBrain clickedOperator:DFCalculatorOperatorMultiply];
}

- (IBAction)clickedDivide:(id)sender {
    [self.calculatorBrain clickedOperator:DFCalculatorOperatorDivide];
}

#pragma mark -
- (IBAction)clickedEqual:(id)sender {
    [self.calculatorBrain getResult];
}



@end
