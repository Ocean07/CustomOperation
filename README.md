# CustomOperation

依次执行队列中的异步任务，一个异步task完成之后才会进行下一个task

##向串行队列中添加异步任务，不控制

```Objective-C
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
```

运行情况：完成情况打印如下
>2019-09-03 07:23:54.805525+0800 Test[73606:5578284] start <br/>
>2019-09-03 07:23:57.886884+0800 Test[73606:5578440] complete -> 0 <br/>
>2019-09-03 07:23:57.887000+0800 Test[73606:5578443] complete -> 3 <br/>
>2019-09-03 07:23:57.887063+0800 Test[73606:5578465] complete -> 4 <br/>
>2019-09-03 07:23:57.887080+0800 Test[73606:5578466] complete -> 5 <br/>
>2019-09-03 07:23:57.887164+0800 Test[73606:5578468] complete -> 7 <br/>
>2019-09-03 07:23:57.887164+0800 Test[73606:5578467] complete -> 6 <br/>
>2019-09-03 07:23:57.887239+0800 Test[73606:5578469] complete -> 8 <br/>
>2019-09-03 07:23:57.886928+0800 Test[73606:5578441] complete -> 2 <br/>
>2019-09-03 07:23:57.887322+0800 Test[73606:5578470] complete -> 9 <br/>
>2019-09-03 07:23:58.143936+0800 Test[73606:5578442] complete -> 1 <br/>

##向串行队列中添加异步任务，控制完成情况

```Objective-C
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
```

运行情况：一个task完成之后才会开始下一个
>2019-09-03 07:29:27.446498+0800 Test[73735:5581333] cust complete -> 0 <br/>
2019-09-03 07:29:30.449199+0800 Test[73735:5581333] cust complete -> 1 <br/>
2019-09-03 07:29:33.541758+0800 Test[73735:5581332] cust complete -> 2 <br/>
2019-09-03 07:29:36.641697+0800 Test[73735:5581332] cust complete -> 3 <br/>
2019-09-03 07:29:39.712813+0800 Test[73735:5581332] cust complete -> 4 <br/>
2019-09-03 07:29:42.779760+0800 Test[73735:5581333] cust complete -> 5 <br/>
2019-09-03 07:29:45.879497+0800 Test[73735:5581334] cust complete -> 6 <br/>
2019-09-03 07:29:48.958792+0800 Test[73735:5581334] cust complete -> 7 <br/>
2019-09-03 07:29:52.047463+0800 Test[73735:5581334] cust complete -> 8 <br/>
2019-09-03 07:29:55.113749+0800 Test[73735:5581333] cust complete -> 9 <br/>
