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
    NSLog(@"heyeyeh%@",_coordinateData);
    
    NSMutableArray* locations;
    CLLocation *towerLocation = [[CLLocation alloc] initWithLatitude:[[_coordinateData[0] latCoordinate] floatValue] longitude:[[_coordinateData[0] lonCoordinate] floatValue]];
    [locations addObject:towerLocation];
    
    
    CLLocationCoordinate2D coord = [[locations lastObject] coordinate];
    
    for (int i=0; i<[locations count]; i++)
    {
        MKPointAnnotation* annotation= [MKPointAnnotation new];
        annotation.coordinate= [locations[i] coordinate];
        [_mapView addAnnotation: annotation];
    }
    
    
    CLLocationDegrees latitude = 49.281916;
    CLLocationDegrees longitude = -123.108317;
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    MKPointAnnotation *point2 = [[MKPointAnnotation alloc] init];
    MKPointAnnotation *point3 = [[MKPointAnnotation alloc] init];
    MKPointAnnotation *point4 = [[MKPointAnnotation alloc] init];
    
    
    point1.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    [_mapView addAnnotation: point1];
    
    point2.coordinate = CLLocationCoordinate2DMake([[_coordinateData[0] latCoordinate] floatValue], [[_coordinateData[0] lonCoordinate] floatValue]);
    [_mapView addAnnotation: point2];
    
    point3.coordinate = CLLocationCoordinate2DMake([[_coordinateData[1] latCoordinate] floatValue], [[_coordinateData[1] lonCoordinate] floatValue]);
    [_mapView addAnnotation: point3];
    
    point4.coordinate = CLLocationCoordinate2DMake([[_coordinateData[2] latCoordinate] floatValue], [[_coordinateData[2] lonCoordinate] floatValue]);
    [_mapView addAnnotation: point4];
    
   
    
}

@end
