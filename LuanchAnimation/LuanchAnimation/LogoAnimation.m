//
//  LogoAnimation.m
//  LuanchAnimation
//
//  Created by Daisy on 2017/7/29.
//  Copyright © 2017年 zf. All rights reserved.
//

#import "LogoAnimation.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)


static const CGFloat KtopSpace = 300.0;//动画整体位置中心
static const CGFloat Kradius = 80.0;//圆半径
static const NSTimeInterval urlTimer = 0.5;//URL动画时间
static const CGFloat whiteOvalMaxH = 20;//白色椭圆刚显示的时候的最大高度
static const CGFloat fontToRoundH = 20;//下行文字距离圆的高度
static const NSTimeInterval fontTime = 0.2;//文字出现间隔时间
static const CGFloat fontSpace = 5;//文字间距
static const CGFloat fontDownH = 2;//文字下落高度
static const CGFloat fontAnimationDuration = 0.5;//文字下落动画持续时间
static const CGFloat whiteAnimationDuration = 1;//白色圆动画时间
static const CGFloat originAnimationDuration = 0.4;//白色圆后面的浅色圆

@class WhiteLayer;
@interface LogoAnimation()<CAAnimationDelegate>
{
    WhiteLayer *whiteLayer;
    UIImageView *logoImageView;
    UIImageView *urlImageView;
    UIView *originDarkView;
    NSMutableArray *fontArray;
    
}
@end

@interface WhiteLayer : CALayer
@property(nonatomic,assign)CGFloat raduis;
@end


@implementation LogoAnimation

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        originDarkView = [[UIView alloc] init];
        originDarkView.backgroundColor = RGB(243, 134, 36);
        originDarkView.bounds = CGRectMake(0, 0, 1, 1);
        originDarkView.layer.cornerRadius = 0.5;
        originDarkView.center = CGPointMake(frame.size.width/2, KtopSpace);
        [self addSubview:originDarkView];
        
        UIImage *logoImage = [UIImage imageNamed:@"font.png"];
        logoImageView = [[UIImageView alloc] initWithImage:logoImage];
        logoImageView.center = originDarkView.center;
        logoImageView.bounds = CGRectMake(0, 0, logoImage.size.width/3, logoImage.size.height/3);
        logoImageView.alpha = 0.0;
        [self addSubview:logoImageView];
        
        UIImage *urlImage = [UIImage imageNamed:@"font2.png"];
        urlImageView = [[UIImageView alloc] initWithImage:urlImage];
        urlImageView.center = CGPointMake(logoImageView.center.x + 20, logoImageView.center.y+25);
        urlImageView.bounds = CGRectMake(0, 0, urlImage.size.width/3, urlImage.size.height/3);
        urlImageView.alpha = 0.0;
        [self addSubview:urlImageView];
        
        //white layer
        whiteLayer = [WhiteLayer layer];
        whiteLayer.position = originDarkView.center;
        whiteLayer.bounds = CGRectMake(0, 0, Kradius*2, Kradius*2);
        [self.layer addSublayer:whiteLayer];
        
        [self bringSubviewToFront:logoImageView];
        [self bringSubviewToFront:urlImageView];
        
        NSArray *fontIcon = @[@"kai.png",@"xin.png",@"yun.png",@"gou.png",
                              @"jing.png",@"xi.png",@"xi.png",@"xian.png"];
        [self fontImageView:fontIcon];
        
        
    }
    return self;
}

-(void)fontImageView:(NSArray *)fontIconArray{
    fontArray = @[].mutableCopy;
    CGSize fontSize = CGSizeMake(15, 15);
    CGFloat rondMaxY = KtopSpace + Kradius + fontToRoundH - fontDownH;//文字隐藏时候 也就是下落前的 y
    NSInteger index = 0;
    for (NSString *fonIconString in fontIconArray) {
        UIImageView *fontImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fonIconString]];
        fontImage.alpha = 0.0;
        fontImage.tag = 100+index;
        if (index < fontIconArray.count/2) {
            CGFloat off =  (fontIconArray.count/2 - index)*(fontSize.width + fontSpace);
            fontImage.frame = CGRectMake(self.frame.size.width/2 - off, rondMaxY, fontSize.width, fontSize.height);
        }else{
            CGFloat off =  (index - fontIconArray.count/2)*(fontSize.width + fontSpace) + fontSpace;
            fontImage.frame = CGRectMake(self.frame.size.width/2 + off, rondMaxY, fontSize.width, fontSize.height);
        }
        [self addSubview:fontImage];
        [fontArray addObject:fontImage];
        index ++;
    }
}

-(void)startAnimationGroupWithLayer:(UIImageView *)imageview beginTime:(NSTimeInterval)beginTime{
    
    CALayer *layer = imageview.layer;
    CGPoint position = layer.position;
    CGPoint big = CGPointMake(position.x, position.y + fontDownH + 5);
    CGPoint small = CGPointMake(position.x, position.y + fontDownH - 5);
    CGPoint finish = CGPointMake(position.x, position.y + fontDownH);
    CAKeyframeAnimation *originy = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    originy.values = @[[NSValue valueWithCGPoint:big],[NSValue valueWithCGPoint:small],[NSValue valueWithCGPoint:finish]];
    originy.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    originy.beginTime = CACurrentMediaTime()+beginTime;
    originy.removedOnCompletion = NO;
    originy.fillMode = kCAFillModeForwards;
    originy.duration = fontAnimationDuration;
    originy.delegate = self;
    [layer addAnimation:originy forKey:[NSString stringWithFormat:@"%ld",(long)imageview.tag]];
}


-(CABasicAnimation *)logoOpacity{
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.duration = 2;
    return opacity;
}

+(instancetype)addWithSuperView:(UIView *)superView{
    LogoAnimation *view = [[LogoAnimation alloc] initWithFrame:superView.frame];
    view.backgroundColor = [UIColor clearColor];
    [superView addSubview:view];
    return view;
}

-(void)showUrlView:(NSTimeInterval)beginTime{
    CGPoint point = urlImageView.center;
    point.x -= 10;
    [UIView animateWithDuration:urlTimer
                          delay:beginTime
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         urlImageView.center = point;
                         urlImageView.alpha = 1.0;

                     } completion:nil];
    
}

-(CAKeyframeAnimation *)spreadAnimation:(NSTimeInterval)beginTime{
    CAKeyframeAnimation *spread = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    spread.duration = originAnimationDuration;
    spread.beginTime = CACurrentMediaTime()+beginTime;
    spread.removedOnCompletion = NO;
    spread.fillMode = kCAFillModeForwards;
    spread.calculationMode = kCAAnimationLinear;
    spread.values = @[@(Kradius*2+10),@(Kradius*2)];
    spread.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return spread;
}

-(NSMutableArray *)getKeyAnimationValus{
    NSMutableArray *valus = @[].mutableCopy;
    for (int i = 0; i < Kradius*2 - whiteOvalMaxH/2; i ++) {
        [valus addObject:@(i)];
    }
    return valus;
}

-(CAKeyframeAnimation *)whiteAnimation:(NSTimeInterval)beginTime{

    CAKeyframeAnimation *centerWhite = [CAKeyframeAnimation animationWithKeyPath:@"raduis"];
    centerWhite.duration = whiteAnimationDuration;
    centerWhite.beginTime = CACurrentMediaTime()+beginTime;
    centerWhite.removedOnCompletion = NO;
    centerWhite.fillMode = kCAFillModeForwards;
    centerWhite.values = [self getKeyAnimationValus];
    centerWhite.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return centerWhite;
}

-(void)start{
    
    //动画开始执行
    //setp1:后面重橘色圆变大 结束时间:1+1.5 = 2.5 later
    [originDarkView.layer addAnimation:[self spreadAnimation:0] forKey:@"transform.scale"];
    //setp2: show logo
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         logoImageView.alpha = 1.0;
                     } completion:nil];
    //setp3:show white round
    [whiteLayer addAnimation:[self whiteAnimation:0.2] forKey:@"whiteAnimation"];
    //setp4:sow url
    [self showUrlView:0.7];
    
    NSInteger i = 0;
    for (UIImageView *fontImageView in fontArray) {
            [self startAnimationGroupWithLayer:fontImageView beginTime:fontTime*i+1.0];
        i ++;
    }
    
}

#pragma mark -CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    for (UIImageView *imageView in fontArray) {
        CAAnimation *tagAn = [imageView.layer animationForKey:[NSString stringWithFormat:@"%ld",(long)imageView.tag]];
        if (tagAn == anim) {
            imageView.alpha = 1.0;
        }
    }
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
}
@end

// White layer
@implementation WhiteLayer

+(BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqualToString:@"raduis"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

-(void)drawInContext:(CGContextRef)ctx{

    CGSize layerSize = self.bounds.size;
    CGPoint layerCenter = CGPointMake(layerSize.width/2, layerSize.height/2);
    CGFloat scale = whiteOvalMaxH/2/Kradius;
    
    UIBezierPath *ovalPath = nil;
    if (self.raduis <= Kradius) {
        CGFloat changeH = self.raduis*scale;
        CGPoint origin = CGPointMake(layerCenter.x - MIN(Kradius, self.raduis), layerCenter.y - changeH);
        ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(origin.x, origin.y, self.raduis*2, changeH*2)];
    }else{
        CGFloat h = self.raduis - Kradius;
        CGPoint origin = CGPointMake(layerCenter.x - Kradius, layerCenter.y - MIN(Kradius, h) - whiteOvalMaxH/2);
        ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(origin.x, origin.y, Kradius*2, h*2 + whiteOvalMaxH)];
    }
    
    [ovalPath closePath];
    
    
    /*
    CGPoint pointA;
    CGPoint pointB;
    CGPoint pointC;
    CGPoint pointD;
    if (self.raduis <= Kradius) {
        NSLog(@"---拉长过程:%f",self.raduis);

        //拉长过程
        CGFloat changeH = self.raduis*scale;
        pointA = CGPointMake(layerCenter.x ,layerCenter.y - changeH);
        pointB = CGPointMake(layerCenter.x + self.raduis,layerCenter.y);
        pointC = CGPointMake(layerCenter.x ,layerCenter.y + changeH);
        pointD = CGPointMake(layerCenter.x - self.raduis, layerCenter.y);
        

    }else{
        NSLog(@"---变圆过程:%f",self.raduis);

        //变圆过程
        CGFloat h = self.raduis - Kradius;
        pointA = CGPointMake(layerCenter.x ,layerCenter.y - h - whiteOvalMaxH/2);
        pointB = CGPointMake(layerCenter.x + Kradius,layerCenter.y);
        pointC = CGPointMake(layerCenter.x ,layerCenter.y + h + whiteOvalMaxH/2);
        pointD = CGPointMake(layerCenter.x - Kradius, layerCenter.y);

    }
    
    CGFloat offset = self.raduis/3.6;
    
    CGPoint c1 = CGPointMake(pointA.x + offset, pointA.y);
    CGPoint c2 = CGPointMake(pointB.x, pointB.y - offset);
    
    CGPoint c3 = CGPointMake(pointB.x, pointB.y + offset);
    CGPoint c4 = CGPointMake(pointC.x + offset, pointC.y);
    
    CGPoint c5 = CGPointMake(pointC.x - offset, pointC.y);
    CGPoint c6 = CGPointMake(pointD.x, pointD.y + offset);
    
    CGPoint c7 = CGPointMake(pointD.x, pointD.y - offset);
    CGPoint c8 = CGPointMake(pointA.x - offset, pointA.y);
    
    [ovalPath moveToPoint: pointA];
    [ovalPath addCurveToPoint:pointB controlPoint1:c1 controlPoint2:c2];
    [ovalPath addCurveToPoint:pointC controlPoint1:c3 controlPoint2:c4];
    [ovalPath addCurveToPoint:pointD controlPoint1:c5 controlPoint2:c6];
    [ovalPath addCurveToPoint:pointA controlPoint1:c7 controlPoint2:c8];
    
    [ovalPath closePath];
*/
    
    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillPath(ctx);

}

@end

