//
//  ARView.h
//
//  Created by Massimo Donati on 30/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <math.h>

// These are the values for full screen:
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.3

// We want full screen so use these dimensions:
//#define SCREEN_WIDTH  480
//#define SCREEN_HEIGTH 960

@interface ARViewController : UIViewController <CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	
	IBOutlet UIView *overlayView;
	IBOutlet UIImageView *marker;
	IBOutlet UIButton *toMap;
	IBOutlet UILabel *xValue;
	IBOutlet UIButton *infoMarker;
	
	UIImagePickerController *picker;
	CLLocationManager *locationManager;
	UIViewController *rootController;
	CLLocation *markerLocation;
	CLLocation *userLocation;
	
@private double angle;
	
}

@property (nonatomic, retain) IBOutlet UIView *overlayView;
@property (nonatomic, retain) IBOutlet UIImageView *marker;
@property (nonatomic, retain) IBOutlet UIButton *toMap;
@property (nonatomic, retain) IBOutlet UILabel *xValue;
@property (nonatomic, retain) IBOutlet IBOutlet UIButton *infoMarker;

@property (nonatomic, retain) UIImagePickerController *picker;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UIViewController *rootController;
@property (nonatomic, retain) CLLocation *markerLocation;
@property (nonatomic, retain) CLLocation *userLocation;

@property (nonatomic, assign) double angle;


-(void) mapView:(id)sender;
-(void)calculatePosition:(CLLocationDirection) heading;
-(double) angleBetweenCoordinate1:(CLLocationCoordinate2D)mark
				   AndCoordinate2:(CLLocationCoordinate2D)user;
-(void)infoButtonPushed:(id)sender;

@end