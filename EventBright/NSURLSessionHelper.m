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

+ (void)fetchEventDetailsWith:(NSMutableArray *)eventIds eventobject:(EventModel *)eventObject eventobjects:(NSMutableArray *)eventobjects {
    //18594234
    //https://www.eventbriteapi.com/v3/venues/14739406/?token=CNEQ55J3IRHNX3EGO6DX
    
    
    
    for(int i = 0; i < eventIds.count; i++){
        
        NSURLQueryItem *queryItem2 = [[NSURLQueryItem alloc] initWithName:@"token" value:@"CNEQ55J3IRHNX3EGO6DX"];
        
        NSArray *queryItems = [[NSArray alloc] initWithObjects:queryItem2, nil];
        
        NSURLComponents *components = [[NSURLComponents alloc] init];
        components.scheme = @"https";
        components.host = @"www.eventbriteapi.com";
        NSString *eid = [NSString stringWithFormat:@"/v3/venues/%@",eventIds[i]];
        //components.path = @"/v3/venues/";
        components.path = eid;
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
            NSDictionary *eventDetails = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                for(NSDictionary *event in eventDetails){
                    
                    NSDictionary *ed = eventDetails[@"events"];
        
                    eventObject.city = ed[@"city"];
                    eventObject.region = ed[@"region"];
                    eventObject.country = ed[@"country"];
                    eventObject.latCoordinate = ed[@"latCoordinate"];
                    eventObject.lonCoordinate = ed[@"lonCoordinate"];
                    eventObject.address = ed[@"address"];
                    [eventobjects addObject:eventObject];
                }
                
            });
            
        }];
        [dataTask resume];
    }
}

+ (void)fetchEventIDWithin:(NSString *)locationRadius latitude:(NSString *)lat longitude:(NSString *)lon
                     price:(NSString *)price startdate:(NSString *)startdate events:(NSMutableArray *)eventIds
               eventobject:(EventModel *)eventObject eventobjects:(NSMutableArray *)eventobjects{
    
    
    
    //https://www.eventbriteapi.com/v3/events/search/?token=CNEQ55J3IRHNX3EGO6DX
    
    // /v3/events/search/?location.within=1km&location.latitude=+49.281916&location.longitude=-123.108317&price=free&start_date.keyword=next_month&token=CNEQ55J3IRHNX3EGO6DX
    
    
    NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:@"location.within" value:locationRadius]; //in kms
    NSURLQueryItem *queryItem2 = [[NSURLQueryItem alloc] initWithName:@"location.latitude" value:lat];
    NSURLQueryItem *queryItem3 = [[NSURLQueryItem alloc] initWithName:@"location.longitude" value:lon];
    NSURLQueryItem *queryItem4 = [[NSURLQueryItem alloc] initWithName:@"price" value:price];
    NSURLQueryItem *queryItem5 = [[NSURLQueryItem alloc] initWithName:@"start_date.keyword" value:startdate];
    NSURLQueryItem *queryItem6 = [[NSURLQueryItem alloc] initWithName:@"token" value:@"CNEQ55J3IRHNX3EGO6DX"];
    
    
    NSArray *queryItems = [[NSArray alloc] initWithObjects:queryItem, queryItem2, queryItem3,queryItem4,queryItem5,queryItem6, nil];
    
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"www.eventbriteapi.com";
    components.path = @"/v3/events/search/";
    components.queryItems = queryItems;
    NSURL *url = components.URL;
    
    
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
                
                NSString *venueID = event[@"venue_id"];
                
                [eventIds addObject:venueID];
            }
            
            [self fetchEventDetailsWith:eventIds eventobject:eventObject eventobjects:eventobjects];
            
        });
        
    }];
    [dataTask resume];
}



@end
