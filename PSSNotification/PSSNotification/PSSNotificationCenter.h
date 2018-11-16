//
//  PSSNotificationCenter.h
//  PSSNotification
//
//  Created by 泡泡 on 2018/11/13.
//  Copyright © 2018 泡泡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSSBlockObject.h"

#define kDefaultNotificationName @"PSSDefaultNotification"
@class PSSEventSet;
@interface PSSNotificationCenter : NSObject

+ (instancetype)defaultCenter;

- (void)addEvent:(PSSNotiEvent)event observer:(NSObject *)observer;
- (void)addEvent:(PSSNotiEvent)event eventName:(NSString *)eventName observer:(NSObject *)observer;

/// info: 传值
- (void)postNotificationByName:(NSString *)name info:(id)info;
- (void)postDefaultNotification:(id)info;
/// 移出对应通知事件
- (void)removeNotificationName:(NSString *)name;
/// 移出所有通知下的 observer对应的事件（不给此observer发送事件了）
- (void)removeObserver:(NSObject *)observer;
- (void)removeObserverByEventSet:(PSSEventSet *)eventSet;
/// 移出对应通知下，对应observer的事件
- (void)removeNotificationName:(NSString *)name observer:(NSObject *)observer;
/// 移出所有事件
- (void)removeAllNoti;

@end
