//
//  UIViewController+Alert.h
//  VMM
//
//  Created by CHEN HAO LI on 2017/9/14.
//  Copyright © 2017年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)

- (void)showAlert:(NSString*)title withMsg:(NSString*)msg withActions:(NSArray*)actionArray;
- (void)showActionSheet:(NSString*)title message:(NSString*)msg withActions:(NSArray*)actionArray;

- (void)justShowAlert:(NSString*)title message:(NSString*)message;
- (void)justShowAlert:(NSString*)title message:(NSString*)message handler:(void (^ __nullable)(UIAlertAction *action))handler;

@end
