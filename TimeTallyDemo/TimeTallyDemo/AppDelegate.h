//
//  AppDelegate.h
//  TimeTallyDemo
//
//  Created by gongwenkai on 2017/1/4.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

