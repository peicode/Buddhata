//
//  PSMenuViewController.m
//  佛性人生
//
//  Created by sunny&pei on 2018/4/4.
//  Copyright © 2018年 sunny&pei. All rights reserved.
//

#import "PSMenuViewController.h"
@interface PSMenuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *choseArray;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation PSMenuViewController
{
    NSString *_textStr;
    FMDatabase *_db;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    //设置NavgaView和TableView
    [self setNavgaView];
    //创建数据库
    [self creatFMDBdata];
}
-(NSMutableArray *)choseArray{
   
    if (_choseArray == nil) {
        //打开数据库
        [_db open];
        //用数组读取数据
        FMResultSet *resultSet = [_db executeQuery:@"SELECT * FROM budda"];
        NSMutableArray *array = [NSMutableArray array];
        while ([resultSet next]) {
            NSString *text = [resultSet stringForColumn:@"context"];
            [array addObject:text];
        }
        _choseArray = array;
        [_db close];
    }
    return _choseArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setNavgaView{
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 20, self.view.frame.size.width, 60);
    headView.backgroundColor = [UIColor colorWithRed:255/255.0 green:125/255.0 blue:125/255.0 alpha:1];
    [self.view addSubview:headView];
    
    UIButton *sureBtn = [[UIButton alloc]init];
    sureBtn.frame = CGRectMake(40, 20, 40, 40);
    [sureBtn setTitle:@"back" forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor grayColor];
    [headView addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.center = CGPointMake(self.view.center.x-30, 20);
    titleLabel.text = @"佛系选择";
    titleLabel.font = [UIFont systemFontOfSize:22];
    [titleLabel sizeToFit];
    [headView addSubview:titleLabel];
    
//    UIButton *addBtn = [[UIButton alloc]init];
//    addBtn.frame = CGRectMake(self.view.frame.size.width - 60, 20, 40, 40);
//    [addBtn setTitle:@"add" forState:UIControlStateNormal];
//    addBtn.backgroundColor = [UIColor grayColor];
//    [headView addSubview:addBtn];
//    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, headView.frame.size.height+20,self.view.frame.size.width , 660);
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.rowHeight = 60;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
#pragma mark -更新TableView
-(void)refreshUI{
    [_db open];
    //用数组读取数据
    FMResultSet *resultSet = [_db executeQuery:@"SELECT * FROM budda"];
    NSMutableArray *array = [NSMutableArray array];
    while ([resultSet next]) {
        NSString *text = [resultSet stringForColumn:@"context"];
        [array addObject:text];
    }
    self.choseArray = array;
    [self.tableView reloadData];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.choseArray.count inSection:0];
//    [self.tableView beginUpdates];
//    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
//    [self.tableView endUpdates];
    
    [_db close];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.choseArray.count;
    }else{
        return 1;
    }
    
}

/**
 这里的cell需要展示标题
 具体的内容需要点进cell里面才能查看
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellID = @"textcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.editingAccessoryType = UITableViewCellAccessoryDetailButton;
        cell.textLabel.text = self.choseArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:22];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 10.0f;
        cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.8];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ab"];
        cell.imageView.image = [UIImage imageNamed:@"add"];
        return cell;
    }
    
    
}
#pragma mark - cell的删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView beginUpdates];
    if(editingStyle == UITableViewCellEditingStyleDelete){
        //从数据库中删除
        NSString *str = _choseArray[indexPath.row];
        NSLog(@"%@",str);
        [self deleteCelldataFromData:str];
        //从数据源中删除
        [_choseArray removeObjectAtIndex:indexPath.row];
        
        //从列表中删除
        NSIndexPath *deleteIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        [tableView deleteRowsAtIndexPaths:@[deleteIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
       
        //刷新转盘
        [self.transVc refreshUILabelFormBGView];
    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert){
//        NSArray *insertIndexPath = [NSArray arrayWithObjects:indexPath, nil];
//        //
////        [self.choseArray insertObje];
//    }
    [tableView endUpdates];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [self addBtnClick];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}
#pragma mark--按钮的点击操作

/**
 保存按钮，保存tableView中的数据
 */
- (void)sureBtnClick{
    //退出界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 添加数据
 1.暂时只做一个界面
 */
- (void)addBtnClick{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"添加" message:@"请输入你的选项" preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入你选项";
    }];
    UIAlertAction *sureAc = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *conField = alertVc.textFields.firstObject;
        if (conField.text.length != 0 && conField.text != NULL) {
            [_db open];
            [_db executeUpdate:@"INSERT INTO budda (context) VALUES (?);",conField.text];
            [_db close];
            //需要刷新表格
            [self refreshUI];
            
            //刷新转盘
            [self.transVc refreshUILabelFormBGView];
        }
        
        
    }];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:sureAc];
    [alertVc addAction:cancelAc];
    [self presentViewController:alertVc animated:YES completion:nil];
}

/**
 创建数据库
 */
- (void)creatFMDBdata{
    //获得document目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    //
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    //实例化FMDatabase对象
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    NSString *buddaSql = @"CREATE TABLE IF NOT EXISTS budda (id integer PRIMARY KEY AUTOINCREMENT, context text NOT NULL);";
    [_db executeUpdate:buddaSql];
    BOOL result = [_db executeUpdate:buddaSql];
    if (result) {
        NSLog(@"database-success");
    }
    [_db close];
    
}

/**
 删除对应cell的数据
 */
-(void)deleteCelldataFromData:(NSString *)str{
  
    [_db open];
    //删除对应数据
    NSString *deleteStr = [NSString stringWithFormat:@"delete from budda where context = '%@'",str];
    BOOL result = [_db executeUpdate:deleteStr];
    if (result ) {
        NSLog(@"delete-success");
    }
    [_db close];
}
@end
