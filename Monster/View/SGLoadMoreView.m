//
//  DownScrollV.m
//  LianAi
//
//  Created by calvin on 14/11/7.
//  Copyright (c) 2014年 Yung. All rights reserved.
//

#import "SGLoadMoreView.h"

@implementation SGLoadMoreView

- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        _activityView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        _activityView.center = self.center;
        [self addSubview:_activityView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:frame];
        _titleLabel.center = self.center;
        [_titleLabel setTextColor:[UIColor grayColor]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setText:@"上拉更新"];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_titleLabel];
        
        _tipsLabel = [[UILabel alloc] initWithFrame:frame];
//        _tipsLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        _tipsLabel.center = self.center;
        _tipsLabel.text = @"没有更多数据";
        _tipsLabel.hidden = YES;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.textColor = [UIColor lightGrayColor];
        _tipsLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_tipsLabel];
    }
    return self;
}


- (void)startAnimation
{
    _activityView.hidden = NO;
    [_activityView startAnimating];
    _tipsLabel.hidden = YES;
    _titleLabel.hidden = YES;
}

- (void)stopAnimation
{
    if (_activityView.isAnimating == NO)
    {
        return;
    }
    _titleLabel.hidden = NO;
    _activityView.hidden = YES;
    [_activityView stopAnimating];
}

- (BOOL)isAnimating
{
    return _activityView.isAnimating;
}

- (void)noMoreData
{
    _titleLabel.hidden = YES;
    _tipsLabel.hidden = NO;
}

-(void)restartLoadData
{
    _titleLabel.hidden = NO;
   
    _tipsLabel.hidden = YES;
}

@end
