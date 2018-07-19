//
//  PointOutLine.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/19.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "PointOutLine.h"
@interface PointOutLine()

@property(nonatomic,strong)IBOutlet UILabel *pointLabel;

@end

@implementation PointOutLine
@synthesize  dragEnable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}


@end
