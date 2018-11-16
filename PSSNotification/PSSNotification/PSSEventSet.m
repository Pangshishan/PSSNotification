//
//  PSSEventSet.m
//  PSSNotification
//
//  Created by 泡泡 on 2018/11/13.
//  Copyright © 2018 泡泡. All rights reserved.
//

#import "PSSEventSet.h"
#import "PSSBlockObject.h"
#import "PSSNotificationCenter.h"

@implementation PSSEventSet

- (NSMutableArray<PSSBlockObject *> *)blockObjectArray {
    if (_blockObjectArray == nil) {
        _blockObjectArray = [[NSMutableArray alloc] init];
    }
    return _blockObjectArray;
}

- (void)dealloc {
    //NSLog(@"EventSet 被销毁了");
    [[PSSNotificationCenter defaultCenter] removeObserverByEventSet:self];
}

@end
