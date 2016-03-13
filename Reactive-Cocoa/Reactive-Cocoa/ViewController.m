//
//  ViewController.m
//  Reactive-Cocoa
//
//  Created by 王建伟 on 16/3/10.
//  Copyright © 2016年 李洋. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // 与MVVM一起结合使用
    
    
#pragma mark  ----  代理
    [self.username.rac_textSignal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
    }];
    
    
#pragma mark  ----  过滤 一个signal（信号）对应一个subscribeNext（接受者）
    [[self.username.rac_textSignal filter:^BOOL(id value) {
        
        // 过滤条件
        NSString *string = value;
        return string.length > 3;
    }] subscribeNext:^(id x) {
//        NSLog(@"%@",x);
    }];
    
    
#pragma mark  ----  映射
    [[[self.username.rac_textSignal map:^id(id value) {
        
        NSString *string = value;
        return @(string.length);
    }] filter:^BOOL(id value) {
        
        NSNumber *number = value;
        return [number integerValue] > 3;
    }] subscribeNext:^(id x) {
        
//        NSLog(@"%@",x);
    }];
    
    
 
#pragma mark  ----  一组事件处理
    RACSequence *sequence = [@[@"you",@"are",@"my",@"destiny"] rac_sequence];
    RACSignal *signal = [sequence signal];
    
    // 将上面多组字符串首字母大写
    [[signal map:^id(id value) {
        
        NSString *string = value;
        return [string capitalizedString];
    }] subscribeNext:^(id x) {
        
//        NSLog(@"%@",x);
    }];
    
    
#pragma mark  ----  自定义信号
    // 1.关键字（RACSubject）
    RACSubject *liyang = [RACSubject subject];
    RACSubject *kaka = [RACSubject subject];
    RACSubject *signalOfSignal = [RACSubject subject];
    
    // 2.开关是怎么设置的
    RACSignal *switchSignal = [signalOfSignal switchToLatest];
    [switchSignal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
    }];
    
    // 3.为信号添加数据
    [signalOfSignal sendNext:liyang];
    [liyang sendNext:@"李洋"];
    
    [signalOfSignal sendNext:kaka];
    [kaka sendNext:@"卡卡"];
    
    
#pragma mark  ----  广播/通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"hello" object:nil] subscribeNext:^(id x) {
        
        NSNotification *note = x;
        NSLog(@"技巧 : %@",note.userInfo[@"找工作技巧"]);
        
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hello" object:nil userInfo:@{@"找工作技巧":@"出去面试"}];
    
    
    
    
    
    
    

}






@end
