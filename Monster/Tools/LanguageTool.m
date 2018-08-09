//
//  LanguageTool.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/8/7.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#define LANGUAGE_SET @"langeuageset"

#import "AppDelegate.h"
#import "LanguageTool.h"
//#import "HomeViewController.h"

static LanguageTool *sharedModel;

@interface LanguageTool()

@property(nonatomic,strong)NSBundle *bundle;
@property(nonatomic,copy)NSString *language;

@end

@implementation LanguageTool

+(id)sharedInstance
{
    static LanguageTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LanguageTool alloc] init];
    });
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initLanguage];
    }
    
    return self;
}

- (void)initLanguage
{
    
    NSString *tmp = [[NSUserDefaults standardUserDefaults]objectForKey:LANGUAGE_SET];
    
    if (tmp) {
        self.language = tmp;
        
    } else {
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        NSArray* languages = [defs objectForKey:@"AppleLanguages"];
        NSString* preferredLang = [languages objectAtIndex:0];
        if ([preferredLang isEqualToString:EN]) {
            self.language = preferredLang;
            [[NSUserDefaults standardUserDefaults]setObject:preferredLang forKey:LANGUAGE_SET];
            
        } else {
            [[NSUserDefaults standardUserDefaults]setObject:CN forKey:LANGUAGE_SET];
            self.language = CN;
            
        }
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    NSString *path = [[NSBundle mainBundle]pathForResource:self.language ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
    
    
}

- (NSString*)nowLanguage{
    NSString *tmp = [[NSUserDefaults standardUserDefaults]objectForKey:LANGUAGE_SET];
    self.language = tmp;
    return self.language;
}

- (NSString *)getStringForKey:(NSString *)key
{
    if (self.bundle)
    {
        return NSLocalizedStringFromTableInBundle(key, @"Localizable", self.bundle, nil);
    }
    
    return NSLocalizedStringFromTable(key, @"Localizable", @"");
}

- (void)changeNowLanguage
{
    if ([self.language isEqualToString:EN])
    {
        [self setNewLanguage:CN];
    }
    else
    {
        [self setNewLanguage:EN];
    }
}

- (void)setNewLanguage:(NSString *)language
{
    if ([language isEqualToString:self.language])
    {
        return;
    }
    
    if ([language isEqualToString:EN] || [language isEqualToString:CN])
    {
        NSString *path = [[NSBundle mainBundle]pathForResource:language ofType:@"lproj"];
        self.bundle = [NSBundle bundleWithPath:path];
    }
    
    self.language = language;
    [[NSUserDefaults standardUserDefaults]setObject:language forKey:LANGUAGE_SET];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self resetRootViewController];
}

- (void)resetRootViewController
{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initScreen) name:CHANGELANGUAGE_RESET object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:CHANGELANGUAGE_RESET object:nil];
//    UIWindow *window = [(AppDelegate*)[[UIApplication sharedApplication] delegate] window];
//
//    HomeViewController *HomeVC=[[HomeViewController alloc]init];
//    window.rootViewController = HomeVC;
//
//    [window makeKeyAndVisible];
    
}

@end
