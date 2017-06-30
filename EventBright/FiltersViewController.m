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
@property NSArray* categories;
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
    
    self.priceButtonLabel = @"free";
    
    _datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    
    NSLog(@"count after: %lu", (unsigned long)self.eventIds.count);
    
    NSLog(@"evenmodel: %lu", (unsigned long)self.eventObjects.count);

    self.categoriesDict = [[NSMutableDictionary alloc] init];
    [NSURLSessionHelper fetchEventCategories:self.categoriesDict];
    
    _categories = [[NSArray alloc]initWithObjects:@"Arts",@"Auto, Boat & Air",@"Business",@"Charity & Causes",@"Community",@"Family & Education",@"Fashion",@"Film & Media",@"Food & Drink",@"Government",@"Health",@"Hobbies",@"Holiday",@"Home & Lifestyle",@"Music",@"Other",@"Science & Tech",@"Spirituality",@"Sports & Fitness",@"Travel & Outdoor", nil];
}
-(void)observeStepperValueChange:(NSNotification *)notification
{

    MapViewController* viewController = [[MapViewController alloc] init];
    viewController.event = self.eventObjects;

    [self performSegueWithIdentifier:@"viewMap" sender:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"finishedPopulating"  object:nil];
    
    NSLog(@"eventmodsnvm,xcn,xel: %lu", (unsigned long)self.eventObjects.count);
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
    [NSURLSessionHelper fetchEventIDWithin:self.distanceLabel.text latitude:@"+49.281916" longitude:@"-123.108317" price:self.priceButtonLabel startdate:self.dateLabel.text events:self.eventIds  eventobjects:self.eventObjects categoryId:self.categoryIdLabel.text city:@""];
    }
    else
    {
        [NSURLSessionHelper fetchEventIDWithin:self.distanceLabel.text latitude:@"" longitude:@"" price:self.priceButtonLabel startdate:self.dateLabel.text events:self.eventIds  eventobjects:self.eventObjects categoryId:self.categoryIdLabel.text city:self.cityLabel.text];
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
        case 0 :
//            self.categorySelected = @"Arts";
            self.categoryIdLabel.text = @"105";
            break;
        case 1 :
//            self.categorySelected = @"Auto, Boat & Air";
            self.categoryIdLabel.text = @"118";
            break;
        case 2 :
//            self.categorySelected = @"Business";
            self.categoryIdLabel.text = @"101";
            break;
        case 3 :
//            self.categorySelected = @"Charity & Causes";
            self.categoryIdLabel.text = @"111";
            break;
        case 4 :
//            self.categorySelected = @"Community";
            self.categoryIdLabel.text = @"113";
            break;
        case 5 :
//            self.categorySelected = @"Family & Education";
            self.categoryIdLabel.text = @"115";
            break;
        case 6 :
//            self.categorySelected = @"Fashion";
            self.categoryIdLabel.text = @"106";
            break;
        case 7 :
//            self.categorySelected = @"Film & Media";
            self.categoryIdLabel.text = @"104";
            break;
        case 8 :
//            self.categorySelected = @"Food & Drink";
            self.categoryIdLabel.text = @"110";
            break;
        case 9 :
//            self.categorySelected = @"Government";
            self.categoryIdLabel.text = @"112";
            break;
        case 10 :
//            self.categorySelected = @"Health";
            self.categoryIdLabel.text = @"107";
            break;
        case 11:
//            self.categorySelected = @"Hobbies";
            self.categoryIdLabel.text = @"119";
            break;
        case 12 :
//            self.categorySelected = @"Holiday";
            self.categoryIdLabel.text = @"116";
            break;
        case 13 :
//            self.categorySelected = @"Home & Lifestyle";
            self.categoryIdLabel.text = @"117";
            break;
        case 14 :
//            self.categorySelected = @"Music";
            self.categoryIdLabel.text = @"103";
            break;
        case 15 :
//            self.categorySelected = @"Science & Tech";
            self.categoryIdLabel.text = @"102";
            break;
        case 16 :
//            self.categorySelected = @"Spirituality";
            self.categoryIdLabel.text = @"114";
            break;
        case 17 :
//            self.categorySelected = @"Sports & Fitness";
            self.categoryIdLabel.text = @"108";
            break;
        case 18 :
//            self.categorySelected = @"Travel & Outdoor";
            self.categoryIdLabel.text = @"109";
            break;
        default:
//            self.categorySelected = @"Other";
            self.categoryIdLabel.text = @"199";
            break;
    }
    
    // self.categorySelected = cell.textLabel.text;
    [self.cityLabel resignFirstResponder];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 30.0;
    return height;
}


@end
