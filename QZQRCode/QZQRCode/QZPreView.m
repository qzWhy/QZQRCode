//
//  QZPreView.m
//  911
//
//  Created by 000 on 17/9/11.
//  Copyright © 2017年 faner. All rights reserved.
//

#import "QZPreView.h"

@interface QZPreView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation QZPreView

/**
 *  layer的类型
 *
 *  @return AVCaptureVideoPreviewLayer 特殊的layer 可以展示输入设备采集到的信息
 */

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (void)setSession:(AVCaptureSession *)session
{
    _session = session;
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)self.layer;
    layer.session = session;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUiConfig];
    }
    return self;
}

- (void)initUiConfig
{
    //设置背景图片
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QR"]];
    //设置位置到界面的中间
    _imageView.frame = CGRectMake(self.bounds.size.width * 0.5 - 140, self.bounds.size.height *0.5 - 140, 280, 280);
    //添加到视图上
    [self addSubview:_imageView];
    
    //初始化二维码到扫描线位置
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _lineImageView.image = [UIImage imageNamed:@"scanline"];
    [_imageView addSubview:_lineImageView];
    
    //开启定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    
}
- (void)animation
{
    [UIView animateWithDuration:2.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _lineImageView.frame = CGRectMake(30, 260, 220, 2);
    } completion:^(BOOL finished) {
        _lineImageView.frame = CGRectMake(30, 10, 220, 2);
    }];
}


@end
