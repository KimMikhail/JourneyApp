//
//  QYWaterView.m
//  CoreAnimation
//
//  Created by liuming on 2017/5/3.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYWaterView.h"

@interface QYWaterView ()

@property(nonatomic,strong) CAShapeLayer * animationLayer;
@end

@implementation QYWaterView

+(Class)layerClass{
    
    return [CAReplicatorLayer class];
}

- (CGFloat)animationTime{

    if (_animationTime <= 0) {
        _animationTime = 3.0f;
    }
    return _animationTime;
}
- (void)setAnimationTime:(CGFloat)animationTime{

    if (_animationTime != animationTime && animationTime > 0) {
        _animationTime = animationTime;
        _instanceDelay =self.instanceCount > 0? _animationTime/self.instanceCount:0;
        if (_isAnimation) {
            
            [self stopAinimation];
            [self startAnimation];
        }
    }
}


- (void)setInstanceCount:(CGFloat)instanceCount{
    _instanceCount = instanceCount;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (void)setInstanceDelay:(CGFloat)instanceDelay{

    _instanceDelay = instanceDelay;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (CAShapeLayer *) animationLayer{

    if (_animationLayer == nil) {
        
        _animationLayer = [[CAShapeLayer alloc]init];
        _animationLayer.fillColor = [UIColor orangeColor].CGColor;
    }
    
    return _animationLayer;
}
- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubLayers];
    }
    return self;
}

- (void) initSubLayers
{
    double r = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))/2.0;
    self.animationLayer.frame = CGRectMake(CGRectGetWidth(self.frame)/2.0 - r, CGRectGetHeight(self.frame)/2.0f - r, 2 *r, 2*r);
    UIBezierPath * path = [self drawCircle:r center:self.animationLayer.position];
    self.animationLayer.path = path.CGPath;
    self.animationLayer.transform = CATransform3DMakeScale(0, 0, 1);
    [self.layer addSublayer:self.animationLayer];
}

- (void)startAnimation{

    if (_isAnimation) {
        
        return;
    }
    CAAnimationGroup * group =  [[CAAnimationGroup alloc] init];
    group.duration = self.animationTime;
    group.repeatCount = MAXFLOAT;
    
    CABasicAnimation * basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    basicAnimation.toValue = @(1);
    basicAnimation.duration = self.animationTime;
    basicAnimation.repeatCount = MAXFLOAT;
    
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = self.animationTime;
    opacityAnimation.values = @[@(0.3), @0.45,@0.6 ,@0];
    opacityAnimation.keyTimes = @[@0, @0.2,@0.7, @1];
    
    NSArray * animationArray = @[basicAnimation,opacityAnimation];
    group.animations = animationArray;
     [self.animationLayer addAnimation:group forKey:@"pulse"];
    _isAnimation = YES;
}

- (void)stopAinimation{

    if (_isAnimation == NO) {
        
        return;
    }
    _isAnimation = NO;
    [self.animationLayer removeAnimationForKey:@"pulse"];
    
}

- (void)configReplicatorLayer
{
    CAReplicatorLayer * rlayer = (CAReplicatorLayer *)self.layer;
    rlayer.instanceDelay = self.instanceCount >0? self.animationTime/self.instanceCount:0;
    rlayer.instanceCount = self.instanceCount;
}
- (UIBezierPath *) drawCircle:(CGFloat) r center:(CGPoint)center{

    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:center radius:r startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    return path;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    [self configReplicatorLayer];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
