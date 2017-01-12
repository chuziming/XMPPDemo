//
//  ViewController.m
//  XMPPdemo
//
//  Created by huishangsuo on 2017/1/9.
//  Copyright © 2017年 chuziming. All rights reserved.
//

#import "ViewController.h"
#import "HSSShopMallLoginViewController.h"
#import "XMPPManager.h"
#import "frnendTableViewCell.h"
#import "ChatViewController.h"
@interface ViewController ()<XMPPRosterDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString * userName;
}
@property(nonatomic,strong)NSMutableArray * FriendArray;
@property(nonatomic,strong)UITableView * friendTabelView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.FriendArray =[[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"haveLogin"]) {
//        self.allRosterArray = [[NSMutableArray alloc] init];
        [[XMPPManager defaultManager].xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()]; // 为花名册对象添加代理
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        // 自动登录
        [[XMPPManager defaultManager] loginWithUsername:[userDefaults objectForKey:@"username"] password:[userDefaults objectForKey:@"password"]];
        

    }else{
        HSSShopMallLoginViewController * hss =[[HSSShopMallLoginViewController alloc] init];
        [self.navigationController pushViewController:hss animated:YES];
        
    }
    
    self.friendTabelView =[[UITableView alloc] initWithFrame:self.view.bounds];
    self.friendTabelView.delegate = self;
    self.friendTabelView.dataSource = self;
    
    [self.view addSubview:self.friendTabelView];
    

}

// 开始检索花名册
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
{
    NSLog(@"%s__%d__| 开始检索好友花名册",__FUNCTION__,__LINE__);
}


- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item
{
    NSString *JIDStr = [[item attributeForName:@"jid"] stringValue];
    
    XMPPJID *JID = [XMPPJID jidWithString:JIDStr resource:@"iOS"];
    
    if ([self.FriendArray containsObject:JID]) {  // 如果数组中已经存在对应对象
        
        return;
    }
    [self.FriendArray addObject:JID];
    [self.friendTabelView reloadData];
}
// 检索花名册结束
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
    NSLog(@"%s__%d__| 检索花名册结束",__FUNCTION__,__LINE__);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.FriendArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    frnendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil){
        
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"frnendTableViewCell" owner:self options:nil]lastObject];
        
        XMPPJID *JID = [self.FriendArray objectAtIndex:indexPath.row];
        cell.namelabel.text = JID.user; // 用户名
         userName =JID.bare ;

    }

    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatViewController * chat =[[ChatViewController alloc] init];
    chat.userName =userName;
    [self.navigationController pushViewController: chat animated:YES];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
