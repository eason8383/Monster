//
//  Common.h
//  BYY
//
//  Created by 李建强 on 16/9/20.
//  Copyright © 2016年 qiangqiangqiang. All rights reserved.
//

#ifndef Common_h
#define Common_h


//登录
#define EGUSER @"egUser"
#define ERQUERY @"egQuery"

#define MR_SMSVERIFYCODE @"sendSmsVerifyCode"
#define MR_SMSLOGIN @"smsLogin"

#define MR_QUERYCOINPAIR @"queryCoinPair"
#define MR_QUERYKLINELASTBAR @"queryKlineLastBar"

#define MR_QUERYKLINELIST @"queryKlineList"

#define MR_QUERYEXTERNALMARKET @"queryExternalMarket"

#define MR_QUERYORDERDEPTH @"queryOrderDepth"
#define MR_QUERYUSERCOINQUANTITY @"queryUserCoinQuantity"

//保存account路径

//#define FilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"userAccount.archiver"]

#define isiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//默认货币汇率
#define DEFAULTCURRENCY @"defaultCurrency"

#define CNY @"priceCNY"
#define USD @"priceUSD"


#define FilePath @"userAccount.archiver"

//忘记密码
#define ForgotPassword @"ForgotPassword"

//消息
#define Messages @"Messages"


#define MRCOLORHEX_HIGH @"15C19F"

#define MRCOLORHEX_LOW @"FE0062"

#endif /* Common_h */
