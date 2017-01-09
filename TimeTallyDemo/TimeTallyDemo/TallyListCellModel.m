//
//  TallyListCellModel.m
//  TimeTallyDemo
//
//  Created by gongwenkai on 2017/1/5.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import "TallyListCellModel.h"

@implementation TallyListCellModel


- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)tallyListCellModelWithDict:(NSDictionary*)dict {
    return [[TallyListCellModel alloc] initWithDict:dict];
}



@end
