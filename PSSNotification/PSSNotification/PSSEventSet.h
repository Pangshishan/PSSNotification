//
//  PSSEventSet.h
//  PSSNotification
//
//  Created by 泡泡 on 2018/11/13.
//  Copyright © 2018 泡泡. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PSSBlockObject;
@interface PSSEventSet : NSObject

@property (nonatomic, strong) NSMutableArray<PSSBlockObject *> *blockObjectArray;

@end
