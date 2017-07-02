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
#import "AnnotationButton.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property NSMutableArray* coordinateData;
@property (nonatomic) NSMutableDictionary *url;
@property (nonatomic) NSString *eventurl;


@end
@implementation MapViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDownloaded:) name:@"DataDownloaded" object:nil];
}
-(void)dataDownloaded:(NSNotification *)note {
    
    NSDictionary *dict = note.userInfo;
    NSArray *dataArray = [dict objectForKey:@"Data"];
    self.coordinateData = [NSMutableArray new];
    [self.coordinateData addObjectsFromArray:dataArray];
    [self getData];
    [self setUpPins];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void) getData
{
    CLLocationCoordinate2D startLocationCoordinate = CLLocationCoordinate2DMake([[self.coordinateData[0] latCoordinate] floatValue], [[self.coordinateData[0] lonCoordinate] floatValue]);
    int regionRadius = 10000;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(startLocationCoordinate, regionRadius*2, regionRadius*2);
    [self.mapView setRegion:region];
    
    self.mapView.delegate = self;
}
- (void)setEvent:(NSMutableArray *)newEvent
{
    _event = newEvent;
    
}
-(void)setUpPins
{
    for(int i = 0; i < self.coordinateData.count; i++)
    {
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake([[self.coordinateData[i] latCoordinate] floatValue], [[self.coordinateData[i] lonCoordinate] floatValue]);
        point.title = [NSString stringWithFormat:@"%@",  [self.coordinateData[i] eventName]];
        point.subtitle = [NSString stringWithFormat:@"%@  %@",  [self.coordinateData[i] venueName], [self.coordinateData[i] address]];
        
        self.eventurl = [self.coordinateData[i] eventurl];
        
        [self.mapView addAnnotation: point];
        [self.mapView selectAnnotation:point animated:YES];
    }
}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    
    AnnotationButton* annotationButton = [AnnotationButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationButton.url = self.eventurl;
    [annotationButton addTarget:self action:@selector(annotationAction:) forControlEvents:UIControlEventTouchUpInside];
    annView.rightCalloutAccessoryView = annotationButton;
    
    
    return annView;
}
- (void) annotationAction:(AnnotationButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sender.url] options:@{} completionHandler:nil];
}
@end









