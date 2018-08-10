//
//  ZYWLineView.h
//  ZYWChart
//
//  Created by 张有为 on 2016/12/27.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "ZYWBaseChartView.h"

@protocol ZYWLineViewDelegate <NSObject>

- (void)returnPrice:(double)price;

- (void)touchesBegen;
- (void)touchesEnd;

- (void)dragingWithDuration:(float)duration;

@end

@interface ZYWLineView : ZYWBaseChartView

@property(nonatomic,weak) id<ZYWLineViewDelegate> delegate;

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIColor *fillColor;
@property (nonatomic,assign) BOOL isFillColor;
@property (nonatomic,assign) BOOL isReverFillColor;
@property (nonatomic,assign) BOOL useAnimation;
@property (nonatomic,assign) BOOL hasDraggableLine;
@property (nonatomic,assign) BOOL lightEffect;

- (void)stockFill;

@end
