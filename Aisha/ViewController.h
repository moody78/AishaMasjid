//
//  ViewController.h
//  WISE
//
//  Created by Mohamed Rashwan on 04/07/2014.
//  Copyright (c) 2014 Beamstart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PrayerTimesGate.h"
#import "Settings.h"
#import "ActivitiesViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) UILabel *azanTitle;
@property (nonatomic, strong) UILabel *jamaaTitle;

@property (nonatomic, strong) UILabel *fajrTitle;
@property (nonatomic, strong) UILabel *sunriseTitle;
@property (nonatomic, strong) UILabel *dhuhrTitle;
@property (nonatomic, strong) UILabel *asrTitle;
@property (nonatomic, strong) UILabel *maghribTitle;
@property (nonatomic, strong) UILabel *ishaTitle;

@property (nonatomic, strong) UILabel *fajrAzan;
@property (nonatomic, strong) UILabel *sunriseAzan;
@property (nonatomic, strong) UILabel *dhuhrAzan;
@property (nonatomic, strong) UILabel *asrAzan;
@property (nonatomic, strong) UILabel *maghribAzan;
@property (nonatomic, strong) UILabel *ishaAzan;

@property (nonatomic, strong) UILabel *fajrJamaa;
@property (nonatomic, strong) UILabel *sunriseJamaa;
@property (nonatomic, strong) UILabel *dhuhrJamaa;
@property (nonatomic, strong) UILabel *asrJamaa;
@property (nonatomic, strong) UILabel *maghribJamaa;
@property (nonatomic, strong) UILabel *ishaJamaa;

@property (nonatomic, strong) UILabel *prayersTimeTitle;
@property (nonatomic, strong) UILabel *nextPrayerIndicator;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *lineViewBottom;
@property (nonatomic, strong) UILabel *footer;

@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) UIButton *websiteButton;
@property (nonatomic) PrayerTimesGate *prayerTimesGate;

- (void) loadPage;
- (void) formatNextPrayer;
- (UIColor *) colorForText;
- (UIColor *) colorForNextPrayer;

@end
