//
//  TestARAppViewController.m
//  TestARApp
//
//  Created by Massimo Donati on 03/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TestARAppViewController.h"




@implementation TestARAppViewController


@synthesize mapView;
@synthesize sight;
@synthesize buttonAR;
@synthesize locationManager;
@synthesize arView;
@synthesize visibility;

@synthesize tapRec;

@synthesize sightPos;
@synthesize userPos;


- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.headingFilter = kCLHeadingFilterNone;
	self.locationManager.delegate=self;
	[self.locationManager startUpdatingHeading];
	[self.locationManager startUpdatingLocation];
	self.arView=nil;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	if ([CLLocationManager headingAvailable] == NO) {
        
		// L'applicazione non può funzionare senza magnetometro e quindi visualizzo una finestra di allerta che avvisi della mancanza.
        
        self.locationManager = nil;
        UIAlertView *noBussola = [[UIAlertView alloc] initWithTitle:@"Bussola non presente!" message:@"La bussola non è presente nel dispositivo, non sarà possibile utilizzare l'applicazione senza." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noBussola show];
        [noBussola release];
        
	} else {
		UIAlertView *instruction = [[UIAlertView alloc] initWithTitle:@"Istruzioni" message:@"Tocca la mappa per posizionare il mirino su un punto di tuo interesse e poi clicca sul tasto \"Realtà Aumentata\" per vedere dove lo hai posizionato nella realtà. E' possibile inoltre utilizzare le gestualità standard per fare zoom in e out sulla mappa." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [instruction show];
        [instruction release];
		
    }
	
	
	self.mapView.showsUserLocation=YES;
	self.mapView.zoomEnabled=YES;
	self.mapView.delegate=self;
	
	MKCoordinateRegion region=MKCoordinateRegionMake(self.locationManager.location.coordinate, MKCoordinateSpanMake(0.0f, 0.0f));
	[self.mapView setCenterCoordinate:self.locationManager.location.coordinate animated:YES];
	[self.mapView setRegion:region animated:YES];
	[self.mapView addSubview:sight];
	[self.mapView addSubview:visibility];
	
	UIGestureRecognizer *recognizer;
	
	//Crea un UITapRecognizer e lo aggiunge alla Mappa
	recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
	recognizer.delegate = self;
	[self.mapView addGestureRecognizer:recognizer];
    self.tapRec = (UITapGestureRecognizer *)recognizer;
	[recognizer release];
	
}


- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
	
	CGPoint location = [recognizer locationInView:mapView];
	self.sight.center=location;
	self.sight.hidden=NO;
	
	CLLocationCoordinate2D temp=[self.mapView convertPoint:self.sight.center toCoordinateFromView:self.mapView];
	CLLocation *sightpo= [[CLLocation alloc] initWithLatitude:temp.latitude longitude:temp.longitude];
	self.sightPos=sightpo;
	[sightpo release];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	
	UIAlertView *noPosition = [[UIAlertView alloc] initWithTitle:@"Errore ricerca posizione" message:@"Si è verificato un errore nella ricerca della posizione attuale" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[noPosition show];
	[noPosition release];
	
}
-(IBAction) switchToAR:(id)sender{
	if (self.sight.hidden) {
		UIAlertView *noSight = [[UIAlertView alloc] initWithTitle:@"Mirino non presente" message:@"Tocca il display per posizionare il mirino." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noSight show];
        [noSight release];
		return;
	}
	[self.locationManager stopUpdatingHeading];
	[self.locationManager stopUpdatingLocation];
	
	ARViewController *arcontroller = [[ARViewController alloc] initWithNibName:@"ARView" bundle:nil];
	self.arView = arcontroller;
	[arcontroller release];
	self.arView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	self.arView.locationManager=self.locationManager;
	self.arView.rootController = self;
	self.arView.userLocation= self.userPos;
	self.arView.markerLocation= self.sightPos;
	
	//visualizzo la vista controllando se il dispositivo possiede una videocamera
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
		[self presentModalViewController:self.arView animated:YES];
	}
	else
		{
		UIAlertView *noCamera = [[UIAlertView alloc] initWithTitle:@"Videocamera non presente!" message:@"La Videocamera non è presente nel dispositivo, non sarà possibile utilizzare l'applicazione senza." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noCamera show];
        [noCamera release];
		}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
	//mantengo il mirino nel punto (legato alle coordinate geografiche) esatto dove l'ho posizionato
	self.sight.center= [self.mapView convertCoordinate:self.sightPos.coordinate toPointToView:self.mapView];
	
	//metodo per aggiornare l'orientamento della mappa con i dati aggiornati dalla bussola
	[self.mapView setTransform:CGAffineTransformMakeRotation(2*M_PI-(self.locationManager.heading.trueHeading*M_PI/180))];
	
	
}

- (void)mapView:(MKMapView *)map didUpdateUserLocation:(MKUserLocation *)userLocation{
	
	
	//setto le coordinate dell'utente
	CLLocationCoordinate2D temp=self.locationManager.location.coordinate;
	CLLocation *upos=[[CLLocation alloc] initWithLatitude:temp.latitude longitude:temp.longitude];
	self.userPos=upos;
	[upos release];
	[self.mapView setCenterCoordinate:self.locationManager.location.coordinate animated:YES];
	self.visibility.center= [self.mapView convertCoordinate:self.userPos.coordinate toPointToView:self.mapView];
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
	//self.mapView=nil;
}


- (void)dealloc {
	[mapView release];
	[arView release];
	[sight release];
	// termino di utilizzare il magnetometro
	[locationManager stopUpdatingHeading];
	[locationManager stopUpdatingLocation];
    [locationManager release];
	[super dealloc];
}

@end
