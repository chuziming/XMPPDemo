//
//  XMPPManager.h
//  XMPPdemo
//
//  Created by huishangsuo on 2017/1/10.
//  Copyright © 2017年 chuziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "XMPPMessageArchiving.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
@interface XMPPManager : NSObject


typedef void (^ErrorBlock)( id obj);

//创建一个单利对象 管理xmpp
+(XMPPManager * )defaultManager;
//通信管道对象 所有与服务的交互都通过管道完成
@property(nonatomic,strong)XMPPStream * xmppStream;
// 声明一个好友花名册对象,管理好友列表 (需要在init里面初始化)
@property(nonatomic,strong) XMPPMessageArchiving * xmppMessageArchiving;
@property (nonatomic, strong) XMPPRoster *xmppRoster;
//信息归档
@property (nonatomic, strong)XMPPMessageArchiving * mppMessageArchiving;
@property (nonatomic,strong)XMPPMessageArchivingCoreDataStorage * XMPPMessageArchiving;
@property (nonatomic, strong)NSManagedObjectContext *messageArchivingManagedObjectContext;
// 登录
- (void)loginWithUsername:(NSString *)username password:(NSString *)password;

// 注册
- (void)registerWithUsername:(NSString *)username password:(NSString *)password;

@end
