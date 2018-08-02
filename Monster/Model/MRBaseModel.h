//
//  MRBaseModel.h
//  Monster
//
//  Created by eason's macbook on 2018/7/3.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MRBaseModel : NSObject

@property (nonatomic, copy) NSDictionary *respCode;
@property (nonatomic, strong)NSString *respMessage;
@property (nonatomic, assign)BOOL success;

@end

