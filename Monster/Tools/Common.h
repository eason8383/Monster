//
//  Common.h
//  BYY
//
//  Created by 李建强 on 16/9/20.
//  Copyright © 2016年 qiangqiangqiang. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define CN @"zh-Hans"
#define EN @"en"

#define ISNOWHIDEMYASSET @"hideMyAsset"
#define SHOWWELCOMEVIEW @"showWelcomeView"
//登录
#define EGUSER @"egUser"
#define ERQUERY @"egQuery"
#define ERORDER @"egOrder"

#define EGQUERYFORPAGE @"egQueryForPage"

#define MR_HOMEPAGEINFO @"queryHomePage"

#define MR_SMSVERIFYCODE @"sendSmsVerifyCode"
#define MR_SMSLOGIN @"smsLogin"
#define MR_PSWLOGIN @"passwordLogin"

#define MR_QUERYCOINPAIR @"queryCoinPair"
#define MR_QUERYKLINELASTBAR @"queryKlineLastBar"

#define MR_QUERYKLINELIST @"queryKlineList"

#define MR_QUERYEXTERNALMARKET @"queryExternalMarket"

#define MR_QUERYORDERDEPTH @"queryOrderDepth"
#define MR_QUERYUSERCOINQUANTITY @"queryUserCoinQuantity"
#define MR_QUERYUSERCOININOUTINFO @"queryUserCoinInOutInfo"

#define MR_ORDERREQUEST @"orderRequest"
#define MR_ORDERCANCEL @"orderCancelRequest"

#define MR_QUERYUSERORDER @"queryUserOrder"

#define MR_QUERYUSERORDERDEAL @"queryUserOrderDeal"
#define MR_QUERYUSERINFO @"queryUserInfo"


#define GOOGLEAUTHGEN @"googleAuthGen"
#define GOOGLESMSVERIFY @"sendSmsVerifyCodeByUserId"
#define GOOGLEAUTHCHECK @"googleAuthCheck"
#define GOOGLEAUTHBIND @"googleAuthBind"

#define MR_UPLOADPIC @"uploadPicture"

#define MR_RESETUSERPASSWORD @"resetUserPassword"
#define MR_TESTSMSVERIFYCODE @"testSmsVerifyCode"

#define MR_SAVEIDIDENTITY @"saveUserIdentity"

#define MR_QUERYUSERCOINWALLET @"queryUserCoinWallet"
#define MR_MONITORCOINRECHARGE @"monitorCoinRecharge"
#define MR_WITHDREWAPPLY @"withdrawApply"

#define DOLOGOUT @"logout"

#define CHANGELANGUAGE_RESET @"changeLanguage_reset"

#define LOGINVERIFYWITHGOOGLEAUTH @"loginWithGoogleAuth"
#define PASSTHEAUTH @"passTheAuth"

#define CHARGENOWCOIN @"chargeNowCoin"
#define CHARGENOWCOIN_WITHDREW @"chargeNowCoin_withdrew"
#define FILLWALLETADDRESS @"fillWalletAddress"

#define MR_SUBMITUSERFEEDBACK @"submitUserFeedback"

//保存account路径

#define FilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"userAccount.archiver"]

#define FilePathOS12 @"userAccountArchiver"

#define isiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define COINPAIRTABLE @"CoinPairTable"

//默认货币汇率
#define DEFAULTCURRENCY @"defaultCurrency"

#define CNY @"priceCNY"
#define USD @"priceUSD"

#define RELOAD_AFTERSETTING @"reload_afterSetting"

//#define FilePath @"userAccount.archiver"

#define COINPAIRMODEL @"coinPairModel.archiver"
#define MYETH @"MyAsset_myETH"

#define GOOGLE_AUTH_BINDING @"googleAuthIsBinding"
#define EMAIL_BINDING @"userEmailBinding"
#define TRADEPASSWORD  @"hasTradePassword"


//忘记密码
#define ForgotPassword @"ForgotPassword"

//消息
#define Messages @"Messages"


#define MRCOLORHEX_HIGH @"15C19F"

#define MRCOLORHEX_LOW @"FE0062"

#endif /* Common_h */
