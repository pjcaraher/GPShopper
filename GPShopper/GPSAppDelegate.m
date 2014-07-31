//
//  GPSAppDelegate.m
//  GPShopper
//
//  Created by Patrick Caraher on 7/31/14.
//  Copyright (c) 2014 GPShopper. All rights reserved.
//

#import "GPSAppDelegate.h"
#import <GPShopper/GPShopper.h>

@interface GPSAppDelegate () <BannerActionDelegate,GPSSDKConfigurationDelegate,SCBeaconDeviceManagerDelegate,SCGeoFenceManagerDelegate,PushNotificationDelegate>
- (void)reactToNotificationAcceptedNotification:(NSNotification *)n;
@end

@implementation GPSAppDelegate

- (id)init
{
    if (self = [super init])
    {
        [GPSSDKConfiguration configureForSDKWithDelegate:self];
        [GPSSDKConfiguration configureBannerManager:self];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [SCBeaconDeviceManager startBeaconDeviceManagerForDelegate:self reqireOptIn:NO];
    [SCGeoFenceManager configureForDelegate:self];
    [[SCLocationList defaultList] setContentsFromFile: @"city_list"];
    
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector(reactToNotificationAcceptedNotification:)
     name: kSCPushNotificationHandlerAcceptedNotification
     object: nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [BannerManager refetchAll];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark  PushNotificationDelegate protocol

-(void)pushNotificationGotoHomePage
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark Protocol BannerActionDelegate

-(void)bannerGotoWapPageWithUrl: (NSString *)url
{
    NSLog(@"%s", __func__);
}

-(void)bannerGotoMailFormWithSubject: (NSString *)subject
                     receiverAddress: (NSString *)receiverAddress
{
    NSLog(@"%s", __func__);
}

-(void)bannerGotoSectionNamed: (NSString *)name
{
    NSLog(@"%s", __func__);
}

-(void)bannerGotoLandingPageForGrpid: (uint64_t)grpid
                        supplemental: (NSDictionary *)ss
{
    NSLog(@"%s", __func__);
}

-(void)bannerGotoContestPageForContestid: (uint64_t)contestid
{
    NSLog(@"%s", __func__);
}

-(void)bannerGotoGiftGuideForGgid: (uint64_t)ggid
{
    NSLog(@"%s", __func__);
}

-(void)bannerGotoSearchResultsForQuery: (NSString *)query
{
    NSLog(@"%s", __func__);
}

-(void)bannerGotoMultimediaTemplateForGgid: (uint64_t)ggid
{
    NSLog(@"%s", __func__);
}

-(void)bannerGotoPromoPageForGrpid: (uint64_t)grpid
{
    NSLog(@"%s", __func__);
}

-(void)bannerGotoEventForEventid: (uint64_t)i
{
    NSLog(@"%s", __func__);
}

-(void)bannerGotoCustomAction: (NSString *)scriptAction
{
    NSLog(@"%s", __func__);
}

-(void)bannerView: (BannerView *)v willPerformActionForBanner: (Banner *)b
{
    NSLog(@"%s", __func__);
}

-(void)bannerView: (BannerView *)v didPerformActionForBanner: (Banner *)b
{
    NSLog(@"%s", __func__);
}

#pragma mark protocol GPSSDKConfigurationDelegate
-(void)locationUpdated:(SCGeoLocation *)location
{
    NSLog(@"%s with location [%f,%f]", __func__, location.latlon.latitude, location.latlon.longitude);
}

#pragma mark - Delegate methods: SCBeaconDeviceManagerDelegate  // All of the methods in the protocol are optional.


-(void)scBeaconDeviceManager:(SCBeaconDeviceManager *)manager didEnterRegion:(CLBeaconRegion *)region
{
    NSLog(@"We didEnterRegion [%@]", region.identifier);
}

-(void)scBeaconDeviceManager:(SCBeaconDeviceManager *)manager didExitRegion:(CLBeaconRegion *)region
{
    NSLog(@"We didExitRegion [%@]", region.identifier);
}

-(void)scBeaconDeviceManager:(SCBeaconDeviceManager *)manager receivedOptIn:(GPSSDKOptIn *)optin
{
    /**
     This method only gets called if -
     1) Beacons are enabled
     2) The value for optin has not been set
     3) requireOptIn was set to YES when starting the beaconManager
     **/
    
    // The following method can be used to opt-in or opt-out from receiving beacon notifications (value is persisted in NSUserDefaults)
    [SCBeaconDeviceManager optIn:YES];
    NSLog(@"You have opted in to receive beacon notifications");
}

-(void)scBeaconDeviceManagerWasUpdated:(SCBeaconDeviceManager *)manager
{
    // This method gets called whenever beacons have been enabled or disabled in the console.
    NSLog(@"The Beacons feature has been turned %@", [manager isEnabled] ? @"ON" : @"OFF");
}

#pragma mark - Handle local Notifications
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if ([SCBeaconDeviceManager isOptedIn])
    {
        [SCPushNotificationHandler handleLocalNotification:[notification userInfo]];
    }
}

- (void)reactToNotificationAcceptedNotification:(NSNotification *)n
{
    if ([NSThread currentThread] != [NSThread mainThread])
    {
        [self performSelectorOnMainThread:@selector(reactToNotificationAcceptedNotification:) withObject:n waitUntilDone:NO];
        return;
    }
    
    // This is the userInfo of the original Notification
    NSDictionary *userInfo = (NSDictionary *)[n userInfo];
    
}

#pragma mark - Delegate methods: SCGeoFenceManagerDelegate

-(void)geoFenceManager:(SCGeoFenceManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"We entered region [%@]", region.identifier);
}

-(void)geoFenceManager:(SCGeoFenceManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"We exited region [%@]", region.identifier);
}

#pragma mark Apple Push Notification Service functions

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    [SCGeoFenceManager didRegisterForRemoteNotificationsWithDeviceToken:devToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    [SCGeoFenceManager didFailToRegisterForRemoteNotificationsWithError:err];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [SCPushNotificationHandler handleRemoteNotification:userInfo delegate:self];
}

@end
