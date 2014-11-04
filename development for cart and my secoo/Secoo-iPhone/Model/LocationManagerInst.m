//
//  LocationManager.m
//  Location
//
//  Created by lutan on 11/30/13.
//  Copyright (c) 2013 LG. All rights reserved.
//

#import "LocationManagerInst.h"

@interface LocationManagerInst ()
@property(strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation LocationManagerInst

+(LocationManagerInst *)sharedInstance
{
    static LocationManagerInst *locationManagerInst;
    if (locationManagerInst == nil) {
        locationManagerInst = [[LocationManagerInst alloc] init];
        locationManagerInst.locationManager = [[CLLocationManager alloc] init];
        locationManagerInst.locationManager.delegate = locationManagerInst;
        locationManagerInst.locationManager.distanceFilter = 5;
//        if ([CLLocationManager headingAvailable]) {
//            locationManagerInst.locationManager.headingFilter = 5;
//        }
        locationManagerInst.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return locationManagerInst;
}

- (void)startUpdate
{
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdate
{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark  ---CLLocationManagerDelegate---
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied) {
        
    }
    else if (status == kCLAuthorizationStatusNotDetermined){
        
    }
    else if (status == kCLAuthorizationStatusAuthorized){
        
    }
    else if (status == kCLAuthorizationStatusRestricted){
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSNotification *notif = [NSNotification notificationWithName:kSelfLocationChanged object:locations];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSNotification *notif = [NSNotification notificationWithName:kSelfHeadingChanged object:newHeading];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Error" message:@"error happens during update location" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [view show];
    if (error.code == kCLErrorDenied ) {
        [_locationManager stopUpdatingLocation];
    }
    else if (error.code == kCLErrorHeadingFailure){
        
    }
}

@end
