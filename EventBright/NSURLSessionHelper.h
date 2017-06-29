//
//  NSURLSessionHelper.h
//  EventBright
//
//  Created by Kevin Cleathero on 2017-06-28.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventBright-Swift.h"
//#import "EventBright-Swift.h"

@interface NSURLSessionHelper : NSObject

+ (void)fetchEventDetailsWith:(NSMutableArray *)eventIds eventobject:(EventModel *)eventObject eventobjects:(NSMutableArray *)eventobjects;

+ (void)fetchEventIDWithin:(NSString *)locationRadius latitude:(NSString *)lat longitude:(NSString *)lon
                     price:(NSString *)price startdate:(NSString *)startdate events:(NSMutableArray *)eventIds
              eventobjects:(NSMutableArray *)eventobjects;


@end
