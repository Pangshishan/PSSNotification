//
//  PSSBlockObject.h
//  PSSNotification
//
//  Created by 泡泡 on 2018/11/13.
//  Copyright © 2018 泡泡. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PSSNotiEvent)(id info);

@interface PSSBlockObject : NSObject

@property (nonatomic, copy) PSSNotiEvent eventHandler;

@end
