//
//  AppDelegate.m
//  Monster
//
//  Created by eason's macbook on 2018/7/2.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomePageViewController.h"
#import "MRWebClient.h"
#import "MRUserAccount.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (NSString *)environment{
    
    return MREnvironment_TEST;
    //        return BZEnvironment_Internal;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self initScreen];
    //默认人民币汇率
    [[NSUserDefaults standardUserDefaults]setObject:CNY forKey:DEFAULTCURRENCY];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doLogout) name:DOLOGOUT object:nil];
    
    return YES;
}

- (void)doLogout{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"sessionId"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userAccount"];
    [self initScreen];
}

- (void)initScreen{
    
    NSString *sessionId = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionId"];
    id userAccountObject = [[NSUserDefaults standardUserDefaults]objectForKey:@"userAccount"];
    if (userAccountObject && [userAccountObject isKindOfClass:[NSData class]]) {
        NSData *userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"userAccount"];
        MRUserAccount *account = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        [MRWebClient sharedInstance].userAccount = account;
        
        [self readyToShowMainController];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userAccount"];
        sessionId = nil;
        
        LoginViewController *loginController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        
        [loginController setLoginHandler:^(NSString *clientId) {
            
            [self readyToShowMainController];
            
            NSLog(@"So you get message from Login Handler:%@",clientId);
        }];
        _window.rootViewController = loginController;
    }
    //jump over login
//    [self readyToShowMainController];
}

- (void)readyToShowMainController{
    
//    _tabController = [[TabBarViewController alloc]initWithNibName:@"TabBarViewController" bundle:nil];
//    UITabBar *tbAppearence = [UITabBar appearance];
//    [tbAppearence setBarStyle:UIBarStyleBlack];
//    [tbAppearence setTintColor:[UIColor whiteColor]];
//
//    BZMainViewController *bController = [[BZMainViewController alloc]initWithNibName:@"BZMainViewController" bundle:nil];
//    bController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"BI" image:[UIImage imageNamed:@"home"] tag:0];
//    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:bController];
//
//
//    OMProductListViewController *ompController = [[OMProductListViewController alloc]initWithNibName:@"OMProductListViewController" bundle:nil];
//    ompController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"商品" image:[UIImage imageNamed:@"product_50"] tag:0];
//    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:ompController];
//
//    ShoppingCartViewController *shopController = [[ShoppingCartViewController alloc]initWithNibName:@"ShoppingCartViewController" bundle:nil];
//    shopController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"购物车" image:[UIImage imageNamed:@"shopping_25"] tag:1];
//    shopController.isTabBarShow = YES;
//    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:shopController];
//
//    WeiBoMineController *weiBoMineVC = [WeiBoMineController new];
//
//    weiBoMineVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"myuser_25"] tag:1];
//    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:weiBoMineVC];
//    [_tabController setViewControllers:@[nav1,nav2,nav3,nav4]];
    
    HomePageViewController *hpVC = [[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:hpVC];
    _window.rootViewController = nav;
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
