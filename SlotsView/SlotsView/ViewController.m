//
//  ViewController.m
//  SlotsView
//
//  Created by kare on 04/08/2017.
//  Copyright © 2017 kare. All rights reserved.
//

#import "ViewController.h"
#import "UISlotsView.h"

@interface ViewController ()<UISlotsViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    UISlotsView *slotsView = [[UISlotsView alloc] init];
    slotsView.delegate = self;
    slotsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:slotsView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[slotsView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(slotsView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[slotsView(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(slotsView)]];
    [slotsView setSlotsWithLetokeDuration:0.5];
    
    UISlotsView *slotsView3 = [[UISlotsView alloc] init];
    slotsView3.delegate = self;
    slotsView3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:slotsView3];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[slotsView3]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(slotsView3)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-300-[slotsView3(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(slotsView3)]];
    NSArray *originAry3 = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"],[UIImage imageNamed:@"4"],[UIImage imageNamed:@"5"],[UIImage imageNamed:@"6"]];
    [slotsView3 setDataWithBall:originAry3 column:6 duration:0.5];
}

- (void)slotsView:(UISlotsView*)slotsView didStopResult:(NSArray *)resultAry {
    
}


@end
