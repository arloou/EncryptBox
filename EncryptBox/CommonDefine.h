//
//  CommonDefine.h
//  allFonts
//
//  Created by ucs on 15/1/20.
//  Copyright (c) 2015年 ucs. All rights reserved.
//

#ifndef allFonts_CommonDefine_h
#define allFonts_CommonDefine_h


#define MainWidth [UIScreen mainScreen].bounds.size.width
#define Mainheight [UIScreen mainScreen].bounds.size.height

#define MainBGColor [UIColor colorWithRed:0.12 green:0.13 blue:0.14 alpha:1]

#define DES_KEY @"12121212"


#define iPhone4 [UIScreen mainScreen].bounds.size.height==480?YES:NO
#define iPhone5 [UIScreen mainScreen].bounds.size.height==568?YES:NO
#define iPhone6 [UIScreen mainScreen].bounds.size.height==667?YES:NO
#define iPhone6_plus [UIScreen mainScreen].bounds.size.height==736?YES:NO

#define AESKEY @"luzizheng"

#define DOCUMENTPATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define INTRODUCEFILENAME @"introduce.txt"

#endif
