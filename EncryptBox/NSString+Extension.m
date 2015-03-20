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


-(BOOL)isEmpty {
    
    if (!self) {
        return YES;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

-(NSString * )formatToSecuDisplayUserName
{
    if (self.length<4) {
        
        return [self stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"**"];
    }else if(self.length>=4){
        return [self stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@"***"];
    }else{
        return self;
    }
}



@end
