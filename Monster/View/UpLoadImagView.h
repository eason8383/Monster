//
//  UpLoadImagView.h
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger{
    UpLoadID_Front                 = 0,
    UpLoadID_Back                  = 1,
    UpLoadID_Hold
} IdentityType;

@interface UpLoadImagView : UIView

@property(nonatomic,strong)IBOutlet UIButton *uploadBtn;
- (void)setIdentityType:(IdentityType)idType;

@end


