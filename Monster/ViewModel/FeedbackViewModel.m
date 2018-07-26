//
//  FeedbackViewModel.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/26.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "FeedbackViewModel.h"
#import "MRUserInfoClient.h"

@implementation FeedbackViewModel

+ (instancetype)sharedInstance{
    
    static FeedbackViewModel *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FeedbackViewModel alloc]init];
        
    });
    
    return instance;
}

- (void)commitFeedback:(NSString*)content picPath:(NSString*)pic{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MRUserInfoClient alloc]userFeedback:content uploadPic:pic Success:^(id response){
            NSDictionary *dic = response;
            if ([[dic objectForKey:@"success"] integerValue] == 1) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate feedBackSuccess:dic];
                });
                
            } else {
                NSError *error = [NSError errorWithDomain:@"commitFeedback" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate feedbackFalid:error];
                    
                });
            }
            
            NSLog(@"response:%@",response);
            
        } failure:^(NSError *error) {
            //失敗
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate feedbackFalid:error];
            });
        }];
    });
}

- (void)uploadImageByPath:(NSURL*)path{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MRWebClient alloc]upLoadImagePath:path success:^(id response){
            NSDictionary *dic = response;
            if ([[dic objectForKey:@"success"] integerValue] == 1) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate uploadSuccess:dic];
                });
                
            } else {
                NSError *error = [NSError errorWithDomain:@"uploadImageByPath" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate feedbackFalid:error];
                    
                });
            }
            
            NSLog(@"response:%@",response);
            
        } failure:^(NSError *error) {
            //失敗
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate feedbackFalid:error];
            });
        }];
    });
}

@end
