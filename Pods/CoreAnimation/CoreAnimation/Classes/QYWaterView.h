//
//  QYWaterView.h
//  CoreAnimation
//
//  Created by liuming on 2017/5/3.
//  Copyright © 2017年 burning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYWaterView : UIView{


    CGFloat _animationTime;
    CGFloat _instanceDelay;
    CGFloat _instanceCount;
}

@property(nonatomic,assign) CGFloat animationTime;
@property(nonatomic,assign,readonly) CGFloat instanceDelay;
@property(nonatomic,assign) CGFloat instanceCount;
@property(nonatomic,assign,readonly) BOOL isAnimation;

- (void)startAnimation;
- (void)stopAinimation;
@end
