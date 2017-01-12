//
//  HSSShopMallLoginViewController.h
//  HSSLicAI
//
//  Created by 郭建 on 2016/12/5.
//  Copyright © 2016年 huishangsuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSSShopMallLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *keJianImageView;
@property (weak, nonatomic) IBOutlet UIButton *keJianButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneRegisteredButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *fanHuiButton;

@property(nonatomic)BOOL istabelBar;
@end
