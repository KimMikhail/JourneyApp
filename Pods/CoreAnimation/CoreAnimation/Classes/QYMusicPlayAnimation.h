//
//  QYMusicPlayAnimation.h
//  CoreAnimation
//
//  Created by liuming on 2017/5/3.
//  Copyright © 2017年 burning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYMusicPlayAnimation : UIView{

    CGFloat _layerMargin;
    CGFloat _duration;
    UIColor * _layerColor;
    CGFloat _instanceDelay;
}

@property(nonatomic,assign)CGFloat layerMargin;

@property(nonatomic,assign)CGFloat duration;

@property(nonatomic,assign,readonly) BOOL isAnimation;

@property(nonatomic,assign) CGFloat instanceDelay;

@property(nonatomic,strong)UIColor * layerColor;

- (void)startAnimation;
- (void)stopAnimation;
@end
