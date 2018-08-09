//
//  WelcomeView.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/8/9.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "WelcomeView.h"

@interface WelcomeView()
@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)IBOutlet UIButton *btn;

@end

@implementation WelcomeView

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImageView *imagView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Group25"]];
    imagView.contentMode = UIViewContentModeRedraw;
    
    CGRect frame = imagView.frame;
    frame.size.width = kScreenWidth;
    frame.origin.x = 0;
    frame.origin.y = isiPhoneX?-20:0;
    imagView.frame = frame;
    
    [_btn addTarget:self action:@selector(cancelSelf:) forControlEvents:UIControlEventTouchUpInside];

    [_scrollView addSubview:imagView];
    [_scrollView setContentSize:imagView.frame.size];
}

- (void)cancelSelf:(UIButton*)btn{
    
    [[NSUserDefaults standardUserDefaults]setObject:@"Showed" forKey:SHOWWELCOMEVIEW];
    
    [self removeFromSuperview];
    
}

@end
