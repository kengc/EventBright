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

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureMap];
}

-(void)configureMap
{
    NSLog(@"~~~~~~~~~~~%lu",(unsigned long)self.event.count);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
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
}
- (void)setEvent:(NSMutableArray *)newEvent
{
    _event = newEvent;
    
}

@end
