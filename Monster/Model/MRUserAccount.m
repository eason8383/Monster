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
        self.sessionId = [aDecoder decodeObjectForKey:@"sessionId"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.mobileNo = [aDecoder decodeObjectForKey:@"mobileNo"];
        self.fwcJoinFlag = [aDecoder decodeBoolForKey:@"fwcJoinFlag"];

        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_inviteCode forKey:@"inviteCode"];
    [aCoder encodeObject:_sessionId forKey:@"sessionId"];
    [aCoder encodeObject:_userId forKey:@"userId"];
    [aCoder encodeObject:_mobileNo forKey:@"mobileNo"];
    [aCoder encodeBool:_fwcJoinFlag forKey:@"fwcJoinFlag"];
    
}
@end
