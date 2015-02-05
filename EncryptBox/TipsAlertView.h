//
//  TipsAlertView.h
//  EncryptBox
//
//  Created by ucs on 15/1/27.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TipsAlertView : NSObject
+(void)showInTarget:(UIViewController*)target withMessage:(NSString*)message andTextColor:(UIColor*)textColor;
@end
