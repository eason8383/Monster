//
//  UIViewController+Alert.m
//  VMM
//
//  Created by CHEN HAO LI on 2017/9/14.
//  Copyright © 2017年 Tigerrose. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

- (void)showAlert:(NSString*)title withMsg:(NSString*)msg withActions:(NSArray*)actionArray{
    
    if (actionArray && actionArray.count > 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        for (UIAlertAction *action in actionArray) {
            [alert addAction:action];
        }
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        [self justShowAlert:title message:msg];
    }
    
}

- (void)justShowAlert:(NSString*)title message:(NSString*)message{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^(){}];
}

- (void)justShowAlert:(NSString*)title message:(NSString*)message handler:(void (^ __nullable)(UIAlertAction *action))handler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:handler];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^(){}];
}

- (void)showActionSheet:(NSString*)title message:(NSString*)msg withActions:(NSArray*)actionArray{
    
    UIAlertController *alertActionSheet = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertActionSheet addAction:cancelAction];
    
    if (actionArray && actionArray.count > 0) {
        
        for (UIAlertAction *action in actionArray) {
            [alertActionSheet addAction:action];
        }
        
    }
    
    [self presentViewController:alertActionSheet animated:YES completion:nil];

}

@end
