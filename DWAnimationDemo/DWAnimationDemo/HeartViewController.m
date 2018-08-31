//
//  HeartViewController.m
//  DWAnimationDemo
//
//  Created by mude on 2018/8/30.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "HeartViewController.h"

@interface HeartViewController ()<CAAnimationDelegate>{
    CAShapeLayer *_layerA;
    
    NSInteger _index;
    
    NSArray *_colorArr;
    
    NSTimer *_timer;
}

//弧度转角度
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
//角度转弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@property (nonatomic, strong) UIView *redView;

@end

@implementation HeartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"贝塞尔❤️动画";
    
    _colorArr = @[[UIColor redColor],[UIColor grayColor],[UIColor greenColor],[UIColor blueColor],[UIColor yellowColor],[UIColor orangeColor]];
    
    //在cell上添加 bgView,给bgView添加两个手势检测方法
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGesture.numberOfTapsRequired =1;
    singleTapGesture.numberOfTouchesRequired  =1;
    [self.view addGestureRecognizer:singleTapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired =2;
    doubleTapGesture.numberOfTouchesRequired =1;
    [self.view addGestureRecognizer:doubleTapGesture];
    //只有当doubleTapGesture识别失败的时候(即识别出这不是双击操作)，singleTapGesture才能开始识别
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    
    _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    //    [self drawViewWithCoordinateX:100 CoordinateY:100 Radius:100 Color:_colorArr[arc4random() % 10]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_timer invalidate];
}

- (void) timerMethod{
    NSInteger random = arc4random() % 5;
    [self drawViewWithCoordinateX:SCREEN_WIDTH/2 CoordinateY:300 Radius:50 Color:_colorArr[random]];
}

//两个手势分别响应的方法
-(void)handleSingleTap:(UIGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.view];
    //    NSInteger random = arc4random() % 5;
    //    [self drawViewWithCoordinateX:point.x CoordinateY:point.y Radius:50 Color:_colorArr[random]];
}

-(void)handleDoubleTap:(UIGestureRecognizer *)sender{
    NSLog(@"双击了1次");
    CGPoint point = [sender locationInView:self.view];
    NSInteger random = arc4random() % 5;
    [self drawViewWithCoordinateX:point.x CoordinateY:point.y Radius:50 Color:_colorArr[random]];
}


- (void)sliderValueChange:(UISlider *)slider
{
    _layerA.strokeStart = slider.value;
}

- (void)drawViewWithCoordinateX:(CGFloat)x CoordinateY:(CGFloat)y Radius:(CGFloat)r Color:(UIColor *)color{
    _index ++;
    [color set];
    //三次曲线
    UIBezierPath* bPath = [UIBezierPath bezierPath];
    bPath.lineWidth = 5.0;
    bPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    bPath.lineJoinStyle = kCGLineCapRound;  //终点处理
    
    //起始点x=r/2 y=r/4
    [bPath moveToPoint:CGPointMake(r/2, r/4)];//y=225
    //添加两个控制点
    [bPath addCurveToPoint:CGPointMake(0, r*3/8) controlPoint1:CGPointMake(r*3/8, 0) controlPoint2:CGPointMake(0, 0)];
    [bPath addCurveToPoint:CGPointMake(r/4, r*7/8) controlPoint1:CGPointMake(0, r*5/8) controlPoint2:CGPointMake(r/4, r*7/8)];
    [bPath addLineToPoint:CGPointMake(r/2, r*9/8)];
    //另半边
    [bPath addLineToPoint:CGPointMake(r*3/4, r*7/8)];
    [bPath addCurveToPoint:CGPointMake(r, r*3/8) controlPoint1:CGPointMake(r, r*5/8) controlPoint2:CGPointMake(r, r*3/8)];
    [bPath addCurveToPoint:CGPointMake(r/2, r/4) controlPoint1:CGPointMake(r, 0) controlPoint2:CGPointMake(r*5/8, 0)];
    [bPath stroke];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x-r/2, y-r/2, r, 5*r/4)];
    view.backgroundColor = [UIColor clearColor];
    view.alpha = 0.8f;
    [self.view addSubview:view];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.lineWidth = 2.f;
    layer.strokeColor = color.CGColor;
    layer.fillColor = color.CGColor;
    layer.path = bPath.CGPath;
    [view.layer addSublayer:layer];
    
    
    
    // 先缩小
    view.transform = CGAffineTransformMakeScale(1.5, 1.5);
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 1 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        // 放大
        view.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    
    
    UIBezierPath* vPath = [UIBezierPath bezierPath];
    vPath.lineWidth = 5.0;
    vPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    vPath.lineJoinStyle = kCGLineCapRound;  //终点处理
    [vPath moveToPoint:CGPointMake(x, y)];
    //添加两个控制点
    [vPath addCurveToPoint:CGPointMake(x+100, y-200) controlPoint1:CGPointMake(x+100, y) controlPoint2:CGPointMake(x+100, y-200)];
    [vPath stroke];
    
    
    view.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //贝塞尔曲线画消失路线
        CAKeyframeAnimation *keyFA = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        keyFA.path = vPath.CGPath;
        keyFA.duration = 1.5f;
        keyFA.repeatCount = 1;
        keyFA.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        keyFA.fillMode = kCAFillModeForwards;
        keyFA.calculationMode = kCAAnimationPaced;
        keyFA.removedOnCompletion = NO;
        keyFA.delegate = self;
        [view.layer addAnimation:keyFA forKey:@""];
        
        view.alpha = 0;
        view.transform = CGAffineTransformMakeScale(0.3, 0.3);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    
}

#pragma mark -动画代理方法
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"%@", anim);
    NSLog(@"%d", flag);
}

- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"%@", anim);
}

@end
