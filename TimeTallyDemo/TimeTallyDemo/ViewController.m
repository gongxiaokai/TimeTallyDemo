//
//  ViewController.m
//  TimeTallyDemo
//
//  Created by gongwenkai on 2017/1/4.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import "ViewController.h"
#import "AddTallyViewController.h"
#import "TimeLineView.h"
@interface ViewController ()<TimeLineViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSDictionary *timeLineModelsDict;
@property(nonatomic,assign)CGFloat allDateAllLine;
@property (weak, nonatomic) IBOutlet UILabel *incomLab;
@property (weak, nonatomic) IBOutlet UILabel *expenseLab;

@end
@implementation ViewController



- (UIScrollView *)scrollView {
    if (!_scrollView) {
         _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+80, self.view.frame.size.width, self.view.frame.size.height-64-80)];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",NSHomeDirectory());
    self.title = @"我的账本";
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//增加一条账单
- (IBAction)clickAddTally:(id)sender {
    AddTallyViewController *addVC = [[AddTallyViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

//出现时 刷新整个时间线
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"will");
    [self showTimeLineView];
 
}

- (void)showTimeLineView {
    //先读取数据库中内容 封装成字典
    [self readSqliteData];
    
    //移除上一个timelineView
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag == 1990) {
            [view removeFromSuperview];
        }
    }
    
    //计算总收入 和 总支出
    double incomeTotal = 0;
    double expenseTotal = 0;
    self.allDateAllLine = 0;
    //计算时间线长度
    for (NSString *key  in self.timeLineModelsDict.allKeys) {
        NSArray<TimeLineModel*> *modelArray = self.timeLineModelsDict[key];
        //一天的时间线总长
        self.allDateAllLine = self.allDateAllLine + kDateWidth + (kBtnWidth+kLineHeight)*modelArray.count + kLineHeight;
        for (TimeLineModel *model in modelArray) {
            incomeTotal = incomeTotal + model.income;
            expenseTotal = expenseTotal + model.expense;
        }
    }
    
    self.incomLab.text = [NSString stringWithFormat:@"%.2f",incomeTotal];
    self.expenseLab.text = [NSString stringWithFormat:@"%.2f",expenseTotal];
    
    //设置时间线视图timelineview
    CGRect rect  = CGRectMake(0, 0, self.view.frame.size.width, self.allDateAllLine);
    TimeLineView *view = [[TimeLineView alloc] initWithFrame:rect];
    view.tag = 1990;
    view.delegate = self;
    view.backgroundColor = [UIColor whiteColor];
    view.timeLineModelsDict = self.timeLineModelsDict;
    [self.scrollView addSubview:view];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.allDateAllLine);
    //滚动到顶端
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
    
    
}


//读取数据库中的数据  以字典的形式 key：@"日期" object：[账单信息]
- (void)readSqliteData{
    self.timeLineModelsDict = nil;
    self.timeLineModelsDict = [[CoreDataOperations sharedInstance] getAllDataWithDict];
}

//删除前的确认
- (void)willDeleteCurrentTallyWithIdentity:(NSString*)identity {
    
    UIAlertController *alertVC =[UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除" preferredStyle:UIAlertControllerStyleAlert ];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //数据库操作：从数据库中删除 Tally表中对应identity字段行
        Tally *tally = [[CoreDataOperations sharedInstance] getTallyWithIdentity:identity];
        [[CoreDataOperations sharedInstance] deleteTally:tally];
        //删除完成后 刷新视图
        [self showTimeLineView];

    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];

}

//TimeLineViewDelegate  delegate 修改前的准备
- (void)willModifyCurrentTallyWithIdentity:(NSString*)identity {
    AddTallyViewController *addVC = [[AddTallyViewController alloc] init];
    [addVC selectTallyWithIdentity:identity];
    [self.navigationController pushViewController:addVC animated:YES];

}
@end
