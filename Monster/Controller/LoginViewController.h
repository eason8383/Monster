//
//  LoginViewController.h
//  Monster
//
//  Created by eason's macbook on 2018/7/2.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoginHandler)(NSString *clientID);

@interface LoginViewController : UIViewController

- (void)setLoginHandler:(LoginHandler)loginHandler;

@end

