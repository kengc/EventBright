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
#import "CategoryTableViewCell.h"

@interface FiltersViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cityLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *isFreeButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;
@property int currentDistance;

@property (nonatomic) NSMutableArray *events;
@property (nonatomic) NSMutableArray *eventIds;
@property (nonatomic) NSMutableArray *eventObjects;
@property (nonatomic) EventModel *eventObject;
  @property (nonatomic) NSMutableDictionary *categoriesDict;
@property (weak, nonatomic) IBOutlet UILabel *categoryIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) NSString* priceButtonLabel;
@property (nonatomic) NSString* categoryName;
@property NSArray* categories;
@end


@implementation FiltersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _distanceSlider.minimumValue = 1;
    _distanceSlider.maximumValue = 100;
    _distanceSlider.value = 1;
    
    self.events = [[NSMutableArray alloc] init];
    self.eventIds = [[NSMutableArray alloc] init];
    self.eventObject = [[EventModel alloc] init];
    self.categoryName = @"199";
    self.eventObjects = [[NSMutableArray alloc] init];
    
    self.priceButtonLabel = @"free";
    
    _datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    
//    NSLog(@"count after: %lu", (unsigned long)self.eventIds.count);
    
//    NSLog(@"evenmodel: %lu", (unsigned long)self.eventObjects.count);

    self.categoriesDict = [[NSMutableDictionary alloc] init];
    [NSURLSessionHelper fetchEventCategories:self.categoriesDict];
    
    _categories = [[NSArray alloc]initWithObjects:@"Arts",@"Auto, Boat & Air",@"Business",@"Charity & Causes",@"Community",@"Family & Education",@"Fashion",@"Film & Media",@"Food & Drink",@"Government",@"Health",@"Hobbies",@"Holiday",@"Home & Lifestyle",@"Music",@"Science & Tech",@"Spirituality",@"Sports & Fitness",@"Travel & Outdoor",@"Other", nil];
}
-(void)observeStepperValueChange:(NSNotification *)notification
{

    MapViewController* viewController = [[MapViewController alloc] init];
    viewController.event = self.eventObjects;

    [self performSegueWithIdentifier:@"viewMap" sender:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"finishedPopulating"  object:nil];
    
//    NSLog(@"eventmodsnvm,xcn,xel: %lu", (unsigned long)self.eventObjects.count);
}
- (IBAction)distanceSlider:(id)sender
{
    _currentDistance = (int)self.distanceSlider.value;
    NSString* km = [NSString stringWithFormat:@"%ikm", self.currentDistance];
    self.distanceLabel.text = km;
    [self.cityLabel resignFirstResponder];
}
- (IBAction)isFreeButton:(id)sender
{
    if(_isFreeButton.selected == YES)
    {
//        self.priceLabel.text = @"free";
        self.priceButtonLabel = @"free";
    }
    else{
//        self.priceLabel.text = @"paid";
        self.priceButtonLabel = @"paid";
        [_isFreeButton setTitle:@"PAID" forState:UIControlStateSelected];
    }
    _isFreeButton.selected = !_isFreeButton.selected;
    
}
- (IBAction)cityLabel:(id)sender
{
    
}
- (IBAction)datePicker:(id)sender
{
    NSDate *chosen = [_datePicker date];
    NSString *dateText = [NSString stringWithFormat:@"%@",chosen];
    
    NSMutableString* dateTextMutable = (NSMutableString*)dateText;
    NSString *newString = [dateTextMutable substringToIndex:[dateTextMutable length]-6];
    
    NSString* finalString = [newString stringByReplacingOccurrencesOfString:@" " withString:@"T"];
    self.dateLabel.text = finalString;
    [self.cityLabel resignFirstResponder];
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}


- (IBAction)goToMap:(id)sender
{
    if(_cityLabel.text.length == 0)
    {
    [NSURLSessionHelper fetchEventIDWithin:self.distanceLabel.text latitude:@"+49.281916" longitude:@"-123.108317" price:self.priceButtonLabel startdate:self.dateLabel.text events:self.eventIds  eventobjects:self.eventObjects categoryId:self.categoryName city:@""];
    }
    else
    {
        [NSURLSessionHelper fetchEventIDWithin:self.distanceLabel.text latitude:@"" longitude:@"" price:self.priceButtonLabel startdate:self.dateLabel.text events:self.eventIds  eventobjects:self.eventObjects categoryId:self.categoryName city:self.cityLabel.text];
    }
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"viewMap"]){
        
        MapViewController *controller = [segue destinationViewController];
        [controller setEvent:self.eventObjects];
    }}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"Categories";
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _categories.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
//    cell. = self.categories[indexPath.row];
    cell.categoryCellLabel.text = self.categories[indexPath.row];
    cell.categoryCellLabel.highlightedTextColor = [UIColor  orangeColor];
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = selectionColor;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //CategoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0 ://"Arts";
            self.categoryName = @"105";
            break;
        case 1 ://"Auto, Boat & Air";
            self.categoryName = @"118";
            break;
        case 2 ://"Business";
            self.categoryName = @"101";
            break;
        case 3 ://"Charity & Causes";
            self.categoryName = @"111";
            break;
        case 4 ://"Community";
            self.categoryName = @"113";
            break;
        case 5 ://Family & Education";
            self.categoryName = @"115";
            break;
        case 6 ://"Fashion";
            self.categoryName = @"106";
            break;
        case 7 ://"Film & Media";
            self.categoryName = @"104";
            break;
        case 8 ://"Food & Drink";
            self.categoryName = @"110";
            break;
        case 9 ://"Government";
            self.categoryName = @"112";
            break;
        case 10 ://"Health";
            self.categoryName = @"107";
            break;
        case 11://"Hobbies";
            self.categoryName = @"119";
            break;
        case 12 ://"Holiday";
            self.categoryName = @"116";
            break;
        case 13 ://"Home & Lifestyle";
        self.categoryName= @"117";
            break;
        case 14 ://"Music";
            self.categoryName = @"103";
            break;
        case 15 ://"Science & Tech";
            self.categoryName = @"102";
            break;
        case 16 ://"Spirituality";
            self.categoryName = @"114";
            break;
        case 17 ://"Sports & Fitness";
            self.categoryName= @"108";
            break;
        case 18 ://"Travel & Outdoor";
            self.categoryName= @"109";
            break;
        default://"Other";
            self.categoryName = @"199";
            break;
    }
    [self.cityLabel resignFirstResponder];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 30.0;
    return height;
}


@end
