//
//  TestARAppViewController.h
//  TestARApp
//
//  Created by Massimo Donati on 03/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <MapKit/MapKit.h>
#import "ARViewController.h"


@interface TestARAppViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>{
	
	
	IBOutlet MKMapView *mapView;
	IBOutlet UIImageView *sight;
	IBOutlet UIButton *buttonAR;
	CLLocationManager *locationManager;
	ARViewController *arView;
	IBOutlet UIImageView * visibility;
	
	UITapGestureRecognizer *tapRec;
	
	//coordinate 
	CLLocation *sightPos;
	CLLocation *userPos;
	
}



//Proprietà di controllo


@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIImageView *sight;
@property (nonatomic, retain) IBOutlet UIButton *buttonAR;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) ARViewController *arView;
@property (nonatomic, retain) IBOutlet UIImageView * visibility;

@property (nonatomic, retain) UITapGestureRecognizer *tapRec;

@property (nonatomic, retain) CLLocation *sightPos;
@property (nonatomic, retain) CLLocation *userPos;

//metodo per far iniziare l'aggiornamento della posizione dell'immagine
-(IBAction) switchToAR:(id)sender;


@end
