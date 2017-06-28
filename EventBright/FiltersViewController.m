//
//  FiltersViewController.m
//  EventBright
//
//  Created by Katrina de Guzman on 2017-06-28.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import "FiltersViewController.h"

@interface FiltersViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *isFreeButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
@property int currentDistance;

@end


@implementation FiltersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _distanceSlider.minimumValue = 1;
    _distanceSlider.maximumValue = 100;
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
