//
//  ChatViewController.m
//  XMPPdemo
//
//  Created by huishangsuo on 2017/1/10.
//  Copyright © 2017年 chuziming. All rights reserved.
//

#import "ChatViewController.h"
#import "chatTableViewCell.h"
#import "XMPPMessage.h"
#import "XMPPManager.h"
@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,XMPPRosterStorage>
@property (weak, nonatomic) IBOutlet UITableView *nameTabelView;
@property (weak, nonatomic) IBOutlet UITextField *chartextField;
@property (weak, nonatomic) IBOutlet UIButton *charButton;
@property (nonatomic,strong)NSMutableArray  *allMessageArray;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.charButton addTarget:self action:@selector(charButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.charTabelView.delegate = self;
    self.charTabelView.dataSource = self;
    self.allMessageArray = [NSMutableArray array];
    
    // 添加代理
    [[XMPPManager defaultManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //加载聊天记录
    [self reloadMessage];
}
#pragma mark - 刷新数据
-(void)reloadMessage
{
    
    
    NSManagedObjectContext *context = [XMPPManager defaultManager].messageArchivingManagedObjectContext; //得到存储聊天信息的上下文
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@ AND bareJidStr == %@", [XMPPManager defaultManager].xmppStream.myJID.bare, self.userName];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"%s__%d__|查询数据出错error : %@",__FUNCTION__,__LINE__,error);
    }
    else{
        if (self.allMessageArray.count) {
            [self.allMessageArray removeAllObjects];
        }
        [self.allMessageArray addObjectsFromArray:fetchedObjects];
        [self.nameTabelView reloadData];
        if (self.allMessageArray.count) {
            NSIndexPath * indexPath =[NSIndexPath indexPathForRow:self.allMessageArray.count -1  inSection:0];
            //为了让界面停留在最新收到（发出）的信息所在的位置
            [self.nameTabelView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
// 信息发送成功 (先遵守XMPPStreamDelegate协议)
-(void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    NSLog(@"%s__%d__| 信息发送成功:Message = %@",__FUNCTION__,__LINE__,message);
    [self.allMessageArray addObject:message];
    [self.nameTabelView reloadData];
    self.charTextField.text = @"";

}

// 收到别人发送的信息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"%s__%d__| 收到别人发送过来的信息:Message = %@",__FUNCTION__,__LINE__,message);
    [self.allMessageArray addObject:message];
    [self.nameTabelView reloadData];
self.charTextField.text = @"";
}
-(void)charButtonAction{
    if (self.charTextField.text.length>0) {
        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:self.userName resource:@"iOS"]]; // @"chat"表示信息的类型是聊天
        
        [message addBody:self.charTextField.text]; // 发送的信息
        
        [[XMPPManager defaultManager].xmppStream sendElement:message]; // 发送信息
        

    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.allMessageArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
       chatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil){
        
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"chatTableViewCell" owner:self options:nil]lastObject];
        XMPPMessageArchiving_Message_CoreDataObject * message = [self.allMessageArray objectAtIndex:indexPath.row];

        if (message.isOutgoing == YES) {
            //信息是自己发出的
            cell.leftLabel.text = message.body;
            cell.rightLabel.text = @"";
        }
        else{
            cell.leftLabel.text = @"";
            cell.rightLabel.text =message.body;
        }
        
    }
    
    
    
    
    
    return cell;
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
