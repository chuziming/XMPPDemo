//
//  ChatViewController.h
//  XMPPdemo
//
//  Created by huishangsuo on 2017/1/10.
//  Copyright © 2017年 chuziming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
@property(nonatomic,strong)NSString * userName;
@property (weak, nonatomic) IBOutlet UITableView *charTabelView;
@property (weak, nonatomic) IBOutlet UITextField *charTextField;

@end
