//
//  TallyListCell.h
//  TimeTallyDemo
//
//  Created by gongwenkai on 2017/1/5.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TallyListCellModel.h"
@interface TallyListCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *imageLab;
@property (strong, nonatomic) TallyListCellModel *cellModel;


@end
