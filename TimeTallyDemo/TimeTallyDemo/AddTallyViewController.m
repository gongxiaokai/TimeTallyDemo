//
//  AddTallyViewController.m
//  TimeTallyDemo
//
//  Created by gongwenkai on 2017/1/5.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import "AddTallyViewController.h"
#import "TallyListView.h"
#import "CalculatorView.h"
@interface AddTallyViewController ()<TallyListViewDelegate,CalculatorViewDelegate,UIViewControllerTransitioningDelegate>
@property (nonatomic,strong)TallyListView *listView;
@property (nonatomic,strong)CalculatorView *calview;
@property (nonatomic,strong)NSString *currentTallyIdentity;
@property (nonatomic,assign)CGSize itemSize;
@end

//类型选择界面每行cell的个数
static int const  aRowCellCount = 4;

@implementation AddTallyViewController

//类型选择界面
- (TallyListView *)listView {
    if (!_listView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 30;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        CGFloat width = (self.view.frame.size.width - (aRowCellCount-1)*layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right) / aRowCellCount;
        CGFloat height = width * 1.2;
        layout.footerReferenceSize = CGSizeZero;
        layout.headerReferenceSize = CGSizeZero;
        layout.itemSize = CGSizeMake(width, height);
        self.itemSize = CGSizeMake(width-20, width-20);
        //记账类型列表
        _listView = [[TallyListView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - self.view.frame.size.height * 0.4 / 5) collectionViewLayout:layout];
        _listView.customDelegate = self;


    }
    return _listView;
}

//计算器界面
- (CalculatorView *)calview {
    if (!_calview) {
        _calview = [[CalculatorView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.6, self.view.frame.size.width, self.view.frame.size.height * 0.4)];
        _calview.delegate = self;
        _calview.imageViewSize = self.itemSize;

        
    }
    return _calview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.listView];
    [self.view addSubview:self.calview];
    self.title = @"新增";

    //修改时计算界面传值
    if (self.currentTallyIdentity != nil) {
        [self.calview modifyTallyWithIdentity:self.currentTallyIdentity];
        self.title = @"修改";
    }
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TallyListViewDelegate

- (void)didSelectItem:(UIImage*)cellImage andTitle:(NSString*)title withRectInCollection:(CGRect)itemRect {
    UIImageView *animateImage = [[UIImageView alloc] initWithFrame:itemRect];
    animateImage.image = cellImage;
    [self.view addSubview:animateImage];
    
    __block CGPoint imgPoint;
    self.calview.positionInViewBlock = ^(CGPoint point){
        imgPoint = point;
    };
    
    //给计算器界面传值
    self.calview.imageViewSize = itemRect.size;
    self.calview.image = cellImage;
    self.calview.typeName = title;
    
    //设置贝塞尔曲线路径动画
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:animateImage.center];
    [path addCurveToPoint:imgPoint controlPoint1:CGPointMake(animateImage.frame.origin.x, animateImage.frame.origin.y-100 ) controlPoint2:CGPointMake(animateImage.frame.origin.x, animateImage.frame.origin.y-100 )];
    CAKeyframeAnimation *anmiation0 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    anmiation0.path = path.CGPath;
    anmiation0.duration = 1;
    anmiation0.removedOnCompletion = NO;
    anmiation0.fillMode = kCAFillModeForwards;
    [animateImage.layer addAnimation:anmiation0 forKey:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [animateImage removeFromSuperview];
    }];
    
}

//计算界面下降
- (void)listScrollToBottom {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.calview.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-CGRectGetHeight(self.calview.frame)/5, self.calview.frame.size.width, self.calview.frame.size.height);
    } completion:nil];
    

}
#pragma mark - CalculatorViewDelegate
//保存成功
- (void)tallySaveCompleted {
    
    //随机转场动画
    NSArray *tanArray = @[@"pageCurl",@"pageUnCurl",@"rippleEffect",@"suckEffect",@"cube",@"oglFlip"];
    NSString *anStr = tanArray[arc4random()%tanArray.count];
    self.navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    CATransition *tran = [CATransition animation];
    tran.duration = 0.5;
    tran.type = anStr;
    tran.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:tran forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];

}
//保存失败
- (void)tallySaveFailed {
    UIAlertController *alertVC =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择类别并输入金额" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//返回位置
- (void)backPositionWithAnimation {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.calview.frame = CGRectMake(0, self.view.frame.size.height * 0.6, self.view.frame.size.width, self.view.frame.size.height * 0.4);
    } completion:nil];
}

- (void)selectTallyWithIdentity:(NSString*)identity{
    self.currentTallyIdentity = identity;
}

@end
