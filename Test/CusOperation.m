//
//  CusOperation.m
//  TestOperatio
//
//  Created by Bloveocean on 2018/2/26.
//  Copyright © 2018年 tpf. All rights reserved.
//

#import "CusOperation.h"

@interface CusOperation ()
@property (nonatomic, assign) BOOL opExecuting;
@property (nonatomic, assign) BOOL opFinished;
@end

@implementation CusOperation

- (id)init {
    if (self = [super init]) {
        _opExecuting = false;
        _opFinished = false;
    }
    return self;
}

- (BOOL)isExecuting {
    return _opExecuting;
}

- (BOOL)isFinished {
    return _opFinished;
}

- (void)start {
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"finished"];
        _opFinished = true;
        [self didChangeValueForKey:@"finished"];
        return;
    }
    
    [self willChangeValueForKey:@"executing"];
    _opExecuting = true;
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    [self didChangeValueForKey:@"executing"];
}

- (void)main {
    @try {
        @autoreleasepool {
            self.executeBlock();
        }
    } @catch (NSException *exception) {
    } @finally {
    }
}

- (void)operationFinished {
    [self willChangeValueForKey:@"finished"];
    [self willChangeValueForKey:@"executing"];
    
    _opFinished = true;
    _opExecuting = false;
    
    [self didChangeValueForKey:@"finished"];
    [self didChangeValueForKey:@"executing"];
}

@end
