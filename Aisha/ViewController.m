//
//  ViewController.m
//  WISE
//
//  Created by Mohamed Rashwan on 04/07/2014.
//  Copyright (c) 2014 Beamstart. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize prayerTimesGate;

- (UIColor *) colorForText
{
    return [UIColor blackColor];
}

- (UIColor *) colorForNextPrayer
{
    return [UIColor redColor];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"Home";
        self.tabBarItem.image = [UIImage imageNamed:@"home-25.png"];
    }
    return self;
}

- (void) performLoadPage:(id)paramSender
{
    // pass nil to indicate this is not a background fetch and we r not interested in storing fetched data
    [prayerTimesGate reloadPrayerTimes:nil];
    
    [self loadPage];
    [self formatNextPrayer];
}

- (void) goToWebsite:(id)paramSender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://aishaislamiccentre.org.uk"]];
}

- (void) buttonHighlight:(id)paramSender
{
    [paramSender setBackgroundColor:[UIColor darkGrayColor]];
}

- (void) buttonNormal:(id)paramSender
{
    [paramSender setBackgroundColor:[UIColor clearColor]];
}

- (void) loadPage
{
    PrayerTimes *prayerTimes = [prayerTimesGate getCurrentPrayerTimesRecord];
    
    self.fajrTitle.text = @"Fajr";
    self.fajrAzan.text = prayerTimes.fajrAzan;
    self.fajrJamaa.text = prayerTimes.fajrJamaa;
    
    self.sunriseTitle.text = @"Sunrise";
    self.sunriseAzan.text = prayerTimes.sunriseAzan;
    self.sunriseJamaa.text = @"-";
    
    self.dhuhrTitle.text = @"Zuhr";
    self.dhuhrAzan.text = prayerTimes.dhuhrAzan;
    self.dhuhrJamaa.text = prayerTimes.dhuhrJamaa;
    
    self.asrTitle.text = @"Asr";
    self.asrAzan.text = prayerTimes.asrAzan;
    self.asrJamaa.text = prayerTimes.asrJamaa;
    
    self.maghribTitle.text = @"Maghrib";
    self.maghribAzan.text = prayerTimes.maghribAzan;
    self.maghribJamaa.text = prayerTimes.maghribJamaa;
    
    self.ishaTitle.text = @"Esha";
    self.ishaAzan.text = prayerTimes.ishaAzan;
    self.ishaJamaa.text = prayerTimes.ishaJamaa;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    timeZone = [NSTimeZone timeZoneForSecondsFromGMT:timeZone.secondsFromGMT];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"dd/MM/yyyy hh:mm:ssa"];
    
    //Optionally for time zone conversions
    //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    self.footer.text = [NSString stringWithFormat:@"Last time refreshed: %@", [formatter stringFromDate:[NSDate date]]];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self drawEverything];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]

    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        [self drawEverything];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        
    }];
}

- (void) drawEverything
{
    [self drawBackground];
    [self drawPrayerTimes];
    [self formatNextPrayer];
}

- (void) drawBackground
{
    UIColor* customYellow = [[UIColor alloc] initWithRed:247.0f/255.0f green:206.0f/255.0f blue:72.0f/255.0f alpha:1];
    UIColor* customYellow2 = [[UIColor alloc] initWithRed:247.0f/255.0f green:220.0f/255.0f blue:100.0f/255.0f alpha:1];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(performLoadPage:)];
    
    int removeIndex = -1;
    
    do
    {
        NSArray *sublayers = self.view.layer.sublayers;
        int i=0;
        removeIndex = -1;
        
        for (CALayer *layer in sublayers)
        {
            if([layer isKindOfClass:[CAGradientLayer class]])
            {
                removeIndex = i;
            }
            
            i = i + 1;
        }
        
        if(removeIndex>-1)
        {
            NSLog(@"xRemove gradient layer @%u",removeIndex);
            [self.view.layer.sublayers[removeIndex] removeFromSuperlayer];
        }
        
    }while(removeIndex > -1);
    
    NSLog(@"xNumber of layers = %u", (uint)self.view.layer.sublayers.count);
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
    //gradient.colors = [NSArray arrayWithObjects:(id)[customBlue CGColor], (id)[customBlue CGColor], nil];
    gradient.colors = [NSArray arrayWithObjects:(id)[customYellow CGColor], (id)[customYellow2 CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawBackground];
    [self drawPrayerTimes];
    
}

- (void) formatNextPrayer
{
    [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.fajrTitle.frame.origin.x + 10, self.fajrTitle.frame.origin.y + 10);}];
    
    PrayerTimes *prayerTimes = [prayerTimesGate getCurrentPrayerTimesRecord];
    
    [self.fajrTitle setTextColor:self.colorForText];
    [self.fajrAzan setTextColor:self.colorForText];
    [self.fajrJamaa setTextColor:self.colorForText];
    
    [self.sunriseTitle setTextColor:self.colorForText];
    [self.sunriseAzan setTextColor:self.colorForText];
    [self.sunriseJamaa setTextColor:self.colorForText];
    
    [self.dhuhrTitle setTextColor:self.colorForText];
    [self.dhuhrAzan setTextColor:self.colorForText];
    [self.dhuhrJamaa setTextColor:self.colorForText];
    
    [self.asrTitle setTextColor:self.colorForText];
    [self.asrAzan setTextColor:self.colorForText];
    [self.asrJamaa setTextColor:self.colorForText];
    
    [self.maghribTitle setTextColor:self.colorForText];
    [self.maghribAzan setTextColor:self.colorForText];
    [self.maghribJamaa setTextColor:self.colorForText];
    
    [self.ishaTitle setTextColor:self.colorForText];
    [self.ishaAzan setTextColor:self.colorForText];
    [self.ishaJamaa setTextColor:self.colorForText];
    
    if([[prayerTimesGate getPrayerTimeAt:prayerTimes.fajrAzan ampm:@"am"] compare:[NSDate date]] == NSOrderedDescending)
    {
        [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.fajrTitle.frame.origin.x + 10, self.fajrTitle.frame.origin.y + 10);}];
        
        [self.fajrTitle setTextColor:self.colorForNextPrayer];
        [self.fajrAzan setTextColor:self.colorForNextPrayer];
        [self.fajrJamaa setTextColor:self.colorForNextPrayer];
    }
    else if([[prayerTimesGate getPrayerTimeAt:prayerTimes.sunriseAzan ampm:@"am"] compare:[NSDate date]] == NSOrderedDescending)
    {
        [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.sunriseTitle.frame.origin.x + 10, self.sunriseTitle.frame.origin.y + 10);}];
        
        [self.sunriseTitle setTextColor:self.colorForNextPrayer];
        [self.sunriseAzan setTextColor:self.colorForNextPrayer];
        [self.sunriseJamaa setTextColor:self.colorForNextPrayer];
    }
    else if([[prayerTimesGate getPrayerTimeAt:prayerTimes.dhuhrAzan ampm:@"pm"] compare:[NSDate date]] == NSOrderedDescending)
    {
        [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.dhuhrTitle.frame.origin.x + 10, self.dhuhrTitle.frame.origin.y + 10);}];
        
        [self.dhuhrTitle setTextColor:self.colorForNextPrayer];
        [self.dhuhrAzan setTextColor:self.colorForNextPrayer];
        [self.dhuhrJamaa setTextColor:self.colorForNextPrayer];
    }
    else if([[prayerTimesGate getPrayerTimeAt:prayerTimes.asrAzan ampm:@"pm"] compare:[NSDate date]] == NSOrderedDescending)
    {
        [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.asrTitle.frame.origin.x + 10, self.asrTitle.frame.origin.y + 10);}];
        
        [self.asrTitle setTextColor:self.colorForNextPrayer];
        [self.asrAzan setTextColor:self.colorForNextPrayer];
        [self.asrJamaa setTextColor:self.colorForNextPrayer];
    }
    else if([[prayerTimesGate getPrayerTimeAt:prayerTimes.maghribAzan ampm:@"pm"] compare:[NSDate date]] == NSOrderedDescending)
    {
        [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.maghribTitle.frame.origin.x + 10, self.maghribTitle.frame.origin.y + 10);}];
        
        [self.maghribTitle setTextColor:self.colorForNextPrayer];
        [self.maghribAzan setTextColor:self.colorForNextPrayer];
        [self.maghribJamaa setTextColor:self.colorForNextPrayer];
    }
    else if([[prayerTimesGate getPrayerTimeAt:prayerTimes.ishaAzan ampm:@"pm"] compare:[NSDate date]] == NSOrderedDescending)
    {
        [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.ishaTitle.frame.origin.x + 10, self.ishaTitle.frame.origin.y + 10);}];
        
        [self.ishaTitle setTextColor:self.colorForNextPrayer];
        [self.ishaAzan setTextColor:self.colorForNextPrayer];
        [self.ishaJamaa setTextColor:self.colorForNextPrayer];
    }
    else if([[[prayerTimesGate getPrayerTimeAt:prayerTimes.ishaAzan ampm:@"pm"] dateByAddingTimeInterval:60*60*24] compare:[NSDate date]] == NSOrderedDescending)
    {
        [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.fajrTitle.frame.origin.x + 10, self.fajrTitle.frame.origin.y + 10);}];
        
        [self.fajrTitle setTextColor:self.colorForNextPrayer];
        [self.fajrAzan setTextColor:self.colorForNextPrayer];
        [self.fajrJamaa setTextColor:self.colorForNextPrayer];
    }
    else
    {
        self.nextPrayerIndicator.text = @"";
    }
    
}

- (void)drawPrayerTimes
{/*
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }*/
    bool landScape = false;
    if(self.view.frame.size.width > self.view.frame.size.height)
        landScape = true;
    
    float width = 75.0f;
    float height = 23.0f;
    float horizontalSpacing = 10;
    
    float left = ([[UIScreen mainScreen]bounds].size.width - (width * 3) - (horizontalSpacing * 2) + 25) / 2;
    if(landScape == true)
        left = (([[UIScreen mainScreen]bounds].size.width / 2) - (width * 3) - (horizontalSpacing * 2) + 25) / 2;
    
    float left2 = left + width + horizontalSpacing;
    float left3 = left2 + width + horizontalSpacing;
    float verticalSpacing = 10;
    float titleTopDelta = 2;
    float top0 = (([[UIScreen mainScreen]bounds].size.height - (height * 3) - (verticalSpacing * 5) - 100) / 2);
    float top1 = top0 + height + verticalSpacing;
    float top2 = top1 + height + verticalSpacing;
    float top3 = top1 + height + verticalSpacing;
    float top4 = top3 + height + verticalSpacing;
    float top5 = top4 + height + verticalSpacing;
    float top6 = top5 + height + verticalSpacing;
    float titleTop = top0 - (height) * titleTopDelta;
    
    if(self.prayersTimeTitle == nil)
    {
        // Initialize all labels
        self.prayersTimeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, titleTop, [[UIScreen mainScreen] bounds].size.width, height)];
        self.prayersTimeTitle.textAlignment = NSTextAlignmentCenter;
    
        self.azanTitle = [[UILabel alloc]initWithFrame:CGRectMake(left2,top0,width,height)];
        self.jamaaTitle = [[UILabel alloc]initWithFrame:CGRectMake(left3,top0,width,height)];
    
        self.fajrTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, top1, width, height)];
        self.fajrAzan = [[UILabel alloc] initWithFrame:CGRectMake(left2, top1, width, height)];
        self.fajrJamaa = [[UILabel alloc] initWithFrame:CGRectMake(left3, top1, width, height)];
    
        self.sunriseTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, top2, width, height)];
        self.sunriseAzan = [[UILabel alloc] initWithFrame:CGRectMake(left2, top2, width, height)];
        self.sunriseJamaa = [[UILabel alloc] initWithFrame:CGRectMake(left3, top2, width, height)];
    
        self.dhuhrTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, top3, width, height)];
        self.dhuhrAzan = [[UILabel alloc] initWithFrame:CGRectMake(left2, top3, width, height)];
        self.dhuhrJamaa = [[UILabel alloc] initWithFrame:CGRectMake(left3, top3, width, height)];
    
        self.asrTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, top4, width, height)];
        self.asrAzan = [[UILabel alloc] initWithFrame:CGRectMake(left2, top4, width, height)];
        self.asrJamaa = [[UILabel alloc] initWithFrame:CGRectMake(left3, top4, width, height)];
    
        self.maghribTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, top5, width, height)];
        self.maghribAzan = [[UILabel alloc] initWithFrame:CGRectMake(left2, top5, width, height)];
        self.maghribJamaa = [[UILabel alloc] initWithFrame:CGRectMake(left3, top5, width, height)];
    
        self.ishaTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, top6, width, height)];
        self.ishaAzan = [[UILabel alloc] initWithFrame:CGRectMake(left2, top6, width, height)];
        self.ishaJamaa = [[UILabel alloc] initWithFrame:CGRectMake(left3, top6, width, height)];
        
        [self.view addSubview:self.azanTitle];
        [self.view addSubview:self.jamaaTitle];
        
        [self.view addSubview:self.prayersTimeTitle];
        [self.view addSubview:self.fajrTitle];
        [self.view addSubview:self.fajrAzan];
        [self.view addSubview:self.fajrJamaa];
        
        //[self.view addSubview:self.sunriseTitle];
        //[self.view addSubview:self.sunriseAzan];
        //[self.view addSubview:self.sunriseJamaa];
        
        [self.view addSubview:self.dhuhrTitle];
        [self.view addSubview:self.dhuhrAzan];
        [self.view addSubview:self.dhuhrJamaa];
        
        [self.view addSubview:self.asrTitle];
        [self.view addSubview:self.asrAzan];
        [self.view addSubview:self.asrJamaa];
        
        [self.view addSubview:self.maghribTitle];
        [self.view addSubview:self.maghribAzan];
        [self.view addSubview:self.maghribJamaa];
        
        [self.view addSubview:self.ishaTitle];
        [self.view addSubview:self.ishaAzan];
        [self.view addSubview:self.ishaJamaa];
        
        // Draw line for title
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.prayersTimeTitle.frame.origin.y + 25, self.prayersTimeTitle.frame.size.width, 1)];
        self.lineView.backgroundColor = self.colorForText;
        [self.view addSubview:self.lineView];
        
        // Draw line at bottom
        self.lineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.ishaTitle.frame.origin.y + 50, self.prayersTimeTitle.frame.size.width, 1)];
        self.lineViewBottom.backgroundColor = self.colorForText;
        [self.view addSubview:self.lineViewBottom];
        
        // Draw next prayer indicator
        self.nextPrayerIndicator = [[UILabel alloc] initWithFrame:CGRectMake(left, top1, width, height)];
        self.nextPrayerIndicator.text = @">>";
        self.nextPrayerIndicator.textColor = self.colorForNextPrayer;
        [self.view addSubview:self.nextPrayerIndicator];
        
        // Draw footer
        self.footer = [[UILabel alloc] initWithFrame:CGRectMake(0, self.lineViewBottom.frame.origin.y, self.view.frame.size.width, height)];
        self.footer.font = [UIFont systemFontOfSize:14.0f];
        self.footer.text = @"";
        self.footer.textColor = self.colorForText;
        self.footer.numberOfLines = 0;
        [self.view addSubview:self.footer];
        
        self.prayersTimeTitle.text = @"Today's prayer times";
        self.prayersTimeTitle.textColor = self.colorForText;
        
        self.azanTitle.text = @"Begins";
        self.azanTitle.textColor = self.colorForText;
        
        self.jamaaTitle.text = @"Juma'ah";
        self.jamaaTitle.textColor = self.colorForText;
        
        self.websiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.websiteButton addTarget:self
                   action:@selector(goToWebsite:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.websiteButton setTitle:@"More Info" forState:UIControlStateNormal];
        [self.websiteButton.layer setBorderColor:[self.colorForText CGColor]];
        [self.websiteButton setTitleColor:self.colorForText forState:UIControlStateNormal];
        [self.websiteButton.layer setBorderWidth:1.0f];
        self.websiteButton.layer.cornerRadius = 5;
        self.websiteButton.clipsToBounds = YES;
        
        [self.websiteButton addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
        [self.websiteButton addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
        [self.websiteButton addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpOutside];
        self.websiteButton.frame = CGRectMake(left, self.footer.frame.origin.y + (height * 3), (width * 3) + (horizontalSpacing * 0), height * 2);
        [self.view addSubview:self.websiteButton];
    }
    else
    {
        // Move labels
        [UIView animateWithDuration:0.5f animations:^{self.prayersTimeTitle.frame = CGRectMake(0,titleTop, [[UIScreen mainScreen] bounds].size.width, height);}];
        
        [UIView animateWithDuration:0.5f animations:^{self.azanTitle.frame = CGRectMake(left2,top0, width, height);}];
        [UIView animateWithDuration:0.5f animations:^{self.jamaaTitle.frame = CGRectMake(left3,top0, width, height);}];
        
        [UIView animateWithDuration:0.5f animations:^{self.fajrTitle.frame = CGRectMake(left,top1, width, height);}];
        [UIView animateWithDuration:0.5f animations:^{self.fajrAzan.frame = CGRectMake(left2,top1, width, height);}];
        [UIView animateWithDuration:0.5f animations:^{self.fajrJamaa.frame = CGRectMake(left3,top1, width, height);}];
        
        [UIView animateWithDuration:0.5f animations:^{self.sunriseTitle.frame = CGRectMake(left,top2, width, height);}];
        [UIView animateWithDuration:0.5f animations:^{self.sunriseAzan.frame = CGRectMake(left2,top2, width, height);}];
        [UIView animateWithDuration:0.5f animations:^{self.sunriseJamaa.frame = CGRectMake(left3,top2, width, height);}];
        
        [UIView animateWithDuration:0.5f animations:^{self.dhuhrTitle.frame = CGRectMake(left,top3, width, height);}];
        [UIView animateWithDuration:0.5f animations:^{self.dhuhrAzan.frame = CGRectMake(left2,top3, width, height);}];
        [UIView animateWithDuration:0.5f animations:^{self.dhuhrJamaa.frame = CGRectMake(left3,top3, width, height);}];
        
        [UIView animateWithDuration:0.5f animations:^{self.asrTitle.frame = CGRectMake(left,top4, width, height);}];
        [UIView animateWithDuration:0.5f animations:^{self.asrAzan.frame = CGRectMake(left2,top4, width, height);}];
        [UIView animateWithDuration:0.5f animations:^{self.asrJamaa.frame = CGRectMake(left3,top4, width, height);}];
        
        [UIView animateWithDuration:0.5f animations:^{self.maghribTitle.frame = CGRectMake(left,top5, width, height);}];
        [UIView animateWithDuration:0.5f animations:^{self.maghribAzan.frame = CGRectMake(left2,top5, width, height);}];
        [UIView animateWithDuration:0.5f animations:^{self.maghribJamaa.frame = CGRectMake(left3,top5, width, height);}];
        
        [UIView animateWithDuration:0.5f animations:^{self.ishaTitle.frame = CGRectMake(left,top6, width, height);}];
        [UIView animateWithDuration:0.5f animations:^{self.ishaAzan.frame = CGRectMake(left2,top6, width, height);}];
        [UIView animateWithDuration:0.5f animations:^{self.ishaJamaa.frame = CGRectMake(left3,top6, width, height);}];
        
        // Move line for title
        [UIView animateWithDuration:0.0f animations:^{self.lineView.frame = CGRectMake(0, self.prayersTimeTitle.frame.origin.y + 25, self.prayersTimeTitle.frame.size.width, 1);}];
        
        // Move line at bottom
        if(landScape == YES)
        {
            [UIView animateWithDuration:0.0f animations:^{self.lineViewBottom.frame = CGRectMake(left + self.fajrJamaa.frame.origin.x + width, self.jamaaTitle.frame.origin.y, 1, self.ishaTitle.frame.origin.y - self.jamaaTitle.frame.origin.y + height);}];
            
        }
        else
        {
            [UIView animateWithDuration:0.0f animations:^{self.lineViewBottom.frame = CGRectMake(0, self.ishaTitle.frame.origin.y + 50, self.prayersTimeTitle.frame.size.width, 1);}];
        }
        
        // Move footer
        if(landScape == YES)
        {
            float footerLeft = self.lineViewBottom.frame.origin.x + horizontalSpacing;
            float footerWidth = self.view.frame.size.width - footerLeft - horizontalSpacing;
            
            [UIView animateWithDuration:0.5f animations:^{self.footer.frame = CGRectMake(footerLeft, self.lineViewBottom.frame.origin.y, footerWidth, height * 2);}];
        }
        else
        {
            [UIView animateWithDuration:0.5f animations:^{self.footer.frame = CGRectMake(0, self.lineViewBottom.frame.origin.y, self.view.frame.size.width, height);}];
        }
        
        // Move website button
        if(landScape == YES)
        {
            float buttonWidth = width * 3;
            float buttonX = (horizontalSpacing * 2)+self.footer.frame.origin.x;
            float viewWidth = self.view.frame.size.width;
            
            if(buttonX + buttonWidth > viewWidth)
            {
                buttonWidth = viewWidth - buttonX - (buttonX - self.lineViewBottom.frame.origin.x);
            }
            
            [UIView animateWithDuration:0.5f animations:^{self.websiteButton.frame = CGRectMake((horizontalSpacing * 2)+self.footer.frame.origin.x, self.footer.frame.origin.y + (height * 3), buttonWidth, height * 2);}];
        }
        else
        {
            float buttonY = self.footer.frame.origin.y + (height * 3);
            float buttonHeight = height * 2;
            float viewBottom = self.view.frame.size.height;
            
            while(buttonY + (height*3) > viewBottom)
            {
                buttonY = buttonY - height;
                buttonHeight = height;
            }
            
            [UIView animateWithDuration:0.5f animations:^{self.websiteButton.frame = CGRectMake(left, buttonY, (width * 3) + (horizontalSpacing * 0), buttonHeight);}];
        }
    }
    
    float headerFontSize = 16.0f;
    
    self.azanTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    self.jamaaTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    self.fajrTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    self.sunriseTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    self.dhuhrTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    self.asrTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    self.maghribTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    self.ishaTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    
    self.fajrTitle.textColor = self.colorForText;
    self.sunriseTitle.textColor = self.fajrTitle.textColor;
    self.dhuhrTitle.textColor = self.fajrTitle.textColor;
    self.asrTitle.textColor = self.fajrTitle.textColor;
    self.maghribTitle.textColor = self.fajrTitle.textColor;
    self.ishaTitle.textColor = self.fajrTitle.textColor;
    
    self.fajrAzan.textColor = self.colorForText;
    self.sunriseAzan.textColor = self.fajrAzan.textColor;
    self.dhuhrAzan.textColor = self.fajrAzan.textColor;
    self.asrAzan.textColor = self.fajrAzan.textColor;
    self.maghribAzan.textColor = self.fajrAzan.textColor;
    self.ishaAzan.textColor = self.fajrAzan.textColor;
    
    self.fajrJamaa.textColor = self.colorForText;
    self.sunriseJamaa.textColor = self.fajrJamaa.textColor;
    self.dhuhrJamaa.textColor = self.fajrJamaa.textColor;
    self.asrJamaa.textColor = self.fajrJamaa.textColor;
    self.maghribJamaa.textColor = self.fajrJamaa.textColor;
    self.ishaJamaa.textColor = self.fajrJamaa.textColor;

    
    prayerTimesGate = [[PrayerTimesGate alloc]init];
    
    // pass nil to indicate this is not a background fetch and we r not interested in storing fetched data
    [prayerTimesGate reloadPrayerTimes:nil];
    
    [self loadPage];
    
    [self formatNextPrayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
