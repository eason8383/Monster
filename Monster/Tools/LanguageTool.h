//
//  LanguageTool.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/8/7.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#define LocalizeString(key) [[LanguageTool sharedInstance] getStringForKey:key]

#import <Foundation/Foundation.h>

@interface LanguageTool : NSObject

+(id)sharedInstance;

//使用key與table去取得字串
- (NSString *)getStringForKey:(NSString *)key;

- (NSString*)nowLanguage;

//改變語言
- (void)changeNowLanguage;

//設置語言
- (void)setNewLanguage:(NSString*)language;

@end
