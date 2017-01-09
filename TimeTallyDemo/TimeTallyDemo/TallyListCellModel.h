//
//  TallyListCellModel.h
//  TimeTallyDemo
//
//  Created by gongwenkai on 2017/1/5.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TallyListCellModel : NSObject
@property (nonatomic,copy)NSString *tallyCellImage;
@property (nonatomic,copy)NSString *tallyCellName;

- (instancetype)initWithDict:(NSDictionary*)dict;
+ (instancetype)tallyListCellModelWithDict:(NSDictionary*)dict;

@end
