//
//  MapViewController.m
//  EventBright
//
//  Created by Katrina de Guzman on 2017-06-28.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//


#import "MapViewController.h"
@import MapKit;
#import "EventBright-Swift.h"
#import "NSURLSessionHelper.h"

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property NSMutableArray* coordinateData;
@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureMap];
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDownloaded:) name:@"DataDownloaded" object:nil];
    
    
    
}
-(void)dataDownloaded:(NSNotification *)note {
    
    NSDictionary *dict = note.userInfo;
    NSArray *dataArray = [dict objectForKey:@"Data"];
    NSLog(@"ararayrqssaCy%@",[dataArray[0] latCoordinate]);
    _coordinateData = [NSMutableArray new];
    [_coordinateData addObjectsFromArray:dataArray];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setUpPins];
}

-(void)configureMap
{
    NSLog(@"~~~~~~~~~~~%lu",(unsigned long)self.event.count);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void) getData
{
    CLLocationDegrees latitude = 49.281916;
    CLLocationDegrees longitude = -123.108317;
    
    CLLocationCoordinate2D startLocationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    int regionRadius = 10000;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(startLocationCoordinate, regionRadius*2, regionRadius*2);
    [self.mapView setRegion:region];
    
    self.mapView.delegate = self;
    
    NSArray* locations = @[];
    for (int i=0; i<[locations count]; i++) {
        MKPointAnnotation* annotation= [MKPointAnnotation new];
        annotation.coordinate= [locations[i] coordinate];
        [_mapView addAnnotation: annotation];
    }
    NSLog(@"%@",_event);
    
    
}
- (void)setEvent:(NSMutableArray *)newEvent
{
    _event = newEvent;
    
}
-(void)setUpPins
{
    for(int i = 0; i < 50; i++)
    {
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake([[_coordinateData[i] latCoordinate] floatValue], [[_coordinateData[i] lonCoordinate] floatValue]);

        [_mapView addAnnotation: point];
    }
    
}

@end
