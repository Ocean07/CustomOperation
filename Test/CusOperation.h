//
//  CusOperation.h
//  TestOperatio
//
//  Created by Bloveocean on 2018/2/26.
//  Copyright © 2018年 tpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CusOperation : NSOperation

@property (nonatomic, copy) dispatch_block_t executeBlock;

- (void)operationFinished;

@end
