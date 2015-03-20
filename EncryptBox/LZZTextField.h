//
//  LZZTextField.h
//  EncryptBox
//
//  Created by ucs on 15/3/5.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EncryptAnimationDelegate <NSObject>

@required
-(void)animationDidEndWithTag:(int)tag;
@end

@interface LZZTextField : UITextField

@property(nonatomic,assign)CGFloat duration;
@property(nonatomic,weak)id<EncryptAnimationDelegate>animationDelegate;

-(void)startAnimationWithPerDuration:(CGFloat)duration;

@end
