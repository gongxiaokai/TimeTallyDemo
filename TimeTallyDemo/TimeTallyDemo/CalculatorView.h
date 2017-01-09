//
//  CalculatorView.h
//  TimeTallyDemo
//
//  Created by gongwenkai on 2017/1/5.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataOperations.h"
typedef void(^PositionInViewBlock)(CGPoint point);


@protocol CalculatorViewDelegate <NSObject>

//保存成功
- (void)tallySaveCompleted;

//保存失败
- (void)tallySaveFailed;

//回到原来的位置
- (void)backPositionWithAnimation;

@end

@interface CalculatorView : UIView
//类型图片的size
@property(nonatomic,assign)CGSize imageViewSize;
//类型图
@property(nonatomic,strong)UIImage *image;
//类型名
@property(nonatomic,strong)NSString *typeName;
//账单是否存在 判断 是修改还是新增
@property(nonatomic,assign)BOOL isTallyExist;
@property(nonatomic,strong)id<CalculatorViewDelegate> delegate;
//回调image在整个view中的位置
@property(nonatomic,copy)PositionInViewBlock positionInViewBlock;
//修改账单界面进入时传入参数
- (void)modifyTallyWithIdentity:(NSString *)identity;
@end
