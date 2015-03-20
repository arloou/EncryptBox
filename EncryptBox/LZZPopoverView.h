//
//  LZZPopoverView.h
//  EncryptBox
//
//  Created by ucs on 15/3/9.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LZZPopoverPosition) {
    LZZPopoverPositionUp = 1,
    LZZPopoverPositionDown,
};

typedef NS_ENUM(NSUInteger, LZZPopoverMaskType) {
    LZZPopoverMaskTypeBlack,
    LZZPopoverMaskTypeNone,
};


@interface LZZPopoverView : UIView

+ (instancetype)popover;

/**
 *  POPover显示的位置
 */
@property (nonatomic, assign, readonly) LZZPopoverPosition popoverPosition;

/**
 *  箭头的大小，默认是{10.0,10.0}
 */
@property (nonatomic, assign) CGSize arrowSize;

/**
 *  圆角, 默认7.0;
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 *  显示时间，默认0.4
 */
@property (nonatomic, assign) CGFloat animationIn;

/**
 *  消失时间，默认0.3
 */
@property (nonatomic, assign) CGFloat animationOut;

/**
 *  动画是否为spring animation, 默认是YES;
 */
@property (nonatomic, assign) BOOL animationSpring;

/**
 *  背景样式，默认是LZZPopoverMaskTypeBlack;
 */
@property (nonatomic, assign) LZZPopoverMaskType maskType;

/**
 *  如果有阴影，默认是YES，如果想要自定义阴影，自行设置popover.layer.shadowColor, shadowOffset, shadowOpacity, shadowRadius
 */
@property (nonatomic, assign) BOOL applyShadow;

/**
 *  when you using atView show API, this value will be used as the distance between popovers'arrow and atView. Note: this value is invalid when popover show using the atPoint API
 */
@property (nonatomic, assign) CGFloat betweenAtViewAndArrowHeight;


/**
 * Decide the nearest edge between the containerView's border and popover, default is 4.0
 */
@property (nonatomic, assign) CGFloat sideEdge;

/**
 *  The callback when popover did show in the containerView
 */
@property (nonatomic, copy) dispatch_block_t didShowHandler;

/**
 *  The callback when popover did dismiss in the containerView;
 */
@property (nonatomic, copy) dispatch_block_t didDismissHandler;

/**
 *  Show API
 *
 *  @param point         the point in the container coordinator system.
 *  @param position      stay up or stay down from the showAtPoint
 *  @param contentView   the contentView to show
 *  @param containerView the containerView to contain
 */
- (void)showAtPoint:(CGPoint)point popoverPostion:(LZZPopoverPosition)position withContentView:(UIView *)contentView inView:(UIView *)containerView;

/**
 *  Lazy show API        The show point will be caluclated for you, try it!
 *
 *  @param atView        The view to show at
 *  @param position      stay up or stay down from the atView, if up or down size is not enough for contentView, then it will be set correctly auto.
 *  @param contentView   the contentView to show
 *  @param containerView the containerView to contain
 */
- (void)showAtView:(UIView *)atView popoverPostion:(LZZPopoverPosition)position withContentView:(UIView *)contentView inView:(UIView *)containerView;

/**
 *  Lazy show API        The show point and show position will be caluclated for you, try it!
 *
 *  @param atView        The view to show at
 *  @param contentView   the contentView to show
 *  @param containerView the containerView to contain
 */
- (void)showAtView:(UIView *)atView withContentView:(UIView *)contentView inView:(UIView *)containerView;

/**
 *  Lazy show API        The show point and show position will be caluclated for you, using application's keyWindow as containerView, try it!
 *
 *  @param atView        The view to show at
 *  @param contentView   the contentView to show
 */
- (void)showAtView:(UIView *)atView withContentView:(UIView *)contentView;

- (void)dismiss;


@end