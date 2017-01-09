//
//  CalculatorView.m
//  TimeTallyDemo
//
//  Created by gongwenkai on 2017/1/5.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import "CalculatorView.h"

@interface CalculatorView()
@property (nonatomic,assign)CGFloat btnWidth;               //btn宽
@property (nonatomic,assign)CGFloat btnHeight;              //btn高
@property (nonatomic,copy)NSString *nValue;                 //当前输入值
@property (nonatomic,copy)NSString *resutlStr;              //结果值
@property (nonatomic,strong)UILabel *resultLab;             //结果栏
@property (nonatomic,strong)UIButton *addBtn;               //+
@property (nonatomic,strong)UIColor *btnColor;              //按钮颜色
@property (nonatomic,assign)CGColorRef boardLineColor;      //边框线条颜色
@property (nonatomic,strong)UIImageView *imageView;         //tally类型图
@property(nonatomic,strong)UILabel *typeLab;
@property(nonatomic,copy)NSString *tallyIdentity;

@end



static CGFloat const kBoardWidth = 1;
static CGFloat const kMaxCalCount = 9;
@implementation CalculatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.btnWidth = (self.frame.size.width-kBoardWidth/2)/4;
        self.btnHeight = self.frame.size.height/5;
        self.nValue = @"";
        self.resutlStr = @"";
        self.typeLab.text = @"";
        self.btnColor = [UIColor grayColor];
        self.boardLineColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderColor = self.boardLineColor;
        self.layer.borderWidth = kBoardWidth;
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        [self loadBtn];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        _imageView.image = image;
    }];
    
}

- (void)setTypeName:(NSString *)typeName {
    _typeName = typeName;
    self.typeLab.text = typeName;
}

- (void)setImageViewSize:(CGSize)imageViewSize {
    _imageViewSize = imageViewSize;
    _imageView.frame = CGRectMake(10, (self.btnHeight-imageViewSize.height)/2, imageViewSize.width, imageViewSize.height);
    _imageView.backgroundColor = [UIColor clearColor];
    //回调实际位置
    if (_positionInViewBlock) {
        CGPoint point = CGPointMake(10+imageViewSize.width/2, self.frame.origin.y + _imageView.frame.origin.y + imageViewSize.height/2) ;
        _positionInViewBlock(point);
    }
    self.typeLab.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 10, self.imageView.frame.origin.y, imageViewSize.width * 2, imageViewSize.height);
}

//类型名称lab
- (UILabel *)typeLab {
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_typeLab];
    }
    return _typeLab;
}

//结果lab
- (UILabel *)resultLab {
    if (!_resultLab) {
        _resultLab = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.3, 0, self.frame.size.width * 0.7-10, self.btnHeight)];
        _resultLab.text = @"¥ 0.00";
        _resultLab.textAlignment = NSTextAlignmentRight;
        _resultLab.adjustsFontSizeToFitWidth = YES;
        _resultLab.font = [UIFont systemFontOfSize:25];
        _resultLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] init];
        tag.numberOfTapsRequired = 1;
        [tag addTarget:self action:@selector(clickResultLab)];
        [_resultLab addGestureRecognizer:tag];
    }
    return _resultLab;
}

- (void)clickResultLab {
    if ([self.delegate respondsToSelector:@selector(backPositionWithAnimation)]) {
        [self.delegate backPositionWithAnimation];
    }
}
//加号
- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(3 * self.btnWidth, self.btnHeight * 2, self.btnWidth, self.btnHeight)];
        [_addBtn setTitle:@"+" forState:UIControlStateNormal];
        _addBtn.backgroundColor = self.btnColor;
        _addBtn.layer.borderColor = self.boardLineColor;
        _addBtn.layer.borderWidth = kBoardWidth;
        [_addBtn addTarget:self action:@selector(clickAdd) forControlEvents:UIControlEventTouchUpInside];

    }
    return _addBtn;
}

//普通数字btn
- (void)loadBtn {
    // 1 - 9 btn
    for (int i = 0; i < 9; i++) {
        CGFloat btnX = i%3 * self.btnWidth;
        CGFloat btnY = i/3 * self.btnHeight + self.btnHeight;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, self.btnWidth, self.btnHeight)];
        btn.tag = i + 1;
        [btn setTitle:[NSString stringWithFormat:@"%ld",(long)btn.tag] forState:UIControlStateNormal];
        btn.backgroundColor = self.btnColor;
        btn.layer.borderColor = self.boardLineColor;
        btn.layer.borderWidth = kBoardWidth;
        
        [btn addTarget:self action:@selector(clickNumber:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    //0 btn
    UIButton *zeroBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.btnWidth, self.btnHeight*4, self.btnWidth, self.btnHeight)];
    zeroBtn.tag = 0;
    [zeroBtn setTitle:@"0" forState:UIControlStateNormal];
    zeroBtn.backgroundColor = self.btnColor;
    zeroBtn.layer.borderColor = self.boardLineColor;
    zeroBtn.layer.borderWidth = kBoardWidth;
    [zeroBtn addTarget:self action:@selector(clickNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:zeroBtn];
    
    //小数点 btn
    UIButton *pointBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.btnWidth*2, self.btnHeight*4, self.btnWidth, self.btnHeight)];
    pointBtn.tag = 99;
    [pointBtn setTitle:@"." forState:UIControlStateNormal];
    pointBtn.backgroundColor = self.btnColor;
    pointBtn.layer.borderColor = self.boardLineColor;
    pointBtn.layer.borderWidth = kBoardWidth;
    [pointBtn addTarget:self action:@selector(clickNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pointBtn];

    //重置 btn
    UIButton *resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.btnHeight*4, self.btnWidth, self.btnHeight)];
    [resetBtn setTitle:@"C" forState:UIControlStateNormal];
    resetBtn.backgroundColor = self.btnColor;
    resetBtn.layer.borderColor = self.boardLineColor;
    resetBtn.layer.borderWidth = kBoardWidth;
    [resetBtn addTarget:self action:@selector(resetZero) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:resetBtn];
  
    
    //DEL btn
    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.btnWidth*3, self.btnHeight, self.btnWidth, self.btnHeight)];
    [delBtn setTitle:@"DEL" forState:UIControlStateNormal];
    delBtn.backgroundColor = self.btnColor;
    delBtn.layer.borderColor = self.boardLineColor;
    delBtn.layer.borderWidth = kBoardWidth;
    [delBtn addTarget:self action:@selector(clickDel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delBtn];
    
    //ok btn
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.btnWidth*3, self.btnHeight*3, self.btnWidth, self.btnHeight*2)];
    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
    okBtn.backgroundColor = self.btnColor;
    okBtn.layer.borderColor = self.boardLineColor;
    okBtn.layer.borderWidth = kBoardWidth;
    [okBtn addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okBtn];
    
    
    
    [self addSubview:self.addBtn];
    [self addSubview:self.resultLab];

}

//点击数字按键
- (void)clickNumber:(UIButton*)btn {
    
    if(self.addBtn.isSelected){
        self.nValue = @"";
    }
    NSString *currentValue = @"";
    if (btn.tag == 99) {
        //有 . 就不加 .
        if ([self.nValue rangeOfString:@"."].location == NSNotFound) {
            currentValue = @".";
        }
    }else {
        currentValue = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    }

    self.nValue = [self.nValue stringByAppendingString:currentValue];
  
    
    //保留小数点后两位
    NSRange pointRange = [self.nValue rangeOfString:@"."];
    if (pointRange.location != NSNotFound) {
        if ([self.nValue substringFromIndex:pointRange.location+1].length > 2) {
            self.nValue = [self.nValue substringWithRange:NSMakeRange(0, pointRange.location + 3)];
        }
        
        //总位数不超过9 处理小数部分
        if ([self.nValue substringToIndex:pointRange.location].length > kMaxCalCount) {
            self.nValue = [NSString stringWithFormat:@"%0.2f",[self.nValue doubleValue]];
            self.nValue = [self.nValue substringToIndex:kMaxCalCount+3];
        }

    } else {
        //总位数不超过9 整数部分
        self.nValue = [NSString stringWithFormat:@"%@",@([self.nValue doubleValue])];
        if (self.nValue.length > kMaxCalCount) {
            self.nValue = [NSString stringWithFormat:@"%0.2f",[self.nValue doubleValue]];
            if ([self.nValue doubleValue] > 0) {

                self.nValue = [self.nValue substringToIndex:kMaxCalCount];
            } else {
                self.nValue = @"0";
            }
        }
    }

    //显示数字
    self.resultLab.text = [NSString stringWithFormat:@"¥ %.2f",[self.nValue doubleValue]];
    self.addBtn.selected = NO;
    
    NSLog(@"new = %@",self.nValue);
}

//单击加号
- (void)clickAdd {
    //显示结果  点击后nValue清零
    if (!self.addBtn.isSelected) {
        self.addBtn.selected = YES;
        double result = [self.resutlStr doubleValue] + [self.nValue doubleValue] ;
        self.resutlStr = [NSString stringWithFormat:@"%.2f",result];
        self.resultLab.text = [NSString stringWithFormat:@"¥ %.2f",[self.resutlStr doubleValue]];
        NSLog(@"resutl = %@",self.resutlStr);
    }
    
}

//重置0
- (void)resetZero {
    self.resutlStr = @"";
    self.nValue = @"";
    self.resultLab.text = @"¥ 0.00";
}

//退格
- (void)clickDel {
    self.nValue = [NSString stringWithFormat:@"%@",@([self.nValue doubleValue])];

    if (self.nValue.length > 0) {
        self.nValue = [self.nValue substringWithRange:NSMakeRange(0, self.nValue.length-1)];
    }
    NSLog(@"-----%@",self.nValue);
    self.resultLab.text = [NSString stringWithFormat:@"¥ %.2f",[self.nValue doubleValue]];
}
//完成
- (void)clickOk {
    //存在 使用修改保存方式 不存在 使用新增保存方式
    if (self.isTallyExist) {
        [self modifyTallySavedWithIdentity:self.tallyIdentity];
    } else {
        [self addTallySave];
    }
}

//增加账单保存
- (void)addTallySave {
    if ( ![self.typeLab.text isEqualToString:@""] && [self.nValue doubleValue] != 0) {
        [self clickAdd];
        //存数据
        NSManagedObjectContext *managedObjectContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).persistentContainer.viewContext;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        //查询有无对应的date 有则使用无则创建
        NSFetchRequest *fdate = [TallyDate fetchRequest];
        NSArray<NSSortDescriptor *> *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
        fdate.sortDescriptors = sortDescriptors;
        NSPredicate *p = [NSPredicate predicateWithFormat:@"date = %@",dateString];
        fdate.predicate = p;
        NSArray<TallyDate *> *ss = [managedObjectContext executeFetchRequest:fdate error:nil];
        TallyDate *date;
        if (ss.count > 0) {
            date = ss[0];
        } else {
            date = [[TallyDate alloc] initWithContext:managedObjectContext];
            date.date = dateString;
        }
        //配置数据
        Tally *model = [[Tally alloc] initWithContext:managedObjectContext];
        NSFetchRequest *ftype = [TallyType fetchRequest];
        NSPredicate *ptype = [NSPredicate predicateWithFormat:@"typename = %@",self.typeLab.text];
        ftype.predicate = ptype;
        NSArray<TallyType *> *sstype = [managedObjectContext executeFetchRequest:ftype error:nil];
        TallyType *type = [sstype firstObject];
        //给关系赋值
        model.typeship = type;
        model.dateship = date;
        model.identity = [NSString stringWithFormat:@"%@", [model objectID]];
        model.timestamp = [NSDate date];
        if ([self.typeLab.text isEqualToString:@"工资"]) {
            model.income = [self.resutlStr doubleValue];
            model.expenses = 0;
        } else {
            model.expenses = [self.resutlStr doubleValue];
            model.income = 0;
        }
        //存
        [managedObjectContext save:nil];
        if ([self.delegate respondsToSelector:@selector(tallySaveCompleted)]) {
            [self.delegate tallySaveCompleted];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(tallySaveFailed)]) {
            [self.delegate tallySaveFailed];
        }
        NSLog(@"不存");
    }
}

//修改账单保存
- (void)modifyTallySavedWithIdentity:(NSString *)identity {
    [self clickAdd];
       if ([self.resutlStr doubleValue] == 0) {
        if ([self.delegate respondsToSelector:@selector(tallySaveFailed)]) {
            [self.delegate tallySaveFailed];
        }
        NSLog(@"不存");
        return;
    }
    self.addBtn.selected = NO;

    TallyType *type = [[CoreDataOperations sharedInstance] getTallyTypeWithTypeName:self.typeLab.text];

    //配置当前账单
    Tally *tally = [[CoreDataOperations sharedInstance] getTallyWithIdentity:identity];
    tally.typeship = type;
    if ([self.typeLab.text isEqualToString:@"工资"]) {
        tally.income = [self.resutlStr doubleValue];
        tally.expenses = 0;
    } else {
        tally.expenses = [self.resutlStr doubleValue];
        tally.income = 0;
    }
    [[CoreDataOperations sharedInstance] saveTally];
    if ([self.delegate respondsToSelector:@selector(tallySaveCompleted)]) {
        [self.delegate tallySaveCompleted];
    }
}


//修改界面传值
- (void)modifyTallyWithIdentity:(NSString *)identity {
    self.tallyIdentity = identity;
    Tally *tally = [[CoreDataOperations sharedInstance] getTallyWithIdentity:identity];
    self.imageView.image = [UIImage imageNamed:tally.typeship.typeicon];
    self.typeLab.text = tally.typeship.typename;
    self.nValue = tally.income > 0?[NSString stringWithFormat:@"%@",@(tally.income)]:[NSString stringWithFormat:@"%@",@(tally.expenses)];
    self.resultLab.text = [NSString stringWithFormat:@"¥ %.2f",[self.nValue doubleValue]];
    self.isTallyExist = YES;
}

@end
