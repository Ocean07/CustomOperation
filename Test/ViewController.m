//
//  ViewController.m
//  Test
//
//  Created by Bloveocean on 2019/8/27.
//  Copyright © 2019 Auth. All rights reserved.
//

#import "ViewController.h"
#import "CusOperation.h"

@interface ViewController ()

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount = 1;
    
    [self addOperations];
    
    [self addCustomOperations];
}

- (void)addOperations {
    
    NSLog(@"start");
    for (NSInteger i = 0; i < 10; i ++) {
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            // 执行异步耗时任务（网络请求）
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [NSThread sleepForTimeInterval:3];
                NSLog(@"complete -> %ld", (long)i);
            });
        }];
        
        [self.queue addOperation:op];
    }
}

- (void)addCustomOperations {
    for (NSInteger i = 0; i < 10; i ++) {
        CusOperation *op = [[CusOperation alloc] init];
        __weak typeof(op) weakOp = op;
        op.executeBlock = ^{
            __strong typeof(weakOp) strongOp = weakOp;
            // 执行异步耗时任务（网络请求）
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [NSThread sleepForTimeInterval:3];
                NSLog(@"cust complete -> %ld", (long)i);
                [strongOp operationFinished];
            });
        };
        
        [self.queue addOperation:op];
    }
}

@end
