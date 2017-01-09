//
//  TallyListView.m
//  TimeTallyDemo
//
//  Created by gongwenkai on 2017/1/5.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import "TallyListView.h"
@interface TallyListView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *tallyListArray;
@property (nonatomic, assign) CGFloat offsety;

@end
static NSString *cellId = @"tallyListCellID";
@implementation TallyListView

//读取plist数据
- (NSArray *)tallyListArray {
    if (!_tallyListArray) {
        NSMutableArray *res = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TallyList" ofType:@"plist"];
        NSArray *list = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dict in list) {
            TallyListCellModel *model = [TallyListCellModel tallyListCellModelWithDict:dict];
            [res addObject:model];
        }
        _tallyListArray = [NSArray arrayWithArray:res];
        [self writeToSqlite];
    }
    return  _tallyListArray;
}

- (void)writeToSqlite {
    
    //将类型名字和图片信息写入数据库
    
    for (TallyListCellModel *model in self.tallyListArray) {
        //查询有无对应的type 有则使用无则创建
        TallyType *ssr = [[CoreDataOperations sharedInstance] getTallyTypeWithTypeName:model.tallyCellName];
        if (ssr == nil) {
            TallyType *type = [[TallyType alloc] initWithContext:[CoreDataOperations sharedInstance].managedObjectContext];
            type.typename = model.tallyCellName;
            type.typeicon = model.tallyCellImage;
            [[CoreDataOperations sharedInstance] saveTally];
        }

    }
}

//初始化
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        [self registerNib:[UINib nibWithNibName:@"TallyListCell" bundle:nil] forCellWithReuseIdentifier:cellId];
        
        
        
    }
    return self;
}


#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tallyListArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TallyListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.cellModel = self.tallyListArray[indexPath.item];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TallyListCell *cell = (TallyListCell*)[collectionView cellForItemAtIndexPath:indexPath];
    //cell在collectionView的位置
    CGRect cellRect = [collectionView convertRect:cell.frame fromView:collectionView];
    //image在cell中的位置
    CGRect imgInCellRect = cell.imageView.frame;
    CGFloat x = cellRect.origin.x + imgInCellRect.origin.x;
    CGFloat y = cellRect.origin.y + imgInCellRect.origin.y + 64 - self.offsety;
    //图片在collectionView的位置
    CGRect imgRect = CGRectMake(x, y, imgInCellRect.size.width, imgInCellRect.size.height);
    //回调
    if ([self.customDelegate respondsToSelector:@selector(didSelectItem:andTitle:withRectInCollection:)]){
        [self.customDelegate didSelectItem:cell.imageView.image andTitle:cell.imageLab.text withRectInCollection:imgRect];
    }
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.offsety = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat bottomY = self.contentSize.height - self.frame.size.height;
    if (scrollView.contentOffset.y >= bottomY) {
        NSLog(@"计算器下去");
        if ([self.customDelegate respondsToSelector:@selector(listScrollToBottom)]) {
            [self.customDelegate listScrollToBottom];
        }
    }
}


@end
