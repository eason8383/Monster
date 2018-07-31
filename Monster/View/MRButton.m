//
//  MRButton.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/27.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MRButton.h"

@implementation MRButton

- (CGRect)imageRectForContentRect:(CGRect)bounds{
//    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    return CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    
}

@end
