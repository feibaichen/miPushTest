//
//  ViewController.m
//  miPushTest
//
//  Created by Derek on 13/12/17.
//  Copyright © 2017年 Derek. All rights reserved.
//

#import "ViewController.h"
#import "MiPushSDK.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.view.backgroundColor=[UIColor redColor];
    
    //根据测试和使用，发现，苹果和安卓在使用小米推送时候，无法进行在后台统一发送消息，各自单独推送，这个很蛋疼，哥表示不推荐使用小米推送，毕竟不专业、完善
    
    //连接手机在真机上调试，要在后台发送测试消息，在info.plist 设置MiSDKRun为Debug
    //上传了测试版到App Store后台的，在info.plist 设置MiSDKRun为Online,可以发送在线消息进行测试，发送特定别名、或者全部手机
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
