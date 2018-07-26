//
//  UpLoadImagView.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "UpLoadImagView.h"

@interface UpLoadImagView()


@property(nonatomic,strong)IBOutlet UILabel *uploadLabel;
@property(nonatomic,strong)IBOutlet UILabel *explainLabel;
@property(nonatomic,strong)IBOutlet UIView *backView;


@end

@implementation UpLoadImagView

- (void)awakeFromNib {
    [super awakeFromNib];
    _backView.layer.cornerRadius = 4;
}

- (void)setIdentityType:(IdentityType)idType{
    switch (idType) {
        case UpLoadID_Front:
            [_explainLabel setText:@"请上传您的身份证人面像"];
            break;
            
        case UpLoadID_Back:
            [_explainLabel setText:@"请上传您的身份证国徽面"];
            break;
        case UpLoadID_Hold:
            [_explainLabel setText:@"请上传您的手持身份证"];
            break;
        default:
            [_explainLabel setText:@"请上传您的身份证人面像"];
            break;
    }
}


@end
