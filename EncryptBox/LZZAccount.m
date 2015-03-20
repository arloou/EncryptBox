//
//  MyAccount.m
//  accountDemo
//
//  Created by ucs on 15/3/2.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "LZZAccount.h"

@implementation LZZAccount

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_companyName forKey:@"companyName"];
    [aCoder encodeObject:_productName forKey:@"productName"];
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_passWord forKey:@"passWord"];
    [aCoder encodeObject:_bingdingPhoneNumber forKey:@"bingdingPhoneNumber"];
    [aCoder encodeObject:_bingdingEmail forKey:@"bingdingEmail"];
    [aCoder encodeObject:_otherInfo forKey:@"otherInfo"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        _companyName=[aDecoder decodeObjectForKey:@"companyName"];
        _productName=[aDecoder decodeObjectForKey:@"productName"];
        _userName=[aDecoder decodeObjectForKey:@"userName"];
        _passWord=[aDecoder decodeObjectForKey:@"passWord"];
        _bingdingPhoneNumber=[aDecoder decodeObjectForKey:@"bingdingPhoneNumber"];
        _bingdingEmail=[aDecoder decodeObjectForKey:@"bingdingEmail"];
        _otherInfo=[aDecoder decodeObjectForKey:@"otherInfo"];
    }
    return self;
}

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        _companyName=@"";
        _productName=@"";
        _userName=@"";
        _passWord=[NSData data];
        _bingdingPhoneNumber=@"";
        _bingdingEmail=@"";
        _otherInfo=@"";
    }
    return self;
}

+(instancetype)account
{
    LZZAccount*acc=[[LZZAccount alloc] init];
    return acc;
}

-(NSString *)description
{
    NSString*str=[NSString stringWithFormat:@"\n Company Name=%@\n Product Name=%@\n User Name=%@\n Password=%@\n BingdingPhoneNumber=%@\n BingdingEmail=%@\n Other Information=%@\n ",_companyName,_productName,_userName,[[NSString alloc] initWithData:_passWord encoding:NSUTF8StringEncoding],_bingdingPhoneNumber,_bingdingEmail,_otherInfo];
    return str;
}

-(BOOL)checkIfHasText:(NSString*)searchText
{
    NSArray * allVisableInfo=@[_companyName,_productName,_userName,_bingdingPhoneNumber,_bingdingEmail,_otherInfo];
    for (NSString * info in allVisableInfo)
    {

        if ([[info lowercaseString] containsString:[searchText lowercaseString]])
        {
            return YES;
        }
    }
    return NO;
}

@end
