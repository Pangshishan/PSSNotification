//
//  NSObject+PSSNotification.m
//  PSSNotification
//
//  Created by 泡泡 on 2018/11/13.
//  Copyright © 2018 泡泡. All rights reserved.
//

#import "NSObject+PSSNotification.h"
#import "PSSEventSet.h"
#import <objc/runtime.h>

static char PSSEventSetKey;

@implementation NSObject (PSSNotification)

- (void)setEventSet:(PSSEventSet *)eventSet {
    objc_setAssociatedObject(self, &PSSEventSetKey, eventSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (PSSEventSet *)eventSet {
    PSSEventSet *eventSet = objc_getAssociatedObject(self, &PSSEventSetKey);
    if (!eventSet) {
        eventSet = [[PSSEventSet alloc] init];
        [self setEventSet:eventSet];
    }
    return eventSet;
}

@end














