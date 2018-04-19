//
//  JPPhotoOperation.m
//  JPPhotoChooseBrowserDemo
//
//  Created by baiyi on 2018/4/19.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "JPPhotoOperation.h"


@interface JPPhotoOperation()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;
/** block */
@property(nonatomic,copy) GetFullScreenImageBlock finishedBlock;
/** model */
@property(nonatomic,strong) JPPhotoModel *model;

@end

@implementation JPPhotoOperation

@synthesize finished = _finished;
@synthesize executing = _executing;


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _executing = NO;
        _finished  = NO;
    }
    return self;
}


+ (instancetype)addOperationWithModel:(JPPhotoModel *)model completeBlock:(id)completeBlock {
    
    JPPhotoOperation *op = [[JPPhotoOperation alloc] init];
    op.model = model;
    op.finishedBlock = completeBlock;
    return op;
}


- (void)start {
    
    if ([self isCancelled]) {
        _finished = YES;
        return;
    }
    
    _executing = YES;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.model jp_FullScreenImageWithBlock:^(UIImage *fullScreenImage, BOOL isFull) {
            if (isFull) {
                self.finished = YES;
            }
            if (self.finishedBlock) {
                self.finishedBlock(fullScreenImage, isFull);
            }
        }];
    }];
    
}

#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}


@end
