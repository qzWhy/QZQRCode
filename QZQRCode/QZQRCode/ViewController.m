//
//  ViewController.m
//  QZQRCode
//
//  Created by 000 on 17/10/17.
//  Copyright © 2017年 faner. All rights reserved.
//// iOS7开始，系统有了自带的二维码扫描功能

//二维码实现思路
/**
 1.输入设备（用来获取外界信息）摄像头，麦克风，键盘
 2.输出设备（将收集到的信息，做解析，来获取收到的内容） －－>设置代理及设置二维码类型
 3.会话session （用来连接输入和输出设备）-->需要关联输入和输出，同时设置大笑
 4.特殊的 layer （展示输入设备所采集的信息）
 5.启动会话
 代理方法中
 1.停止方法
 2.删除layer
 3.遍历数据获取内容
 */


#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
//用QZPreView写的
#import "QZPreViewController.h"
@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

// 1.输入设备（用来获取外界信息）摄像头，麦克风，键盘
@property (nonatomic, strong) AVCaptureDeviceInput *input;
// 2.输出设备（将收集到的信息，做解析，来获取收到的内容）
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
//3.会话session （用来连接输入和输出设备）
@property (nonatomic, strong) AVCaptureSession *session;
//4.特殊的 layer （展示输入设备所采集的信息）
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *brn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 60)];
    [brn setTitle:@"点我" forState:UIControlStateNormal];
    [brn setBackgroundColor:[UIColor redColor]];
    [brn addTarget:self action:@selector(brnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:brn];
}

- (void)brnClick
{
    QZPreViewController *vc = [[QZPreViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

/**
 *  点击屏幕开始扫描
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1.输入设备（用户获取外来信息） 摄像头 麦克风 键盘
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //2.输出设备 （将收集到的信息做解析，来获取收到的内容）
    self.output = [AVCaptureMetadataOutput new];
    
    //3.会话session （用来连接输入和输出设备）
    self.session = [AVCaptureSession new];
    
    //会话扫面展示的大小
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //会话跟输入和输出设备关联
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    //指定输出设备的代理，用来接受返回数据的代理
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置元数据类型 二维码
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //4.特殊的 layer （展示输入设备所采集的信息）
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    //指定layer的大小
    self.previewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.previewLayer];
    
    //5.启动会话
    [self.session startRunning];
}
/**
 * captureOutput : 输出设备
 * metadataObjects ： 元数据对象数组
 * connection : 连接
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //1.停止会话
    [self.session stopRunning];
    
    //2.删除layer
    [self.previewLayer removeFromSuperlayer];
    
    //3.遍历数据获取内容
    for (AVMetadataMachineReadableCodeObject *obj in metadataObjects) {
        NSLog(@"obj : %@",obj.stringValue);
    }
}

@end
