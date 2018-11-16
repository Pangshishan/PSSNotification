//
//  PSSNotificationCenter.m
//  PSSNotification
//
//  Created by 泡泡 on 2018/11/13.
//  Copyright © 2018 泡泡. All rights reserved.
//

#import "PSSNotificationCenter.h"
#import "PSSEventSet.h"
#import "NSObject+PSSNotification.h"

#define pss_dispatch_queue_main_async_safe(block)\
if ([[NSThread currentThread] isMainThread]) {\
    block();\
} else {\
    dispatch_sync(dispatch_get_main_queue(), block);\
}

@interface PSSNotificationCenter ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMapTable<NSString *, PSSEventSet *> *> *eventDict;

@end

@implementation PSSNotificationCenter

+ (instancetype)defaultCenter {
    static PSSNotificationCenter *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

- (void)addEvent:(PSSNotiEvent)event observer:(NSObject *)observer {
    [self addEvent:event eventName:kDefaultNotificationName observer:observer];
}
- (void)addEvent:(PSSNotiEvent)event eventName:(NSString *)eventName observer:(NSObject *)observer {
    if (!event) {
        return;
    }
    if (!observer) {
        return;
    }
    if (!eventName.length) {
        eventName = kDefaultNotificationName;
    }
    pss_dispatch_queue_main_async_safe((^{
        NSString *observerKey = [NSString stringWithFormat:@"%p", observer.eventSet];
        NSMapTable *notiDict = self.eventDict[eventName];
        if (!notiDict) {
            notiDict = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSPointerFunctionsWeakMemory];
            [self.eventDict setValue:notiDict forKey:eventName];
        }
        PSSEventSet *eventSet = [notiDict objectForKey:observerKey];
        if (!eventSet) {
            eventSet = observer.eventSet;
            [notiDict setObject:eventSet forKey:observerKey];
        }
        PSSBlockObject *blockObj = [[PSSBlockObject alloc] init];
        blockObj.eventHandler = event;
        [eventSet.blockObjectArray addObject:blockObj];
    }));
}
- (void)postDefaultNotification:(id)info {
    [self postNotificationByName:kDefaultNotificationName info:info];
}
- (void)postNotificationByName:(NSString *)name info:(id)info {
    pss_dispatch_queue_main_async_safe(^{
        NSMapTable *notiDict = [self.eventDict valueForKey:name];
        if (!notiDict) {
            return;
        }
        for (NSString *obsKey in notiDict) {
            PSSEventSet *eventSet = [notiDict objectForKey:obsKey];
            for (PSSBlockObject *blockObj in eventSet.blockObjectArray) {
                blockObj.eventHandler(info);
            }
        }
    });
}
/// 移出对应通知事件
- (void)removeNotificationName:(NSString *)name {
    pss_dispatch_queue_main_async_safe(^{
        NSMapTable *notiDict = [self.eventDict valueForKey:name];
        if (!notiDict) {
            return;
        }
        for (NSString *obserName in notiDict) {
            PSSEventSet *eventSet = [notiDict objectForKey:obserName];
            [eventSet.blockObjectArray removeAllObjects];
        }
        [self.eventDict removeObjectForKey:name];
    });
}
/// 移出所有通知下的 observer对应的事件（不给此observer发送事件了）
- (void)removeObserver:(NSObject *)observer {
    pss_dispatch_queue_main_async_safe((^{
        for (NSString *notiName in self.eventDict) {
            NSMapTable *notiDic = [self.eventDict valueForKey:notiName];
            if (!notiDic) {
                continue;
            }
            NSString *observerKey = [NSString stringWithFormat:@"%p", observer.eventSet];
            PSSEventSet *eventSet = [notiDic objectForKey:observerKey];
            if (!eventSet) {
                continue;
            }
            [eventSet.blockObjectArray removeAllObjects];
            [notiDic removeObjectForKey:observerKey];
        }
    }));
}
- (void)removeObserverByEventSet:(PSSEventSet *)eventSet {
    pss_dispatch_queue_main_async_safe((^{
        for (NSString *notiName in self.eventDict) {
            NSMapTable *notiDic = [self.eventDict valueForKey:notiName];
            if (!notiDic) {
                continue;
            }
            NSString *observerKey = [NSString stringWithFormat:@"%p", eventSet];
            PSSEventSet *eventSet = [notiDic objectForKey:observerKey];
            [notiDic removeObjectForKey:observerKey];
            if (!eventSet) {
                continue;
            }
            [eventSet.blockObjectArray removeAllObjects];
        }
    }));
}
/// 移出对应通知下，对应observer的事件

- (void)removeNotificationName:(NSString *)name observer:(NSObject *)observer {
    if (!name) {
        name = kDefaultNotificationName;
    }
    if (!observer) {
        return;
    }
    NSMapTable *notiDic = self.eventDict[name];
    if (!notiDic) {
        return;
    }
    pss_dispatch_queue_main_async_safe((^{
        NSString *obserKey = [NSString stringWithFormat:@"%p", observer.eventSet];
        PSSEventSet *eventSet = [notiDic objectForKey:obserKey];
        [eventSet.blockObjectArray removeAllObjects];
        [notiDic removeObjectForKey:obserKey];
    }));
}
/// 移出所有事件
- (void)removeAllNoti {
    pss_dispatch_queue_main_async_safe((^{
        for (NSString *notiName in self.eventDict) {
            NSMapTable *notiDict = [self.eventDict objectForKey:notiName];
            for (NSString *obserKey in notiDict) {
                PSSEventSet *eventSet = [notiDict objectForKey:obserKey];
                [eventSet.blockObjectArray removeAllObjects];
            }
        }
        [self.eventDict removeAllObjects];
    }));
}

#pragma mark - getter
- (NSMutableDictionary<NSString *,NSMapTable<NSString *,PSSEventSet *> *> *)eventDict {
    if (_eventDict == nil) {
        _eventDict = [NSMutableDictionary dictionary];
    }
    return _eventDict;
}


@end
