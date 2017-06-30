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
//    [self configureMap];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDownloaded:) name:@"DataDownloaded" object:nil];
}
-(void)dataDownloaded:(NSNotification *)note {
    
    NSDictionary *dict = note.userInfo;
    NSArray *dataArray = [dict objectForKey:@"Data"];
//    NSLog(@"ararayrqssaCy%@",[dataArray[0] latCoordinate]);
    _coordinateData = [NSMutableArray new];
    [_coordinateData addObjectsFromArray:dataArray];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self getData];
    [self setUpPins];
}
//-(void)configureMap
//{
//    NSLog(@"~~~~~~~~~~~%lu",(unsigned long)self.event.count);
//}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void) getData
{
    // CLLocationDegrees latitude = 49.281916;
    //CLLocationDegrees longitude = -123.108317;
    
    CLLocationCoordinate2D startLocationCoordinate = CLLocationCoordinate2DMake([[_coordinateData[0] latCoordinate] floatValue], [[_coordinateData[0] lonCoordinate] floatValue]);
    int regionRadius = 10000;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(startLocationCoordinate, regionRadius*2, regionRadius*2);
    [self.mapView setRegion:region];
    
    self.mapView.delegate = self;
//    NSLog(@"%@",_event);
    
    
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
        point.coordinate = CLLocationCoordinate2DMake([[_coordinateData[i] latCoordinate] floatValue], [[_coordinateData[i] lonCoordinate] floatValue]);
        point.title = [NSString stringWithFormat:@"%@",  [_coordinateData[i] eventName]];
        point.subtitle = [NSString stringWithFormat:@"%@  %@",  [_coordinateData[i] venueName], [_coordinateData[i] address]];
        
        self.eventurl = [_coordinateData[i] eventurl];
        //[self.url setValue:[_coordinateData[i] eventName] forKey:[_coordinateData[i] eventurl]];
        
        [_mapView addAnnotation: point];
        [_mapView selectAnnotation:point animated:YES];
    }
}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    //annView.pinColor = MKPinAnnotationColorGreen;
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    
    //self.eventurl = [self.url objectForKey:annotation.title];
    
    AnnotationButton* annotationButton = [AnnotationButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationButton.url = self.eventurl;
    [annotationButton addTarget:self action:@selector(annotationAction:) forControlEvents:UIControlEventTouchUpInside];
    annView.rightCalloutAccessoryView = annotationButton;
    
    
    return annView;
}
- (void) annotationAction:(AnnotationButton *)sender{
    //Call a web view here
//    NSLog(@"OPEN BROWSER");
    
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.google.com"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sender.url]];
}
@end









