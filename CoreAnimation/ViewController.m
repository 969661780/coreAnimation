//
//  ViewController.m
//  CoreAnimation
//
//  Created by mt y on 2017/10/31.
//  Copyright © 2017年 mt y. All rights reserved.
//

#import "ViewController.h"
#define ANGLE(x) M_PI/180*x
@interface ViewController ()<CAAnimationDelegate>

@property (nonatomic, strong)UIView *myView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.myView = [UIView new];
    self.myView.center  = self.view.center;
    self.myView.bounds = CGRectMake(0, 0, 100, 100);
    self.myView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.myView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    //起始位置
    basicAnimation.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    basicAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(375, 675)];
    //时间
    basicAnimation.duration = 5;
    basicAnimation.repeatDuration = 2;
    basicAnimation.fillMode = kCAFillModeBoth;
    //速度
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    basicAnimation.delegate  = self;
    
    basicAnimation.removedOnCompletion = YES;
    
    [self.myView.layer addAnimation:basicAnimation forKey:@"base"];
    
}
- (IBAction)myButton:(UIButton *)sender {
    static int count = 0;
    count ++;
    if (count % 2 == 1) {
        _myView.layer.speed = 0;
        _myView.layer.timeOffset = CACurrentMediaTime() - _myView.layer.beginTime;
    }else{
        _myView.layer.speed = 1;
        _myView.layer.beginTime = CACurrentMediaTime() - _myView.layer.timeOffset;
        _myView.layer.timeOffset = 0;
    }
}
- (IBAction)moveBtn:(UIButton *)sender {
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.duration = 3;
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.values = @[[NSValue valueWithCGPoint:self.myView.layer.position],[NSValue valueWithCGPoint:CGPointMake(arc4random_uniform(200), arc4random_uniform(300))],[NSValue valueWithCGPoint:CGPointMake(arc4random_uniform(200), arc4random_uniform(300))],[NSValue valueWithCGPoint:CGPointMake(arc4random_uniform(200), arc4random_uniform(300))],[NSValue valueWithCGPoint:CGPointMake(arc4random_uniform(200), arc4random_uniform(300))]];
    keyAnimation.delegate = self;
    [self.myView.layer addAnimation:keyAnimation forKey:@"keyAnimation"];
}
- (IBAction)pathBtn:(UIButton *)sender {
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.duration = 2;
    keyAnimation.repeatCount = MAXFLOAT;
    CGMutablePathRef path = CGPathCreateMutable();
    CGAffineTransform form = CGAffineTransformScale(self.myView.transform, 1.5, 1.5);
    CGPathAddRect(path, &form, self.view.bounds);
    keyAnimation.path = path;
    [self.myView.layer addAnimation:keyAnimation forKey:@"path"];
}
- (IBAction)goupBtn:(UIButton *)sender {
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue=@1.0;
    scale.toValue=@0.5;
    
    
    
    CABasicAnimation *opcityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opcityAnimation.fromValue = @1;
    opcityAnimation.toValue = @0.5;
    
    
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    CGFloat angel = M_PI_4 / 8;
    shakeAnimation.duration = .3;
    [shakeAnimation setValues:@[@(angel), @(-angel), @(angel)]];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scale,opcityAnimation,shakeAnimation];
    group.repeatCount = MAXFLOAT;
    group.duration = 1;
    [self.myView.layer addAnimation:group forKey:@"group"];
}
- (IBAction)shakeBtn:(UIButton *)sender {
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    keyAnimation.repeatCount = MAXFLOAT;
    keyAnimation.values = @[@(ANGLE(-10)),@(ANGLE(10))];
    keyAnimation.duration = 0.25;
    [self.myView.layer addAnimation:keyAnimation forKey:@"shake"];
}
#pragma mark -CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([_myView.layer animationForKey:@"base"]) {

    }else if ([_myView.layer animationForKey:@"keyAnimation"]){
        CAKeyframeAnimation  *key = (CAKeyframeAnimation *)anim;
        self.myView.layer.position = [[key.values lastObject] CGPointValue];
    }
}
@end
