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
    
    
    
    [NSURLSessionHelper fetchEventIDWithin:@"1km" latitude:@"+49.281916" longitude:@"-123.108317" price:@"free" startdate:@"next_month" events:self.eventIds eventobject:self.eventObject eventobjects:self.eventObjects];
    
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
        self.priceLabel.text = @"FREE";
    }
    else{
        self.priceLabel.text = @"PAID";
    }
    _isFreeButton.selected = !_isFreeButton.selected;
    
    
    [_isFreeButton setTitle:@"PAID" forState:UIControlStateSelected];
    
}
- (IBAction)datePicker:(id)sender
{
    NSDate *chosen = [_datePicker date];
    NSString *dateText = [NSString stringWithFormat:@"%@",chosen];
    self.dateLabel.text = dateText;
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

@end
