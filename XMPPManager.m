//
//  XMPPManager.m
//  XMPPdemo
//
//  Created by huishangsuo on 2017/1/10.
//  Copyright © 2017年 chuziming. All rights reserved.
//

#import "XMPPManager.h"
#import "promptAlertViewController.h"
typedef NS_ENUM(NSInteger, ConnectToServerPurpose){
    
    ConnectToServerPurposeLogin,     // 登录
    ConnectToServerPurposeRegister,  // 注册
    
};



// 把这个管理类作为通信管道的代理
@interface XMPPManager ()<XMPPStreamDelegate,XMPPRosterDelegate,UIAlertViewDelegate>

@property (nonatomic) ConnectToServerPurpose connectionToServerPurpose; // 在和服务器建立连接成功之后用来区分用户是用来注册还是登录

@property (nonatomic,strong) NSString *loginPassword; // 用来记录用户登录时的密码

@property (nonatomic,strong) NSString *registerPassword; // 用来记录用户注册是的密码

@property (nonatomic,strong) XMPPJID *requestFroJID; // 好友请求来自于哪个JID

@end
@implementation XMPPManager
+(XMPPManager *)defaultManager{
    static XMPPManager * defaultManager;
    static dispatch_once_t onToken;
    dispatch_once(&onToken, ^{
        
        defaultManager = [[XMPPManager alloc] init];
        
        
        
    });
    
    return defaultManager;
    
}
-(id)init{
    
    self =[super init];
    if (self) {
        self.xmppStream =[[XMPPStream alloc] init];
        self.xmppStream.hostName = @"127.0.0.1";
        self.xmppStream.hostPort = 5222;
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];

        XMPPRosterCoreDataStorage *rosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
        
        self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:rosterStorage dispatchQueue:dispatch_get_main_queue()]; // dispatch_get_main_queue():主线程
        
        [self.xmppRoster activate:self.xmppStream]; // 激活在对应的管道上
        
        [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        XMPPMessageArchivingCoreDataStorage * messageArchivingCoreDataStorage =[XMPPMessageArchivingCoreDataStorage sharedInstance];
        self.xmppMessageArchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:messageArchivingCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        [self.xmppMessageArchiving activate:self.xmppStream];
        self.messageArchivingManagedObjectContext = messageArchivingCoreDataStorage.mainThreadManagedObjectContext;
        
        
                  }
    return self;
    
    
}

- (void)connectToServer
{
    if ([self.xmppStream isConnected]) { // 如果管道正在链接,则断开它
        
        // 断开连接
        XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
        [self.xmppStream sendElement:presence]; // 把状态通过管道对象发送给服务器
        [self.xmppStream disconnect]; // 断开链接
    }
    
    NSError *error;
    [self.xmppStream connectWithTimeout:30 error:&error];
    if (error != nil) {
        
        NSLog(@"%s__%d__| 与服务器连接失败Error=%@",__FUNCTION__,__LINE__,error);
    }
    
}
// 登录
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    self.connectionToServerPurpose = ConnectToServerPurposeLogin; // 记录链接服务器的目的
    self.loginPassword = password;
    
    [self connectionWithUsername:username];// 在下面封装好的方法调用的
}

// 封装的方法
- (void)connectionWithUsername:(NSString *)username
{
    XMPPJID *myJID = [XMPPJID jidWithUser:username domain:@"127.0.0.1" resource:@"iOS"];
    self.xmppStream.myJID = myJID;
    
    // 链接服务器
    [self connectToServer];
}

#pragma mark - XMPPStreamDelegate

// 与服务器连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"%s__%d__| 与服务器链接成功",__FUNCTION__,__LINE__);
    
    switch (self.connectionToServerPurpose) {
        case ConnectToServerPurposeLogin:
        {
            // 进行认证
            [sender authenticateWithPassword:self.loginPassword error:NULL];
            break;
        }
        case ConnectToServerPurposeRegister:
        {
            // 新用户注册
            [sender registerWithPassword:self.registerPassword error:NULL];
            break;
        }
            
        default:
            break;
    }
    
}

// 连接超时
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    NSLog(@"%s__%d__| 连接超时",__FUNCTION__,__LINE__);
}


// 认证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"%s__%d__| 认证成功",__FUNCTION__,__LINE__);
    
    
    // 下面判读语句的目的是防止在登陆界面的时候重复上线,另外为了用户下次进入程序的时候自动登录
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"haveLogin"] == NO) {
        
        return;
    }
    //上线
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [self.xmppStream sendElement:presence];
}

// 认证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"%s__%d__| 认证失败",__FUNCTION__,__LINE__);
}


// 收到好友请求
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    self.requestFroJID = presence.from; // 获取到好友请求从哪个账号
    
    
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"好友请求" message:presence.from.user delegate:self cancelButtonTitle:@"走你" otherButtonTitles:@"好丫", nil];
    [alerView show];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            // 拒绝添加好友
            [self.xmppRoster rejectPresenceSubscriptionRequestFrom:self.requestFroJID];
            break;
        }
        case 1:
        {
            // 同意添加好友
            [self.xmppRoster acceptPresenceSubscriptionRequestFrom:self.requestFroJID andAddToRoster:YES];
            break;
        }
            
        default:
            break;
    }
    self.requestFroJID = nil;
}















@end
