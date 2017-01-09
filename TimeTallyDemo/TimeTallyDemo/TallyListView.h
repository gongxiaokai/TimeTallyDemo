//
//  TallyListView.h
//  TimeTallyDemo
//
//  Created by gongwenkai on 2017/1/5.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TallyListCell.h"
#import <CoreData/CoreData.h>
#import "TimeTallyDemo+CoreDataModel.h"
#import "AppDelegate.h"
#import "CoreDataOperations.h"
@protocol TallyListViewDelegate <NSObject>
//选择对应cell 传递 image title cell的实际位置
- (void)didSelectItem:(UIImage*)cellImage andTitle:(NSString*)title withRectInCollection:(CGRect)itemRect;
//滚动到底
- (void)listScrollToBottom;
@end


@interface TallyListView : UICollectionView
@property(nonatomic,strong)id<TallyListViewDelegate> customDelegate;

@end
