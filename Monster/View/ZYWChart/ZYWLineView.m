//
//  ZYWLineView.m
//  ZYWChart
//
//  Created by 张有为 on 2016/12/27.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "ZYWLineView.h"
#import "PointOutLine.h"
#import "UIImage+GradientColor.h"
#import "CoinPairModel.h"

@interface ZYWLineView ()

@property (nonatomic,strong) NSMutableArray *modelPostionArray;
@property (nonatomic,strong) CAShapeLayer *lineChartLayer;
@property (nonatomic,strong) PointOutLine *poLine;

@end

@implementation ZYWLineView

#pragma mark setter

- (NSMutableArray*)modelPostionArray
{
    if (!_modelPostionArray)
    {
        _modelPostionArray = [NSMutableArray array];
    }
    return _modelPostionArray;
}

#pragma mark draw

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self draw];
}

- (void)drawLineLayer
{
    [self.lineChartLayer removeFromSuperlayer];
    self.lineChartLayer = nil;
    UIBezierPath *path = [UIBezierPath drawLine:self.modelPostionArray];
    self.lineChartLayer = [CAShapeLayer layer];
    self.lineChartLayer.path = path.CGPath;
    
    self.lineChartLayer.strokeColor = self.lightEffect?[UIColor whiteColor].CGColor: self.lineColor.CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    
    self.lineChartLayer.shadowColor = self.lineColor.CGColor;
    self.lineChartLayer.shadowOffset = CGSizeMake(0, 0);
    self.lineChartLayer.shadowOpacity = 1;
    
    //设置阴影路径
//    CGMutablePathRef circlePath = CGPathCreateMutable();
//    CGPathAddEllipseInRect(circlePath, NULL, self.lineChartLayer.bounds);
////    self.layerView2.layer.shadowPath = circlePath;
//
//    CGMutablePathRef squarePath = CGPathCreateMutable();
//    CGPathAddRect(squarePath, NULL, self.lineChartLayer.bounds);
//
//    self.lineChartLayer.shadowPath = squarePath;
//    CGPathRelease(circlePath);
//    CGPathRelease(squarePath);
    
    self.lineChartLayer.lineWidth = self.lineWidth;
    self.lineChartLayer.lineCap = kCALineCapRound;
    self.lineChartLayer.lineJoin = kCALineJoinRound;
    self.lineChartLayer.contentsScale = [UIScreen mainScreen].scale;
    
    [self.layer addSublayer:self.lineChartLayer];
 
    if (_isFillColor || _isReverFillColor)
    {
        ZYWLineModel *lastPoint = _modelPostionArray.lastObject;
        
        if (_isReverFillColor) {
            [path addLineToPoint:CGPointMake(lastPoint.xPosition,self.topMargin - self.height)];
            [path addLineToPoint:CGPointMake(self.leftMargin, self.topMargin - self.height)];
        } else {
            [path addLineToPoint:CGPointMake(lastPoint.xPosition,self.height - self.topMargin)];
            [path addLineToPoint:CGPointMake(self.leftMargin, self.height - self.topMargin)];
        }
        
        path.lineWidth = 0;
        [_fillColor setFill];
        [path fill];
        [path stroke];
        [path closePath];
    }
    
    if (_useAnimation) {
        [self startAnimation];
    }
    
    self.userInteractionEnabled = self.hasDraggableLine?YES:NO;
    
}

- (void)startAnimation
{
    CABasicAnimation*pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0f;
    pathAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue=@0.0f;
    pathAnimation.toValue=@(1);
    [self.lineChartLayer addAnimation:pathAnimation forKey:nil];
}

- (void)initModelPostion
{
    [_modelPostionArray removeAllObjects];
    __weak typeof(self) this = self;
    [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CoinPairModel *coinPair = self.dataArray[idx];
        CGFloat value = coinPair.endPrice;
        CGFloat xPostion = this.lineSpace*idx + this.leftMargin;
        
        CGFloat scale = [self decimalCalculate:(this.maxY - value) with:this.scaleY withSign:@"*" scale:8];
        CGFloat yPostion = scale + this.topMargin;
        
//        CGFloat yPostion = (this.maxY - value)*this.scaleY + this.topMargin;
//        NSLog(@"%.8f",coinPair.endPrice);
        ZYWLineModel *lineModel = [ZYWLineModel initPositon:xPostion yPosition:yPostion barTime:coinPair.barTimeLong price:coinPair.endPrice color:this.lineColor];
        
//        NSLog(@"Price:%f",lineModel.endPrice);
//        NSLog(@"orig:%l  time:%@",lineModel.barTimeLong,[self converTimeFormat:lineModel.barTimeLong]);
        
        [this.modelPostionArray addObject:lineModel];
    }];
}

- (void)initConfig
{
    self.lineSpace = (self.frame.size.width - self.leftMargin - self.rightMargin)/(_dataArray.count-1) ;
    NSMutableArray *ary = [NSMutableArray array];
    for (CoinPairModel *model in _dataArray) {
        NSString *str = [NSString stringWithFormat:@"%f",model.endPrice];
        [ary addObject:str];
    }
    NSNumber *min  = [ary valueForKeyPath:@"@min.floatValue"];
    NSNumber *max = [ary valueForKeyPath:@"@max.floatValue"];
    self.maxY = [max floatValue] * 1.2;
    self.minY  = [min floatValue] * 0.8;
    
//    self.maxY = [max floatValue];
//    self.minY  = [min floatValue];
//    self.scaleY = (self.height - self.topMargin - self.bottomMargin)/(self.maxY-self.minY);
    
    self.scaleY = [self decimalCalculate:(self.height - self.topMargin - self.bottomMargin) with:(self.maxY-self.minY) withSign:@"/" scale:8];
}

- (void)draw
{
    [self initConfig];
    [self initModelPostion];
//    if (self.lineChartLayer == nil) {
        [self drawLineLayer];
//    }
}

- (void)stockFill
{
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_poLine == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PointOutLine" owner:self options:nil];
        if (kScreenHeight == 568) {
            _poLine = [nib objectAtIndex:1];
        } else {
            _poLine = [nib objectAtIndex:0];
        }
        
    }
    
    [self.delegate touchesBegen];
    UITouch *touch = [touches anyObject];
    //    // 取得触摸点在当前视图中的位置
    CGPoint current = [touch locationInView:self];
    
    if(kScreenHeight == 568){
        [_poLine setFrame:CGRectMake(current.x - 22, 20, 44, self.frame.size.height - 80)];
    } else {
        
        [_poLine setFrame:CGRectMake(current.x - 22, -30, 44, self.frame.size.height - 80)];
    }
    
    [self addSubview:_poLine];
    
    int index = (current.x - self.leftMargin)/self.lineSpace;
    if (index >= 0 && index < self.modelPostionArray.count) {
        ZYWLineModel *lineModel = [self.modelPostionArray objectAtIndex:index];
        [_poLine setValue:[self converTimeFormat:lineModel.barTimeLong]];
        [self.delegate returnPrice:lineModel.endPrice];
    }
    
//    NSLog(@"bounds:%@ \n nowPoint:%@",NSStringFromCGRect(self.bounds),NSStringFromCGPoint(current));
//    NSLog(@"poLine.frame %@ \n %@",NSStringFromCGRect(_poLine.frame),NSStringFromCGPoint(current));
}

- (NSString*)converTimeFormat:(long)barTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/China"]];
    [formatter setDateFormat:@"hh:mm MM/dd"];
    // Date to string
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:barTime/1000];
    NSString *currentDateString = [formatter stringFromDate:now];
    return currentDateString;
}

// 触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.delegate touchesEnd];
//    NSLog(@"RedView:touchesEnded");
    [_poLine removeFromSuperview];
}

// 触摸移动中（随着手指的移动，会多次调用该方法）
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    NSLog(@"RedView:touchesMoved");
    
//    /* 设置当前view随手指移动 */
//    // 取得一个触摸对象（对于多点触摸可能有多个对象）
    UITouch *touch = [touches anyObject];
//    // 取得触摸点在当前视图中的位置
    CGPoint current = [touch locationInView:self];
//    // 取得前一个触摸点位置
    CGPoint previous = [touch previousLocationInView:self];
//    // 触摸点移动偏移量
    CGPoint offset = CGPointMake(current.x-previous.x, current.y-previous.y);
//    // 当前视图移动前的中点位置（相对于父视图）
    CGPoint center = _poLine.center;
//    // 重新设置当前视图新位置
    _poLine.center = CGPointMake(center.x+offset.x, center.y);
    
    int index = (center.x+offset.x - self.leftMargin)/self.lineSpace;
//    NSLog(@"total:%lu index:%d",(unsigned long)self.modelPostionArray.count,index);
    if (index >= 0 && index < self.modelPostionArray.count) {
        ZYWLineModel *lineModel = [self.modelPostionArray objectAtIndex:index];
        [_poLine setValue:[self converTimeFormat:lineModel.barTimeLong]];
        [self.delegate returnPrice:lineModel.endPrice];
//        NSLog(@"timeStr:%lu ,time:%@",lineModel.barTimeLong,[self converTimeFormat:lineModel.barTimeLong]);
//        NSLog(@"Price:%f",lineModel.endPrice);
    }
    [self.delegate dragingWithDuration:5/offset.x];
    
}


- (CGFloat)decimalCalculate:(CGFloat)fnum1 with:(CGFloat)fnum2 withSign:(NSString*)sign scale:(short)scale{
    
    NSString *numStr1 = [NSString stringWithFormat:@"%g",fnum1];
    NSString *numStr2 = [NSString stringWithFormat:@"%g",fnum2];
    
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:numStr1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:numStr2];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundUp
                                       scale:scale
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:NO];
    NSDecimalNumber *result;
    if ([sign isEqualToString:@"+"]) {
        result = [num1 decimalNumberByAdding:num2 withBehavior:roundUp];
    } else if([sign isEqualToString:@"-"]) {
        result = [num1 decimalNumberBySubtracting:num2 withBehavior:roundUp];
    } else if([sign isEqualToString:@"*"]) {
        result = [num1 decimalNumberByMultiplyingBy:num2 withBehavior:roundUp];
    } else if([sign isEqualToString:@"/"]) {
        result = [num1 decimalNumberByDividingBy:num2 withBehavior:roundUp];
    }
    
    NSString *resultStr;
    if ([[result stringValue] isEqual:@"NaN"]) {
        resultStr = @"0";
    } else {
        resultStr = [result stringValue];
    }
    
    return [resultStr floatValue];
}

@end
