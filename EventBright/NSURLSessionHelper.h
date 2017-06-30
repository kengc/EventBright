//
//  NSURLSessionHelper.h
//  EventBright
//
//  Created by Kevin Cleathero on 2017-06-28.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventBright-Swift.h"

@interface NSURLSessionHelper : NSObject


+ (void)fetchEventCategories:(NSMutableDictionary *)categoriesDict;

+ (void)fetchEventIDWithin:(NSString *)locationRadius latitude:(NSString *)lat longitude:(NSString *)lon
                     price:(NSString *)price startdate:(NSString *)startdate events:(NSMutableArray *)eventIds
              eventobjects:(NSMutableArray *)eventobjects categoryId:(NSString *)catId city:(NSString *)city;

@end
