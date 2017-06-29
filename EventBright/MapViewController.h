//
//  MapViewController.h
//  EventBright
//
//  Created by Katrina de Guzman on 2017-06-28.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface MapViewController : UIViewController
@property (weak,nonatomic) NSMutableArray* event;
- (void)setEvent:(NSMutableArray *)newEvent;
@end
