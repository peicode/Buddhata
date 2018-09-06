//
//  PSMenuViewController.m
//  佛性人生
//
//  Created by sunny&pei on 2018/4/4.
//  Copyright © 2018年 sunny&pei. All rights reserved.
//

#import "PSMenuViewController.h"
#import "UIViewController+XWTransition.h"
#import "PSEditViewCell.h"

@interface PSMenuViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *choseArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSString * beginForText;
@property(nonatomic,assign)int idForText;
@end

@implementation PSMenuViewController
{
    NSString *_textStr;
    FMDatabase *_db;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    //设置NavgaView和TableView
    [self setNavgaView];
    //创建数据库
    [self creatFMDBdata];
    __weak typeof(self)weakSelf = self;
    [self xw_registerBackInteractiveTransitionWithDirection:XWInteractiveTransitionGestureDirectionRight transitonBlock:^(CGPoint startPoint) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    } edgeSpacing:PSSCREENW/2];
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
    UIButton *sureBtn = [[UIButton alloc]init];
    UILabel *titleLabel = [[UILabel alloc]init];
    if(SCREENH == 812){
        headView.frame = CGRectMake(0, 0, PSSCREENW, 80);
        sureBtn.frame = CGRectMake(6, 44, 40, 24);
        titleLabel.center = CGPointMake(PSSCREENW/2 - 44, 44);
    }else{
        headView.frame = CGRectMake(0, 0, PSSCREENW, 60);
        sureBtn.frame = CGRectMake(6, 29, 40, 24);
        titleLabel.center = CGPointMake(PSSCREENW/2 - 44, 24);
    }
    
    headView.backgroundColor = [UIColor colorWithRed:77/255.0 green:161/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:headView];
    
    [headView addSubview:sureBtn];
    [sureBtn setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:22];
    titleLabel.text = @"选项清单";
    titleLabel.textColor = [UIColor whiteColor];
    
    [titleLabel sizeToFit];
//    NSLog(@"%@",NSStringFromCGRect(titleLabel.frame));
    [headView addSubview:titleLabel];
    //创建tableView
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, headView.frame.size.height,PSSCREENW , PSSCREENH-60);
    //去掉分割线  需要写下setSeparatorInset方法前面
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.backgroundColor = [UIColor whiteColor];
//    _tableView.rowHeight = 60;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableView registerNib:[UINib nibWithNibName:@"PSEditViewCell" bundle:nil] forCellReuseIdentifier: editcellID];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
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
//        static NSString *cellID = @"textcell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        PSEditViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editcellID forIndexPath:indexPath];
//        if (cell == nil) {
//            cell = [[PSEditViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:editcellID];
//
//        }
        cell.textField.delegate = self;
        cell.editingAccessoryType = UITableViewCellAccessoryDetailButton;
//        cell.textLabel.text = self.choseArray[indexPath.row];
//        cell.textLabel.font = [UIFont systemFontOfSize:22];
        cell.textField.text = self.choseArray[indexPath.row];
        cell.textField.font = [UIFont systemFontOfSize:22];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ab"];
        cell.imageView.image = [UIImage imageNamed:@"add"];
        cell.textLabel.text = @"添加新选项";
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
        
        //
        [self.shakeVc refreshLabelFromShake];
        //刷新转盘
        [self.transVc refreshUILabelFormBGView];
    }
    [tableView endUpdates];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [self addBtnClick];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        PSEditViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}
#pragma mark --UITextFieldDelegate
///这里需要获取到当前更新数据的 id ，然后根据id来更新对应字段
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _beginForText = textField.text;
    NSLog(@"%@",textField.text);
    [_db open];
    //用数组读取数据
    FMResultSet *resultSet = [_db executeQuery:@"SELECT * FROM budda where context = ?", _beginForText];
//    NSMutableArray *array = [NSMutableArray array];
    
    while ([resultSet next]) {
//        NSUInteger a = [resultSet stringForColumn:@"id"];
//        [array addObject:a];
        int a = [resultSet intForColumn:@"id"];
        NSLog(@"%d",a);
        _idForText = a;
    }
    
//    self.choseArray = array;
//    [self.tableView reloadData];
    [_db close];

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *str = textField.text;
     NSLog(@"%@",textField.text);
    NSLog(@"%d",_idForText);

    if (![str isEqualToString:_beginForText]) {
        
    [_db open];
    NSLog(@"%@",self.beginForText);
    //删除对应数据
    NSString *updateStr = [NSString stringWithFormat:@"UPDATE budda SET context = '%@' WHERE id = '%d' ",textField.text,_idForText];
    BOOL result = [_db executeUpdate:updateStr];
    if (result ) {
        NSLog(@"update-success");
    }
    [_db close];
    //需要刷新表格
    [self refreshUI];
//        [self.tableView reloadData];
    
    //刷新转盘
    [self.transVc refreshUILabelFormBGView];
    [self.shakeVc refreshLabelFromShake];
    }
    
}
#pragma mark--按钮的点击操作

/**
 保存按钮，保存tableView中的数据，退出Vc
 */
- (void)sureBtnClick{
    //需要刷新表格
    [self refreshUI];
    //至少需要三个选项
    int count =(int) self.choseArray.count;
    if(count == 2){
        [_db open];
        [_db executeUpdate:@"INSERT INTO budda (context) VALUES (?);",@"P❤️S"];
        [_db close];
        
        
        //刷新转盘
        [self.transVc refreshUILabelFormBGView];
        
    }
    if (self.choseArray.count == 0) {
        
        [self.shakeVc refreshLabelFromShake];
    }
    
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
            [self.shakeVc refreshLabelFromShake];
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
- (void)saveAllData{
//    int a =
//    [_db open];
//    [_db executeUpdate:@"INSERT INTO budda (context) VALUES (?);",conField.text];
//    [_db close];
//    //需要刷新表格
//    [self refreshUI];
//
//    //刷新转盘
//    [self.transVc refreshUILabelFormBGView];
//    [self.shakeVc refreshLabelFromShake];
}
- (void)updateTextField:(UITextField *)textField WithId: (int)sender{
//    [_db open];
//    NSLog(@"%@",self.beginForText);
//    //删除对应数据
//    NSString *updateStr = [NSString stringWithFormat:@"UPDATE budda SET context = '%@' WHERE context = '%@' ",textField.text,_beginForText];
//    BOOL result = [_db executeUpdate:updateStr];
//    if (result ) {
//        NSLog(@"update-success");
//    }
//    [_db close];
}
@end
