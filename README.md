# PSSNotification
> 仿NSNotificationCenter，实现全局通知，用法更简单，轻量级


** .h中暴露的方法 **
```Objective-C
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

```

## 实现原理及源代码

就像系统的NSNotificationCenter一样，我们也需要一个单利`PSSNotificationCenter`，然后说一说我们内存方案：
![内存](https://img-blog.csdnimg.cn/20181116181936270.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3BhbmdzaGlzaGFuMQ==,size_16,color_FFFFFF,t_70)
上图中的EventSet是通过运行时动态给VC1（也可以说是监听者，NSObject类型）添加的属性

**PSSNotificationCenter下有一个Dictionary，结构大致如下：**
```Objective-C
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMapTable<NSString *, PSSEventSet *> *> *eventDict;
```
```Objective-C
@{
      @"通知的名字_1": @{ // 这个字典是NSMapTable，可以对持有的Value弱引用
              @"观察者内存地址生成的字符串_1": PSSEventSet对象,
              @"观察者内存地址生成的字符串_2": PSSEventSet对象,
              },
      @"通知的名字_1": @{ // 这个字典是NSMapTable
              @"观察者内存地址生成的字符串_1": PSSEventSet对象,
              @"观察者内存地址生成的字符串_2": PSSEventSet对象,
              },
};
```

**NSMapTable：** 类似于字典，可以对value进行弱引用；

**PSSEventSet：** 动态添加给观察者的属性
```Objective-C
@interface PSSEventSet : NSObject
@property (nonatomic, strong) NSMutableArray<PSSBlockObject *> *blockObjectArray;
@end
```

**PSSBlockObject：** 用于持有block
```Objective-C
typedef void(^PSSNotiEvent)(id info);

@interface PSSBlockObject : NSObject

@property (nonatomic, copy) PSSNotiEvent eventHandler;

@end
```
