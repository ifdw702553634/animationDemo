//
//  WaterWaveViewController.m
//  DWAnimationDemo
//
//  Created by mude on 2018/8/31.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "WaterWaveViewController.h"

@interface WaterWaveViewController (){
    //定时器
    CADisplayLink *_timer;
    //初相1:这个决定了波形水平移动的速度
    CGFloat _waterEpoch;
    //初相2:这个决定了波形水平移动的速度
    CGFloat _waterEpochWeak;
    //偏距
    CGFloat _waterSetover;
    //波形整个的宽度
    CGFloat _waterWaveWidth;
    //波形的整个高度
    CGFloat _waterWaveHeight;
    //振幅
    CGFloat _waterAmplitude;
    //频率1
    CGFloat _waterFrequency;
    //频率2
    CGFloat _waterFrequencyWeak;
}

/**layer*/
@property(strong,nonatomic)CAShapeLayer *waterShapeLayer;

@property(strong,nonatomic)CAShapeLayer *waterShapeLayerWeak;

@property(strong,nonatomic)UIView *waveView;

@end

@implementation WaterWaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"🌊动画";
    //CGRectMake(SCREEN_WIDTH/2-50, 200, 100, 100)
    [self waterWaveWithCoordinateX:SCREEN_WIDTH/2-50 CoordinateY:200 Radius:100 Color:[UIColor colorWithRed:225/255.0 green:36/255.0 blue:24/255.0 alpha:1.0]];
    
    
    UISlider *slider = [UISlider new];
    slider.frame = CGRectMake(50, SCREEN_HEIGHT - 150,SCREEN_WIDTH-100, 50);
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    // Do any additional setup after loading the view.
}

- (void)sliderValueChange:(UISlider *)slider
{
    _waterSetover = (1-slider.value)*CGRectGetHeight(_waveView.frame);
}

- (void) waterWaveWithCoordinateX:(CGFloat)x CoordinateY:(CGFloat)y Radius:(CGFloat)r Color:(UIColor *)color{
    _waveView = [[UIView alloc] initWithFrame:CGRectMake(x, y, r, 5*r/4)];
    _waveView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_waveView];
    
    //default
    _waterAmplitude = 5.0;
    //假设在frame的长度上出现2.5个完整的波形:注意这里乘以0.5出现震荡效果,如果不乘以0.5只会出现波形平移的效果。
    _waterFrequency = 2 *M_PI * 2.5 / _waveView.frame.size.width *0.3;
    _waterFrequencyWeak =2 *M_PI * 2.f / _waveView.frame.size.width *0.3;
    
    _waterEpoch = 0.0;
    _waterEpochWeak = 50;
    _waterSetover = CGRectGetHeight(_waveView.frame);
    
    _waterWaveWidth = CGRectGetWidth(_waveView.frame);
    _waterWaveHeight = CGRectGetHeight(_waveView.frame);
    
    [_waveView.layer addSublayer:self.waterShapeLayer];
    [_waveView.layer addSublayer:self.waterShapeLayerWeak];
    
    //初始化定时器
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(waterWaveAnimation)];
    [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [self drawViewWithCoordinateX:r/2 CoordinateY:5*r/4-r*7/8 Radius:r Color:[UIColor colorWithRed:225/255.0 green:36/255.0 blue:24/255.0 alpha:1.0]];
}

- (void)drawViewWithCoordinateX:(CGFloat)x CoordinateY:(CGFloat)y Radius:(CGFloat)r Color:(UIColor *)color{
    [color set];
    //三次曲线
    UIBezierPath* vPath = [UIBezierPath bezierPath];
    vPath.lineWidth = 5.0;
    vPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    vPath.lineJoinStyle = kCGLineCapRound;  //终点处理
    //起始点
    [vPath moveToPoint:CGPointMake(x, y)]; //y=225 r= 200
    [vPath addCurveToPoint:CGPointMake(x-r/2, y+r/8) controlPoint1:CGPointMake(x-r/8, y-r/4) controlPoint2:CGPointMake(x-r/2, y-r/4)];
    [vPath addCurveToPoint:CGPointMake(x-r/4, y+r*5/8) controlPoint1:CGPointMake(x-r/2, y+r*3/8) controlPoint2:CGPointMake(x-r/4, y+r*5/8)];
    [vPath addLineToPoint:CGPointMake(x, y+r*7/8)];
    //另半边
    [vPath addLineToPoint:CGPointMake(x+r/4, y+r*5/8)];
    [vPath addCurveToPoint:CGPointMake(x+r/2, y+r/8) controlPoint1:CGPointMake(x+r/2, y+r*3/8) controlPoint2:CGPointMake(x+r/2, y+r/8)];
    [vPath addCurveToPoint:CGPointMake(x, y) controlPoint1:CGPointMake(x+r/2, y-r/4) controlPoint2:CGPointMake(x+r/8, y-r/4)];
    [vPath stroke];
    
    //用于截取
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = vPath.CGPath;
    [_waveView.layer setMask:layer];
    
    //用于显示外部❤️线框
    CAShapeLayer *line = [[CAShapeLayer alloc] init];
    line.lineWidth = 2.0f;
    line.strokeColor = color.CGColor;
    line.fillColor = [UIColor clearColor].CGColor;
    line.path = vPath.CGPath;
    [_waveView.layer addSublayer:line];
}

- (void)waterWaveAnimation{
    
    //核心代码:
    _waterEpoch += 0.05;
    _waterEpochWeak += 0.05;
    //path
    UIBezierPath *waterWavePath = [UIBezierPath bezierPath];
    [waterWavePath moveToPoint:CGPointMake(0, 0)];
    for (CGFloat x = 0; x < _waterWaveWidth; x ++) {
        CGFloat y = _waterAmplitude * sinf(_waterFrequency * x + _waterEpoch) + _waterSetover;
        [waterWavePath addLineToPoint:CGPointMake(x, y)];
    }
    [waterWavePath addLineToPoint:CGPointMake(_waterWaveWidth, _waterWaveHeight)];
    [waterWavePath addLineToPoint:CGPointMake(0, _waterWaveHeight)];
    [waterWavePath closePath];
    self.waterShapeLayer.path = waterWavePath.CGPath;
    
    
    UIBezierPath *waterWavePathWeak = [UIBezierPath bezierPath];
    [waterWavePathWeak moveToPoint:CGPointMake(0, 0)];
    for (CGFloat x = 0; x < _waterWaveWidth; x ++) {
        CGFloat y = _waterAmplitude * sinf(_waterFrequencyWeak * x + _waterEpochWeak) + _waterSetover;
        [waterWavePathWeak addLineToPoint:CGPointMake(x, y)];
    }
    [waterWavePathWeak addLineToPoint:CGPointMake(_waterWaveWidth, _waterWaveHeight)];
    [waterWavePathWeak addLineToPoint:CGPointMake(0, _waterWaveHeight)];
    [waterWavePathWeak closePath];
    
    self.waterShapeLayerWeak.path = waterWavePathWeak.CGPath;
}
- (CAShapeLayer *)waterShapeLayer{
    if (!_waterShapeLayer) {
        _waterShapeLayer = [CAShapeLayer layer];
//        _waterShapeLayer.frame = self.view.bounds;
        _waterShapeLayer.fillColor = [UIColor colorWithRed:225/255.0 green:36/255.0 blue:24/255.0 alpha:1.0].CGColor;
        _waterShapeLayer.strokeColor = [UIColor clearColor].CGColor;
    }
    return _waterShapeLayer;
}

- (CAShapeLayer *)waterShapeLayerWeak{
    if (!_waterShapeLayerWeak) {
        _waterShapeLayerWeak = [CAShapeLayer layer];
//        _waterShapeLayerWeak.frame = self.view.bounds;
        _waterShapeLayerWeak.fillColor = [UIColor colorWithRed:225/255.0 green:36/255.0 blue:24/255.0 alpha:0.6].CGColor;
        _waterShapeLayerWeak.strokeColor = [UIColor clearColor].CGColor;
    }
    return _waterShapeLayerWeak;
}
- (void)dealloc{
    
    [_timer invalidate];
    _timer = nil;
}
@end
