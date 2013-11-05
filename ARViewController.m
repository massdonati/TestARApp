//
//  ARView.m
//
//  Created by Massimo Donati on 30/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ARViewController.h"
#import "TestARAppViewController.h"
@implementation ARViewController

@synthesize overlayView;
@synthesize marker;
@synthesize toMap;
@synthesize xValue;
@synthesize infoMarker;

@synthesize picker;
@synthesize locationManager;
@synthesize rootController;
@synthesize userLocation;
@synthesize markerLocation;

@synthesize angle;




-(void) mapView:(id)sender {
	[self.picker dismissModalViewControllerAnimated:YES];
	[self.rootController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
	
	self.picker = [[[UIImagePickerController alloc] init] autorelease];
	self.picker.delegate=self;
	self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	self.picker.showsCameraControls = NO;
	self.picker.navigationBarHidden = YES;
	self.picker.wantsFullScreenLayout = YES;
	self.picker.cameraViewTransform = CGAffineTransformScale(self.picker.cameraViewTransform, CAMERA_TRANSFORM_X, CAMERA_TRANSFORM_Y);
	self.picker.cameraOverlayView = self.overlayView;
	[self presentModalViewController:self.picker animated:NO];
	[self.picker release];
	
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationManager.distanceFilter=1;//l'aggiornamento della posizione avverrà di metro in metro
	[self.locationManager startUpdatingHeading];
	[self.locationManager startUpdatingLocation];
	[self calculatePosition:self.locationManager.heading.trueHeading];
	
	self.infoMarker.imageView.center=self.marker.center;
	
	[super viewDidAppear:YES];
}

-(void)infoButtonPushed:(id)sender{
	double meters=[userLocation distanceFromLocation:markerLocation];
    
    NSString *coordmark=[[NSString alloc] initWithFormat:@"(%g°;%g°)",markerLocation.coordinate.longitude,markerLocation.coordinate.latitude];
    
    NSString *coordpos=[[NSString alloc] initWithFormat:@"(%g°;%g°)",userLocation.coordinate.longitude,userLocation.coordinate.latitude];
    
	NSString *message =[[NSString alloc] initWithFormat: @"Il marker è visualizzato esattamente nella posizione geografica che tu hai scielto con il mirino, le sue coordinate sono \n %@ e dista %.2f metri dalla tua posizione che ha le seguenti coordinate \n %@.",coordmark,meters,coordpos];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Marker Information" message:message  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];  
	[alert show];
    [coordmark release];
    [coordpos release];
    [message release];
	[alert release];
}


-(void)calculatePosition:(CLLocationDirection) heading
{
	
	// Posizione del marker 
	float markerPosValue = [self angleBetweenCoordinate1:markerLocation.coordinate AndCoordinate2:userLocation.coordinate];
	[self.xValue setText:[NSString stringWithFormat:@"%.1f", markerPosValue]];
	
	// Valore dell'heading, reale
	float simHeadingValue = heading; 
	
	// Posizione del marker rispetto l'heading
	float markerOffset= markerPosValue - simHeadingValue;
	// Segno dell'offset
	float offsetSign=(markerOffset<0)?-1:1;
	// Valore assoluto dell'offset
	float offsetABS = markerOffset * offsetSign; 
	// Gestione del caso in cui heading e marker sono in due emisferi diversi
	if(offsetABS>180) { offsetABS = 360 - offsetABS; offsetSign *= -1; } 
	
	// Se il marker è nel cono visivo
	if(offsetABS<40)
		{
		float markerScreenPos = 136 + offsetABS*offsetSign*9; 
		
		[self.marker setFrame:CGRectMake(markerScreenPos, 146, marker.frame.size.width, marker.frame.size.height)];
		self.infoMarker.frame = CGRectMake(markerScreenPos, 146, self.infoMarker.frame.size.width, self.infoMarker.frame.size.height);
		
		self.marker.hidden=NO;
		self.infoMarker.hidden = NO;
		}
	else 
		{
		self.marker.hidden=YES;
		}
}

// calcola l'angolo tra me e il marker utilizzando le coordinate geografiche
-(double) angleBetweenCoordinate1:(CLLocationCoordinate2D)mark
				   AndCoordinate2:(CLLocationCoordinate2D)user{
	
	double differenceLongitude = mark.longitude - user.longitude;
	double y = sin(-differenceLongitude) * cos(mark.latitude);
	double x = cos(user.latitude) * sin(mark.latitude) - sin(user.latitude) * cos(mark.latitude) * cos(-differenceLongitude);
	double bearing = atan2(y, x);
	
	bearing = fmodf(bearing * 180.0 / M_PI + 360.0, 360.0);
	
	return bearing;		
}
-(void) viewDidDisappear:(BOOL)animated{
	self.picker =nil;
	[super viewDidDisappear:YES];
	
}



// This delegate method is invoked when the location manager has heading data.
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
	//calcolo il nuovo centro del il marker 
	[self calculatePosition:self.locationManager.heading.trueHeading];
	
}

//metodo del delegato per gestire l'evento scaturito da un aggiornamento della posizione dell'utente

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	self.userLocation = newLocation;
	[self calculatePosition:self.locationManager.heading.trueHeading];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.locationManager=nil;
	self.picker = nil;
}


- (void)dealloc {
	[overlayView release];
	[marker release];
	[toMap release];
	[picker release];
	[locationManager stopUpdatingLocation];
	[locationManager stopUpdatingHeading];
    [locationManager release];
	[super dealloc];
}


@end
