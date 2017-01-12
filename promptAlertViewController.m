//
//  AlertViewController.m
//  HSSLicAI
//
//  Created by huishangsuo on 16/6/17.
//  Copyright © 2016年 huishangsuo. All rights reserved.
//

#import "promptAlertViewController.h"

@interface promptAlertViewController ()

@end

@implementation promptAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


+(void)showAlertViewOnVC:(id)viewController withMessage:(NSString *)alertViewMessage actionMessage:(NSString * )message :(alertAction)action action1:(alertAction)action1 ;
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:alertViewMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:message style:UIAlertActionStyleCancel handler:action];
    [alertController addAction:cancelAction];
    
    if (action1) {
        UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:action1];
        [alertController addAction:cancelAction1];
    }
    
    UIViewController * vc =(UIViewController *)viewController;
    [vc presentViewController:alertController animated:YES completion:nil];
}
+ (void)showButtonAlertView:(id)viewController withMessage:(NSString *)alerViewMessage actionMessage:(NSString *)actionName {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:alerViewMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:actionName style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIViewController * vc =(UIViewController *)viewController;
    [vc presentViewController:alertController animated:YES completion:nil];
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
