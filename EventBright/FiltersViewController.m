//
//  FiltersViewController.m
//  EventBright
//
//  Created by Katrina de Guzman on 2017-06-28.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import "FiltersViewController.h"
#import "EventBright-Swift.h"
#import "NSURLSessionHelper.h"
#import "MapViewController.h"

@interface FiltersViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *isFreeButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
@property int currentDistance;

@property (nonatomic) NSMutableArray *events;
@property (nonatomic) NSMutableArray *eventIds;
@property (nonatomic) NSMutableArray *eventObjects;
@property (nonatomic) EventModel *eventObject;

@end


@implementation FiltersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _distanceSlider.minimumValue = 1;
    _distanceSlider.maximumValue = 100;
    
    
    self.events = [[NSMutableArray alloc] init];
    self.eventIds = [[NSMutableArray alloc] init];
    self.eventObject = [[EventModel alloc] init];
    
    self.eventObjects = [[NSMutableArray alloc] init];
    
//    UIDatePicker *picker = (UIDatePicker*)self.DateText.inputView;
 
    
    
    
    NSLog(@"count after: %lu", (unsigned long)self.eventIds.count);

    
    
    NSLog(@"evenmodel: %lu", (unsigned long)self.eventObjects.count);
    
}

- (IBAction)distanceSlider:(id)sender
{
    _currentDistance = (int)self.distanceSlider.value;
    NSString* km = [NSString stringWithFormat:@"%ikm", self.currentDistance];
    self.distanceLabel.text = km;
}
- (IBAction)isFreeButton:(id)sender
{
    if(_isFreeButton.selected == YES)
    {
        self.priceLabel.text = @"free";
    }
    else{
        self.priceLabel.text = @"paid";
        [_isFreeButton setTitle:@"PAID" forState:UIControlStateSelected];
    }
    _isFreeButton.selected = !_isFreeButton.selected;
    
    
    
    
}
- (IBAction)datePicker:(id)sender
{
    NSDate *chosen = [_datePicker date];
    NSString *dateText = [NSString stringWithFormat:@"%@",chosen];
    
    NSMutableString* dateTextMutable = (NSMutableString*)dateText;
    NSString *newString = [dateTextMutable substringToIndex:[dateTextMutable length]-6];
    
    NSString* finalString = [newString stringByReplacingOccurrencesOfString:@" " withString:@"T"];
    NSLog(@"DATE OBJECT~~~~%@",finalString);
    self.dateLabel.text = finalString;
    
    

}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}


- (IBAction)goToMap:(id)sender
{
    [NSURLSessionHelper fetchEventIDWithin:self.distanceLabel.text latitude:@"+49.281916" longitude:@"-123.108317" price:self.priceLabel.text startdate:self.dateLabel.text events:self.eventIds eventobject:self.eventObject eventobjects:self.eventObjects];
    
}

//MyViewController* viewController = [[MyViewController alloc] init];
//
//[self.navigationController pushViewController:viewController animated:YES];
//[viewController release];
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//
//    if([segue.identifier isEqualToString:@"viewMap"])
//    {
//        MapViewController *controller = [segue destinationViewController];
//        [controller setEvent:self.eventObjects];
//    }}
@end
