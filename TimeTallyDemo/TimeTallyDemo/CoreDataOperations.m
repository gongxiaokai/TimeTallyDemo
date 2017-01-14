//
//  CoreDataOperations.m
//  TimeTallyDemo
//
//  Created by gongwenkai on 2017/1/9.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import "CoreDataOperations.h"

@interface CoreDataOperations()
@end

@implementation CoreDataOperations

static CoreDataOperations *instance = nil;

+ (instancetype)sharedInstance
{
    return [[CoreDataOperations alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super init];
        if (instance) {
            instance.managedObjectContext = ((AppDelegate*)[UIApplication sharedApplication].delegate).persistentContainer.viewContext;
        }
    });
    return instance;
}

//从数据库中删除 Tally表中某一数据
- (void)deleteTally:(Tally*)object {
    [self.managedObjectContext deleteObject:object];
    [self saveTally];
}

//保存
- (void)saveTally {
    [self.managedObjectContext save:nil];
}

//读取对应字段
- (Tally*)getTallyWithIdentity:(NSString *)identity {
    //从数据库中删除 Tally表中对应identity字段行
    NSFetchRequest *fetchRequest = [Tally fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identity = %@", identity];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return [fetchedObjects firstObject];
}

//获取对应类型
- (TallyType*)getTallyTypeWithTypeName:(NSString*)typeName {
    //设置账单类型
    NSFetchRequest *ftype = [TallyType fetchRequest];
    NSPredicate *ptype = [NSPredicate predicateWithFormat:@"typename = %@",typeName];
    ftype.predicate = ptype;
    NSArray<TallyType *> *sstype = [self.managedObjectContext executeFetchRequest:ftype error:nil];
    return [sstype firstObject];
}

//读取数据库中的数据  以字典的形式 key：@"日期" object：[账单信息]
- (NSDictionary*)getAllDataWithDict{
    //先查询日期 遍历日期表
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TallyDate" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    NSError *error = nil;
    NSArray<TallyDate*> *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //再查询该日期下的tally表
    for (TallyDate *date in fetchedObjects) {
        NSString *key = date.date;
        NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Tally" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest2 setEntity:entity2];
        //在tally表中 筛选 为该日期的tally 并逆序排列
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateship.date = %@",key];
        [fetchRequest2 setPredicate:predicate];
        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
        [fetchRequest2 setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor2, nil]];
        NSError *error = nil;
        NSArray<Tally*> *fetchedObjects2 = [self.managedObjectContext executeFetchRequest:fetchRequest2 error:&error];
        NSMutableArray *array = [NSMutableArray array];
        //遍历 tally表 将表中的每个结果保存下来
        for (Tally *tally in fetchedObjects2) {
            TimeLineModel *model = [[TimeLineModel alloc] init];
            model.tallyDate = tally.dateship.date;
            model.tallyIconName = tally.typeship.typeicon;
            model.tallyMoney = tally.income > 0 ? tally.income:tally.expenses;
            model.tallyMoneyType = tally.income > 0 ? TallyMoneyTypeIn:TallyMoneyTypeOut;
            model.tallyType = tally.typeship.typename;
            model.identity = tally.identity;
            model.income = tally.income;
            model.expense = tally.expenses;
            [array addObject:model];
        }
        [dict setObject:array forKey:key];
    }
    return dict;
}




@end
