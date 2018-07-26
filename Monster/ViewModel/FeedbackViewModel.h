//
//  FeedbackViewMOdel.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/26.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FeedbackViewModelDelegate <NSObject>

@optional

- (void)uploadSuccess:(NSDictionary*)fInfo;
- (void)feedBackSuccess:(NSDictionary*)fInfo;
- (void)feedbackFalid:(NSError*)error;

@end
@interface FeedbackViewModel : NSObject

@property(nonatomic,weak) id<FeedbackViewModelDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)commitFeedback:(NSString*)content picPath:(NSString*)pic;

- (void)uploadImageByPath:(NSURL*)path;

@end
