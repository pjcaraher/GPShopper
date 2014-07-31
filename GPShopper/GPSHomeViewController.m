//
//  GPSFirstViewController.m
//  GPShopper
//
//  Created by Patrick Caraher on 7/31/14.
//  Copyright (c) 2014 GPShopper. All rights reserved.
//

#import "GPSHomeViewController.h"
#import <GPShopper/GPShopper.h>

@interface GPSHomeViewController ()
@property (weak, nonatomic) IBOutlet BannerView *topBanner;
@property (weak, nonatomic) IBOutlet BannerView *middleBanner;
@property (weak, nonatomic) IBOutlet BannerView *bottomBanner;

@end

@implementation GPSHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.topBanner.bannerName = @"home_small_banner";
    self.middleBanner.bannerName = @"home_large_banner";
    self.bottomBanner.bannerName = @"home_bottom_banner";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
