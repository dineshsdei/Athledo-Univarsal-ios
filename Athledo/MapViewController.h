//
//  MapViewController.h
//  Athledo
//
//  Created by Dinesh Kumar on 8/12/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WebServiceClass.h"

@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UITabBarDelegate,WebServiceDelegate>
{
    IBOutlet MKMapView *mapView;
   // CLLocationManager *locationManager;
    IBOutlet UITableView *mapTableView;
    
     IBOutlet UITabBar *tabBar;
}
@property(nonatomic,strong) NSArray *eventDic;
- (IBAction)standardMap:(id)sender;
- (IBAction)satelliteMap:(id)sender;
@property(weak,nonatomic)id objNotificationData;
@end
