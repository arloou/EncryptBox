//
//  NSString+Extension.m
//  EncryptBox
//
//  Created by ucs on 15/1/24.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)


-(BOOL)isEnterPwdFormatter
{
    
    if (self.length==4)
    {
        NSCharacterSet*charaterSet=[NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        if ([self rangeOfCharacterFromSet:[charaterSet invertedSet]].location==NSNotFound)
        {
            return YES;
        }
    }
    
    
    return NO;
    
    
    
}
@end
