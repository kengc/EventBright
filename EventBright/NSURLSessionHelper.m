//
//  NSURLSessionHelper.m
//  EventBright
//
//  Created by Kevin Cleathero on 2017-06-28.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//
#import "NSURLSessionHelper.h"
#import "MapViewController.h"
//#import "EventsModel.swift"
//#import "EventsModel.swift"
//#import "EventBright-Swift.h"
@interface NSURLSessionHelper ()
//@property (nonatomic) EventModel *eventObject;
@end
@implementation NSURLSessionHelper
+ (void)fetchEventCategories:(NSMutableDictionary *)categoriesDict {
    
    //https://www.eventbriteapi.com/v3/categories/?token=CNEQ55J3IRHNX3EGO6DX
    
    
    NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:@"token" value:@"CNEQ55J3IRHNX3EGO6DX"];
    
    NSArray *queryItems = [[NSArray alloc] initWithObjects:queryItem, nil];
    
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"www.eventbriteapi.com";
    components.path = @"/v3/categories/";
    components.queryItems = queryItems;
    NSURL *url = components.URL;
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error){
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        NSDictionary *categoryDict = results[@"categories"];
        
        NSLog(@"eventDetails: %@", categoryDict);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for(NSDictionary *catDic in categoryDict){
                
                NSString *category;
                NSString *catID;
                if ([catDic objectForKey:@"longitude"] != [NSNull null]) {
                    category = catDic[@"short_name"];
                    catID = catDic[@"id"];
                }
                [categoriesDict setObject:catID forKey:category];
            }
            NSLog(@"categories: %@", categoriesDict);
            
        });
        
    }];
    
    [dataTask resume];
}
+ (void)fetchEventIDWithin:(NSString *)locationRadius latitude:(NSString *)lat longitude:(NSString *)lon
                     price:(NSString *)price startdate:(NSString *)startdate events:(NSMutableArray *)eventIds
              eventobjects:(NSMutableArray *)eventobjects categoryId:(NSString *)catId city:(NSString *)city{
    
    [eventobjects removeAllObjects];
    [eventIds removeAllObjects];
    
    //https://www.eventbriteapi.com/v3/events/search/?token=CNEQ55J3IRHNX3EGO6DX
    
    // /v3/events/search/?location.within=1km&location.latitude=+49.281916&location.longitude=-123.108317&price=free&start_date.keyword=next_month&token=CNEQ55J3IRHNX3EGO6DX
    
    //https://www.eventbriteapi.com/v3/events/search/?location.within=5km&location.latitude=+49.281916&location.longitude=-123.108317&price=free&start_date.range_start=2017-06-30T14:46:12&token=CNEQ55J3IRHNX3EGO6DX&expand=venue
    
    NSMutableArray *queryItems = [[NSMutableArray alloc] init];
    if(!([locationRadius length] == 0)){
        NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:@"location.within" value:locationRadius]; //in kms
        [queryItems addObject:queryItem];
    }
    if(!([city length] == 0)){
        NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:@"location.address" value:city]; //city name
        [queryItems addObject:queryItem];
    }
    if(!([lat length] == 0)){
        NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:@"location.latitude" value:lat];
        [queryItems addObject:queryItem];
    }
    if(!([lon length] == 0)){
        NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:@"location.longitude" value:lon];
        [queryItems addObject:queryItem];
    }
    if(!([catId length] == 0)){
        NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:@"categories" value:catId];
        [queryItems addObject:queryItem];
    }
    if(!([price length] == 0)){
        NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:@"price" value:price];
        [queryItems addObject:queryItem];
    }
    if(!([startdate length] == 0)){
        NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:@"start_date.range_start" value:startdate];
        [queryItems addObject:queryItem];
    }
    
    
    
    NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:@"token" value:@"CNEQ55J3IRHNX3EGO6DX"];
    [queryItems addObject:queryItem];
    
    NSURLQueryItem *queryItem2 = [[NSURLQueryItem alloc] initWithName:@"expand" value:@"venue"];
    [queryItems addObject:queryItem2];
    
//    NSURLQueryItem *queryItem3 = [[NSURLQueryItem alloc] initWithName:@"sort_by" value:@"distance"];
//    [queryItems addObject:queryItem3];
    
    //    NSArray *queryItems = [[NSArray alloc] initWithObjects:queryItem, queryItem2, queryItem3,queryItem4,queryItem5,queryItem6,
    //                           queryItem7, queryItem8, queryItem9, nil];
    
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"www.eventbriteapi.com";
    components.path = @"/v3/events/search/";
    components.queryItems = queryItems;
    NSURL *url = components.URL;
    
    //https://www.eventbriteapi.com/v3/events/search/?sort_by=distance&location.address=Seattle&location.within=100km&price=free&start_date.range_start=2017-06-30T23%3A19%3A12&token=CNEQ55J3IRHNX3EGO6DX
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSLog(@"%@", url);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error){
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *eventDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if(jsonError){
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        NSDictionary *eventsForLocal = eventDict[@"events"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // [collectionView reloadData];
            for(NSDictionary *event in eventsForLocal){
                
                EventModel *modelObject = [[EventModel alloc] init];
                
                NSDictionary *venueDetails;
                
                //event info
                if ([event objectForKey:@"name"] != [NSNull null]) {
                    NSLog(@"eventName");
                    modelObject.eventName = event[@"name"][@"text"];
                }
                
                if ([event objectForKey:@"url"] != [NSNull null]) {
                    NSLog(@"url");
                    modelObject.eventurl = event[@"url"];
                }
                
                if ([event objectForKey:@"venue"] != [NSNull null]) {
                    NSLog(@"venueDetails");
                    venueDetails = event[@"venue"][@"address"];
                    
                    NSDictionary *vn = event[@"venue"];
                    if ([vn objectForKey:@"name"] != [NSNull null]) {
                        NSLog(@"venueName");
                        modelObject.venueName = vn[@"name"];
                    }
                    
                }
                
                if ([venueDetails objectForKey:@"latitude"] != [NSNull null]) {
                    NSLog(@"latCoordinate");
                    modelObject.latCoordinate = venueDetails[@"latitude"];
                }
                
                if ([venueDetails objectForKey:@"longitude"] != [NSNull null]) {
                    NSLog(@"lonCoordinate");
                    modelObject.lonCoordinate = venueDetails[@"longitude"];
                }
                
                if ([venueDetails objectForKey:@"city"] != [NSNull null]) {
                    NSLog(@"city");
                    modelObject.city = venueDetails[@"city"];
                }
                
                if ([venueDetails objectForKey:@"region"] != [NSNull null]) {
                    NSLog(@"region");
                    modelObject.region = venueDetails[@"region"];
                }
                
                if ([venueDetails objectForKey:@"country"] != [NSNull null]) {
                    NSLog(@"country");
                    modelObject.country = venueDetails[@"country"];
                }
                
                if ([venueDetails objectForKey:@"localized_address_display"] != [NSNull null]) {
                    NSLog(@"address");
                    modelObject.address = venueDetails[@"localized_address_display"];
                }
                
                [eventobjects addObject:modelObject];
                
                //NSLog(@"eventobjects: %lu", (unsigned long)eventobjects.count);
                //NSLog(@"eventobj lat%@",[eventobjects[0] latCoordinate]);
                
                //[eventIds addObject:venueID];
            }
            
            NSLog(@"eventids: %lu", (unsigned long)eventIds.count);
            NSDictionary *dict = [NSDictionary dictionaryWithObject:eventobjects forKey:@"Data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DataDownloaded" object:self userInfo:dict];
        });
    }];
    [dataTask resume];
}
@end
