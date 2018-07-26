//
//  MRUserAccount.m
//  Monster
//
//  Created by eason's macbook on 2018/7/2.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MRUserAccount.h"

@implementation MRUserAccount

+(instancetype)accountWithDict:(NSDictionary *)dict{
    
    MRUserAccount *model = [[MRUserAccount alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.inviteCode = [aDecoder decodeObjectForKey:@"inviteCode"];
        self.userEmail = [aDecoder decodeObjectForKey:@"userEmail"];
        self.sessionId = [aDecoder decodeObjectForKey:@"sessionId"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.mobileNo = [aDecoder decodeObjectForKey:@"mobileNo"];
        
        self.frontIdCard = [aDecoder decodeObjectForKey:@"frontIdCard"];
        self.backIdCard = [aDecoder decodeObjectForKey:@"backIdCard"];
        self.userWithIdCard = [aDecoder decodeObjectForKey:@"userWithIdCard"];
        self.idCardAuditStatus = [aDecoder decodeObjectForKey:@"idCardAuditStatus"];
        
        self.fwcJoinFlag = [aDecoder decodeBoolForKey:@"fwcJoinFlag"];
        self.hasTradePassword = [aDecoder decodeBoolForKey:@"hasTradePassword"];
        self.hasGoogleAuth = [aDecoder decodeBoolForKey:@"hasGoogleAuth"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_inviteCode forKey:@"inviteCode"];
    [aCoder encodeObject:_userEmail forKey:@"userEmail"];
    [aCoder encodeObject:_sessionId forKey:@"sessionId"];
    [aCoder encodeObject:_userId forKey:@"userId"];
    [aCoder encodeObject:_mobileNo forKey:@"mobileNo"];
    
    [aCoder encodeObject:_frontIdCard?_frontIdCard:@"" forKey:@"frontIdCard"];
    [aCoder encodeObject:_backIdCard?_backIdCard:@"" forKey:@"backIdCard"];
    [aCoder encodeObject:_userWithIdCard?_userWithIdCard:@"" forKey:@"userWithIdCard"];
    [aCoder encodeObject:_idCardAuditStatus?_idCardAuditStatus:@"" forKey:@"idCardAuditStatus"];
    
    [aCoder encodeBool:_fwcJoinFlag forKey:@"fwcJoinFlag"];
    [aCoder encodeBool:_hasTradePassword forKey:@"hasTradePassword"];
    [aCoder encodeBool:_hasGoogleAuth forKey:@"hasGoogleAuth"];
    
    
}
@end
