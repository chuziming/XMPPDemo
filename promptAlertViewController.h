//
//  AlertViewController.h
//  HSSLicAI
//
//  Created by huishangsuo on 16/6/17.
//  Copyright © 2016年 huishangsuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface promptAlertViewController : UIViewController

typedef void (^alertAction)(UIAlertAction *action);

+(void)showAlertViewOnVC:(id)viewController withMessage:(NSString *)alertViewMessage actionMessage:(NSString * )message :(alertAction)action action1:(alertAction)action1;
+ (void)showButtonAlertView:(id)viewController withMessage:(NSString *)alerViewMessage actionMessage:(NSString *)actionName;
@end
