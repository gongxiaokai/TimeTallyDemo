//
//  TimeLineModel.h
//  TimeTallyDemo
//
//  Created by gongwenkai on 2017/1/6.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TallyMoneyTypeIn = 0,
    TallyMoneyTypeOut,
    
} TallyMoneyType;

@interface TimeLineModel : NSObject
@property(nonatomic,copy)NSString *tallyIconName;
@property(nonatomic,assign)double tallyMoney;
@property(nonatomic,assign)TallyMoneyType tallyMoneyType;
@property(nonatomic,copy)NSString *tallyDate;
@property(nonatomic,copy)NSString *tallyType;
@property(nonatomic,copy)NSString *identity;
@property(nonatomic,assign)double income;
@property(nonatomic,assign)double expense;

@end
