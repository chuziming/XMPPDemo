//
//  HSSShopMallLoginViewController.m
//  HSSLicAI
//
//  Created by 郭建 on 2016/12/5.
//  Copyright © 2016年 huishangsuo. All rights reserved.
//

#import "HSSShopMallLoginViewController.h"
#import "XMPP.h"
#import "XMPPManager.h"
#import "promptAlertViewController.h"
@interface HSSShopMallLoginViewController ()<XMPPStreamDelegate>
{
    BOOL isKeJ;
}


@end

@implementation HSSShopMallLoginViewController
#pragma mark - Navigation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setFanHuiButtonCilck];
    
//    self.xmppstrem =[[XMPPStream alloc] init];
    [[XMPPManager defaultManager].xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}
#pragma mark - UI
// 返回按钮
- (void)setFanHuiButtonCilck {
    
    // 设置输入框占位文字的字体颜色
     [self.phoneTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    // 返回按钮添加方法
    [self.fanHuiButton addTarget:self action:@selector(returnBackSurface) forControlEvents:UIControlEventTouchUpInside];
    // 手机号快速注册按钮添加方法
    [self.phoneRegisteredButton addTarget:self action:@selector(setPhoneRegisteredButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    // 忘记密码
    [self.forgetPasswordButton addTarget:self action:@selector(setForgetPasswordButtonAction) forControlEvents:UIControlEventTouchUpInside];
    // 设置密码是否可见
    [self.keJianButton addTarget:self action:@selector(setKeJianImageViewOfImage) forControlEvents:UIControlEventTouchUpInside];
    
    // 登录
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - ButtonAction
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.passwordTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}
// 登录
- (void)login {
    [[XMPPManager defaultManager] loginWithUsername:self.phoneTextField.text password:self.passwordTextField.text];

    
   }
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"%s__%d__| 验证成功",__FUNCTION__,__LINE__);
    
    // 上线
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [[XMPPManager defaultManager].xmppStream sendElement:presence];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"haveLogin"]; // 记录登录状态
    
    // 保存用户名和密码
    [userDefaults setValue:self.phoneTextField.text forKey:@"username"];
    [userDefaults setValue:self.passwordTextField.text forKey:@"password"];
    [userDefaults synchronize]; // 生效
    
    //进入好友列表页面
    [self.navigationController popViewControllerAnimated:YES];
}


// 认证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    [promptAlertViewController showButtonAlertView:self withMessage:@"验证失败请稍后再试" actionMessage:@"确定"];
}



// 返回按钮
- (void)returnBackSurface {
    if (self.istabelBar) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shopJumpLoginAction" object:nil];

    }

    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
// 手机号快速注册按钮添加方法
- (void)setPhoneRegisteredButtonCilck {
  
}
// 忘记密码
- (void)setForgetPasswordButtonAction {
  
}
// 是否可见密码
- (void)setKeJianImageViewOfImage {
    if (isKeJ) {
        self.keJianImageView.image = [UIImage imageNamed:@"不可见"];
        self.passwordTextField.secureTextEntry = YES;
        isKeJ = NO;
    }else {
        self.keJianImageView.image = [UIImage imageNamed:@"可见"];
        self.passwordTextField.secureTextEntry = NO;
        isKeJ = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
