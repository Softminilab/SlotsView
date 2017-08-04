//
//  UIRandomLotteryView.m
//  KeyframeAnimation
//
//  Created by kare on 03/08/2017.
//  Copyright © 2017 kare. All rights reserved.
//

#import "UISlotsView.h"

@interface UISlotsView()
@property (nonatomic ,strong) UIButton *startSlotsBtn;
@property (nonatomic ,strong) UIView *showBallView;
@property (nonatomic ,strong) NSArray *allBallAry;
@property (nonatomic ,strong) NSMutableArray *ballLabelAry;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) NSInteger currentIndex;
@property (nonatomic ,assign) BOOL isImage;

//双色球用
@property (nonatomic ,assign) BOOL flag;


@end
@implementation UISlotsView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self configuration];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configuration];
    }
    return self;
}

- (void)configuration {
    
    UIView *ballView = [[UIView alloc] init];
    ballView.clipsToBounds = YES;
    ballView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BlackNavBar64_320x64_"]];
    ballView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:ballView];
    
    UIButton *slotsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    slotsBtn.adjustsImageWhenHighlighted = NO;
    slotsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [slotsBtn setImage:[UIImage imageNamed:@"slot_machine_rocker1"] forState:UIControlStateNormal];
    slotsBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [slotsBtn addTarget:self action:@selector(onStart:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:slotsBtn];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[ballView]-0-[slotsBtn(60)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(ballView, slotsBtn)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-32-[ballView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(ballView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[slotsBtn]-13-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(slotsBtn)]];
    self.showBallView = ballView;
    self.startSlotsBtn = slotsBtn;
}

- (void)setDataWithBall:(NSArray *)ballAry column:(NSInteger)column duration:(CGFloat)duration {
    self.flag = NO;
    NSArray *ary = nil;
    if ([ballAry[0] isKindOfClass:[UIImage class]]) {
        self.isImage = YES;
        ary = [self createLetokeAryWithImage:ballAry column:column];
    }else {
        self.isImage = NO;
        ary = [self createLetokeAryWith:ballAry column:column];
    }
    [self showBall:ary duration:duration];
}

- (void)setSlotsWithLetokeDuration:(CGFloat)duration {
    self.isImage = NO;
    self.flag = YES;
    [self showBall:[self createLetokeData] duration:duration];
}

- (void)showBall:(NSArray *)ballAry duration:(CGFloat)duration {
    self.ballLabelAry = [NSMutableArray array];
    self.allBallAry = ballAry;
    
    CGFloat scrWidth = [UIScreen mainScreen].bounds.size.width - 120;
    CGFloat ballWidth = (scrWidth - (ballAry.count * 1))/ballAry.count;
    //    68 - 16
    CGFloat subBallWidth = MIN(ballWidth, 52) - 2;
    UIView *tempVeiw = nil;
    for (int i = 0; i <ballAry.count; i++) {
        UIView *ballView = [[UIView alloc] init];
        ballView.backgroundColor = [UIColor clearColor];
        ballView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.showBallView addSubview:ballView];
        NSDictionary *metrics = @{@"Width": @(ballWidth)};
        [self.showBallView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[ballView]-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(ballView)]];
        [self.showBallView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[ballView(Width)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(ballView)]];
        if (i == 0) {
            [self.showBallView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[ballView]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(ballView)]];
        }else {
            [self.showBallView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[tempVeiw]-1-[ballView]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(tempVeiw, ballView)]];
        }
        
        UIView *layoutView = nil;
        if (self.isImage) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.tag = (duration * 30) + i * 10;
            imgView.image = [self randomObject:ballAry[i]];
            imgView.translatesAutoresizingMaskIntoConstraints = NO;
            [ballView addSubview:imgView];
            layoutView = imgView;
        }else {
            UILabel *theLabel = [[UILabel alloc] init];
            theLabel.tag = (duration * 30) + i * 5;
            if (i == ballAry.count - 1) {
                if (self.flag) {
                    theLabel.backgroundColor = [UIColor colorWithRed:64/255.0 green:131/255.0 blue:208/255.0 alpha:1];
                }else {
                    theLabel.backgroundColor = [UIColor colorWithRed:199/255.0 green:52/255.0 blue:61/255.0 alpha:1];
                }
            }else {
                theLabel.backgroundColor = [UIColor colorWithRed:199/255.0 green:52/255.0 blue:61/255.0 alpha:1];
            }
            theLabel.textColor = [UIColor whiteColor];
            theLabel.textAlignment = NSTextAlignmentCenter;
            theLabel.font = [UIFont boldSystemFontOfSize:17];
            theLabel.text = [NSString stringWithFormat:@"%@",[self randomObject:ballAry[i]]];
            theLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [ballView addSubview:theLabel];
            layoutView = theLabel;
            layoutView.layer.masksToBounds = YES;
            layoutView.layer.cornerRadius = subBallWidth/2;
        }
        
        NSDictionary *subMetrics = @{@"subWidth": @(subBallWidth)};
        [ballView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[layoutView(subWidth)]" options:0 metrics:subMetrics views:NSDictionaryOfVariableBindings(layoutView)]];
        [ballView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[layoutView(subWidth)]" options:0 metrics:subMetrics views:NSDictionaryOfVariableBindings(layoutView)]];
        [ballView addConstraint:[NSLayoutConstraint constraintWithItem:layoutView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:ballView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        [ballView addConstraint:[NSLayoutConstraint constraintWithItem:layoutView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:ballView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        
        [self.ballLabelAry addObject:layoutView];
        
        tempVeiw = ballView;
    }
}

- (void)startSlots {
    [self onStart:self.startSlotsBtn];
}

- (void)onStart:(id)sender {
    UIButton *btn = (UIButton*)sender;
    [btn setImage:[UIImage imageNamed:@"slot_machine_rocker2"] forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [btn setImage:[UIImage imageNamed:@"slot_machine_rocker3"] forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [btn setImage:[UIImage imageNamed:@"slot_machine_rocker1"] forState:UIControlStateNormal];
        });
    });
    if (self.ballLabelAry.count > 0) {
        for (int i = 1 ;i <= self.ballLabelAry.count; i++) {
            [self startAnimationWith:self.ballLabelAry[i-1] repeat:(i * 10) + 20];
        }
        if (self.timer == nil) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onRandomNumber) userInfo:nil repeats:YES];
        }
        self.startSlotsBtn.userInteractionEnabled = NO;
    }
}

- (void)onRandomNumber {
    self.currentIndex ++;
    for (int i = 0 ;i <self.ballLabelAry.count ;i ++) {
        UIView *lab = (UIView *)self.ballLabelAry[i];
        if (self.currentIndex <= lab.tag) {
            if (i == self.ballLabelAry.count - 1) {
                if (self.isImage) {
                    ((UIImageView *)self.ballLabelAry[i]).image = [self randomObject:self.allBallAry[0]];
                }else {
                    ((UILabel *)self.ballLabelAry[i]).text = [self randomObject:self.allBallAry[(self.flag ? self.allBallAry.count - 1 : 0)]];
                }
                if (self.currentIndex >= lab.tag) {
                    if ([self.timer isValid]) {
                        [self.timer invalidate];
                        self.timer = nil;
                        self.startSlotsBtn.userInteractionEnabled = YES;
                        self.currentIndex = 0;
                        if (self.delegate && [self.delegate respondsToSelector:@selector(slotsView:didStopResult:)]) {
                            [self.delegate slotsView:self didStopResult:[self resultAry]];
                        }
                    }
                }
            }else {
                if (self.isImage) {
                    ((UIImageView *)self.ballLabelAry[i]).image = [self randomObject:self.allBallAry[0]];
                }else {
                    ((UILabel *)self.ballLabelAry[i]).text = [self randomObject:self.allBallAry[0]];
                }
            }
        }
    }
}

- (void)startAnimationWith:(UILabel *)label repeat:(CGFloat)repeat {
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(label.center.x, label.center.y - 22)]];
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(label.center.x, label.center.y + 22)]];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[move];
    groupAnimation.repeatCount = label.tag;
    groupAnimation.autoreverses = NO;
    groupAnimation.duration = 0.1;
    [[label layer] addAnimation:groupAnimation forKey:@"mySlotAnimation"];
}

- (NSArray *)resultAry {
    NSMutableArray *ary = [NSMutableArray array];
    
    for (int i = 0 ;i <self.ballLabelAry.count ;i ++) {
        if (self.isImage) {
            NSInteger index = [self getIndexWithImage:((UIImageView *)self.ballLabelAry[i]).image];
            [ary addObject:@(index)];
        }else {
            [ary addObject:((UILabel *)self.ballLabelAry[i]).text];
        }
    }
    return ary;
}

- (NSInteger)getIndexWithImage:(UIImage*)findImg {
    int i = 0;
    for (UIImage *img in self.allBallAry[0]) {
        i ++;
        if (findImg == img) {
            break;
        }
    }
    return i;
}

-(id)randomObject:(NSArray *)ary {
    id obj = nil;
    if (ary.count>0) {
        int index = arc4random()%ary.count;
        obj = [ary objectAtIndex:index];
    }
    return obj;
}

- (NSArray *)createLetokeData {
    NSMutableArray *ary1 = [NSMutableArray array];
    NSMutableArray *ary2 = [NSMutableArray array];
    NSMutableArray *ary3 = [NSMutableArray array];
    NSMutableArray *ary4 = [NSMutableArray array];
    NSMutableArray *ary5 = [NSMutableArray array];
    NSMutableArray *ary6 = [NSMutableArray array];
    NSMutableArray *blueAry = [NSMutableArray array];
    for (int i = 1;i <= 29; i++) {
        NSString *str = (i > 9 ? [NSString stringWithFormat:@"%d",i]:[NSString stringWithFormat:@"0%d",i]);
        [ary1 addObject:str];
        [ary2 addObject:str];
        [ary3 addObject:str];
        [ary4 addObject:str];
        [ary5 addObject:str];
        [ary6 addObject:str];
        if (i <= 16) {
            [blueAry addObject:str];
        }
    }
    return @[ary1, ary2, ary3, ary4, ary5, ary6, blueAry];
}

- (NSArray *)createLetokeAryWithImage:(NSArray *)originAry column:(NSInteger)column {
    NSMutableArray *resultAry = [NSMutableArray array];
    for (int i = 0;i < column; i++) {
        
        [resultAry addObject:originAry];
    }
    return resultAry;
}

- (NSArray *)createLetokeAryWith:(NSArray *)originAry column:(NSInteger)column {
    NSMutableArray *resultAry = [NSMutableArray array];
    for (int i = 0;i < column; i++) {
        NSMutableArray *subAry = [NSMutableArray array];
        for (int i = 1;i <= originAry.count; i++) {
            id str = [self randomObject:originAry];
            [subAry addObject:str];
        }
        [resultAry addObject:subAry];
    }
    return resultAry;
}
@end
