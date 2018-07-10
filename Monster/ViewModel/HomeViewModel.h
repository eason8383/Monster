//
//  HomeViewModel.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/10.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HomeViewModel : NSObject

+ (instancetype)sharedInstance;

- (void)getData;
- (NSInteger)numberOfRowsInSection;

- (NSArray*)getDrawKLineInfoArray:(NSString*)coinPairId;

@end
