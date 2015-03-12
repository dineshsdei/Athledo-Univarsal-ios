//
//  MyAnnotation.h
//  Athledo
//
//  Created by Dinesh Kumar on 10/14/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation> {
	
	CLLocationCoordinate2D	_coordinate;
	NSString*				_title;
	NSString*				_subtitle;
    
    NSString *_statusAction;
    int _tagNumber;
}

@property (nonatomic, assign)	CLLocationCoordinate2D	coordinate;
@property (nonatomic, copy)		NSString*				title;
@property (nonatomic, copy)		NSString*				subtitle;
@property (nonatomic, copy)		NSString*				date;
@property(nonatomic, copy) NSString *statusAction;
@property(nonatomic, assign)int tagNumber;

@end