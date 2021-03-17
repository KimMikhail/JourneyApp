//
//  QYMusicPlayAnimation.m
//  CoreAnimation
//
//  Created by liuming on 2017/5/3.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYMusicPlayAnimation.h"


const static double layerWidth = 15.0f;

@interface QYMusicPlayAnimation ()

@property(nonatomic,strong) CALayer * animationLayer;

@end

@implementation QYMusicPlayAnimation

+(Class) layerClass{

    return [CAReplicatorLayer class];
}

- (CALayer *)animationLayer
{

    if (_animationLayer == nil) {
        
        _animationLayer = [[CALayer alloc] init];
    }
    
    return _animationLayer;
}

- (void)setLayerMargin:(CGFloat)layerMargin
{
    if (layerMargin > 5 && _layerMargin != layerMargin) {
        
        _layerMargin = layerMargin;
        NSInteger count = CGRectGetWidth(self.frame) /(2 * _layerMargin + layerWidth);
        CAReplicatorLayer * replicatorLayer = (CAReplicatorLayer *)self.layer;
        replicatorLayer.instanceCount = count;
    }

}

- (CGFloat) layerMargin{
    
    if (_layerMargin <= 0) {
        
        _layerMargin = 5;
    }
    return _layerMargin;
}

- (void)setDuration:(CGFloat)duration
{
    _duration = MAX(0, duration);
    if (self.isAnimation) {
        
        [self stopAnimation];
        [self startAnimation];
    }
}

- (CGFloat)duration{

    if (_duration < 0.25) {
        
        _duration = 0.25;
    }
    
    return _duration;
}

- (void)setInstanceDelay:(CGFloat)instanceDelay{

    _instanceDelay = instanceDelay;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGFloat) instanceDelay{

    if (_instanceDelay <= 0) {
        
        _instanceDelay = 0.15;
    }
    return _instanceDelay;
}
- (void)setLayerColor:(UIColor *)layerColor{

    if (layerColor)
    {
        _layerColor = layerColor;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (UIColor *)layerColor{

    if (_layerColor == nil) {
     
        _layerColor  = [UIColor greenColor];
        
    }
    return _layerColor;
}

- (instancetype) initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if(self){
        
        [self initSubLayers];
    
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initSubLayers];
}

- (void)configReplicatorLayer
{
    NSInteger count = CGRectGetWidth(self.frame) /(2 * self.layerMargin + layerWidth) ;
    CAReplicatorLayer * replicatorLayer = (CAReplicatorLayer *)self.layer;
    replicatorLayer.instanceCount = count;
    replicatorLayer.instanceColor = self.layerColor.CGColor;
    
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(self.layerMargin * 2 + layerWidth, 0, 0);
    
    replicatorLayer.instanceDelay = self.instanceDelay;
    replicatorLayer.instanceGreenOffset =  0.1;
}
- (void) initSubLayers
{
    self.animationLayer.frame = CGRectMake(self.layerMargin, 0, layerWidth, CGRectGetHeight(self.frame));
    self.animationLayer.anchorPoint = CGPointMake(0.5, 1);
    self.animationLayer.position = CGPointMake(layerWidth/2.0, CGRectGetHeight(self.frame));
    self.animationLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.layer addSublayer:self.animationLayer];
    self.animationLayer.transform = CATransform3DScale(self.animationLayer.transform, 1, 0.2, 1);
    
}

- (void)startAnimation
{
    if (_isAnimation){
        
        return ;
    }
    CABasicAnimation * basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    basicAnimation.toValue = @(1.0);
    basicAnimation.fromValue = @(0);
    basicAnimation.repeatCount = MAXFLOAT;
    basicAnimation.duration = self.duration;
    basicAnimation.autoreverses = YES;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [self.animationLayer addAnimation:basicAnimation forKey:@"scale"];
    _isAnimation = YES;
    
}

- (void)stopAnimation{
    
    if (!_isAnimation) {
        
        return;
    }
    _isAnimation = NO;
    [self.animationLayer removeAnimationForKey:@"scale"];

}

- (void)layoutSubviews
{
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
