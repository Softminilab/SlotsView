//
//  UIRandomLotteryView.h
//  KeyframeAnimation
//
//  Created by kare on 03/08/2017.
//  Copyright © 2017 kare. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UISlotsView;
@protocol UISlotsViewDelegate<NSObject>

@optional
/**
 摇奖结束后通知结果

 @param resultAry 返回摇奖结果
 */
- (void)slotsView:(UISlotsView*)slotsView didStopResult:(NSArray *)resultAry;
@end

/**
 随机选定彩票小控件。[内部约定，总高度为100]
 */
@interface UISlotsView : UIView
@property (nonatomic ,weak) id<UISlotsViewDelegate> delegate;

/**
 由外部的数据决定内部的老虎机样子

 @param ballAry 外部数据 例如@[@"1", @"2", @"3", @"4", @"5", @"6"] | @[[UIImage imageNamed@"1"], [UIImage imageNamed@"2"]]
 @param column 需要显示的列数
 @param duration 第一个球开始到结束的总时间，后面的球程序会自动算
 */
- (void)setDataWithBall:(NSArray *)ballAry column:(NSInteger)column duration:(CGFloat)duration;
/**
 开启双色球

 @param duration 第一个球开始到结束的总时间，后面的球程序会自动算
 */
- (void)setSlotsWithLetokeDuration:(CGFloat)duration;


/**
 开始滚动
 */
- (void)startSlots;
@end
