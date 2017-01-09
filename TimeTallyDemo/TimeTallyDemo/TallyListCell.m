//
//  TallyListCell.m
//  TimeTallyDemo
//
//  Created by gongwenkai on 2017/1/5.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import "TallyListCell.h"

@implementation TallyListCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setCellModel:(TallyListCellModel *)cellModel {
    _cellModel = cellModel;
    _imageLab.text = cellModel.tallyCellName;
    _imageView.image = [UIImage imageNamed:cellModel.tallyCellImage];
}


@end
