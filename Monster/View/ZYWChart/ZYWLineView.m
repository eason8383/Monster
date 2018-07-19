//
//  ZYWLineView.m
//  ZYWChart
//
//  Created by 张有为 on 2016/12/27.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "ZYWLineView.h"

@interface ZYWLineView ()

@property (nonatomic,strong) NSMutableArray *modelPostionArray;
@property (nonatomic,strong) CAShapeLayer *lineChartLayer;

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
    self.lineChartLayer.strokeColor = self.lineColor.CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];

    self.lineChartLayer.lineWidth = self.lineWidth;
    self.lineChartLayer.lineCap = kCALineCapRound;
    self.lineChartLayer.lineJoin = kCALineJoinRound;
    self.lineChartLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.lineChartLayer];
 
    if (_isFillColor)
    {
        ZYWLineModel *lastPoint = _modelPostionArray.lastObject;
        [path addLineToPoint:CGPointMake(lastPoint.xPosition,self.height - self.topMargin)];
        [path addLineToPoint:CGPointMake(self.leftMargin, self.height - self.topMargin)];
        path.lineWidth = 0;
        [_fillColor setFill];
        [path fill];
        [path stroke];
        [path closePath];
    }
    
    if (_useAnimation) {
        [self startAnimation];
    }
    
    if (self.hasDraggableLine) {
        [self adddraggerableView];
    }
}

- (void)adddraggerableView{
    UIView *draggableObj = [[UIView alloc] initWithFrame:CGRectMake(20, 0,2,100)];
    [draggableObj setBackgroundColor:[UIColor redColor]];
    //创建手势
    UIPanGestureRecognizer *panGR =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(objectDidDragged:)];
    //限定操作的触点数
    [panGR setMaximumNumberOfTouches:1];
    [panGR setMinimumNumberOfTouches:1];
    //将手势添加到draggableObj里
    [draggableObj addGestureRecognizer:panGR];
    [draggableObj setTag:100];
    [self addSubview:draggableObj];
}

- (void)objectDidDragged:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged ||
        sender.state == UIGestureRecognizerStateEnded) {
        //注意，这里取得的参照坐标系是该对象的上层View的坐标。
        CGPoint offset = [sender translationInView:self];
        UIView *draggableObj = [self viewWithTag:100];
        //通过计算偏移量来设定draggableObj的新坐标
        [draggableObj setCenter:CGPointMake(draggableObj.center.x + offset.x, draggableObj.center.y + offset.y)];
        //初始化sender中的坐标位置。如果不初始化，移动坐标会一直积累起来。
        [sender setTranslation:CGPointMake(0, 0) inView:self];
    }
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
        CGFloat value = [self.dataArray[idx] floatValue];
        CGFloat xPostion = this.lineSpace*idx + this.leftMargin;
        CGFloat yPostion = (this.maxY - value)*this.scaleY + this.topMargin;
        ZYWLineModel *lineModel = [ZYWLineModel initPositon:xPostion yPosition:yPostion color:this.lineColor];
        [this.modelPostionArray addObject:lineModel];
    }];
}

- (void)initConfig
{
    self.lineSpace = (self.frame.size.width - self.leftMargin - self.rightMargin)/(_dataArray.count-1) ;
    NSNumber *min  = [_dataArray valueForKeyPath:@"@min.floatValue"];
    NSNumber *max = [_dataArray valueForKeyPath:@"@max.floatValue"];
    self.maxY = [max floatValue];
    self.minY  = [min floatValue];
    self.scaleY = (self.height - self.topMargin - self.bottomMargin)/(self.maxY-self.minY);
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

@end
