//
//  singleCharView.h
//  EncryptBox
//
//  Created by ucs on 15/1/21.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface singleCharView : UIView

@property (weak, nonatomic) IBOutlet UILabel *label;

-(void)startAnimate;
-(void)stopAnimate;

@end
