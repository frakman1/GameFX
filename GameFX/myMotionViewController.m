//
//  myMotionViewController.m
//  LIFX Watch Remote
//
//  Created by Mark Aufflick on 19/11/2014.
//  Copyright (c) 2014 The High Technology Bureau. All rights reserved.
//

#import "myMotionViewController.h"
#import "LightDataSource.h"
#import <LIFXKit/LIFXKit.h>
#import <CoreMotion/CoreMotion.h>


@interface myMotionViewController () <UITableViewDataSource, UITableViewDelegate, LightDataSourceDelegate,LFXLightObserver>
{
    
    //IBOutlet UIButton 	*startButton;
    UIImage *redImage;
    UIImage *greenImage;
    CGFloat Rotation;
    CGFloat savedRotation;
    
}
@property (nonatomic, strong) LightDataSource * dataSource;

@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (weak, nonatomic) IBOutlet UISlider * brightnessSlider;
@property (weak, nonatomic) IBOutlet UISlider * kelvinSlider;
@property (weak, nonatomic) IBOutlet UILabel * lightNameLabel;
@property (nonatomic, strong) LFXLight * selectedLight;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray * controlsToDisable;
@property (weak, nonatomic) IBOutlet UISwitch * onOffSwitch;

@property (weak, nonatomic) IBOutlet UISlider * rollSlider;
@property (weak, nonatomic) IBOutlet UISlider * pitchSlider;
@property (weak, nonatomic) IBOutlet UISlider * yawSlider;

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSOperationQueue *deviceQueue;
@property (weak,nonatomic) IBOutlet UIButton *motionButton;
@property (weak,nonatomic) IBOutlet UIButton *effectButton;

@property (weak, nonatomic) IBOutlet UIView *testView;
//-(void)handleDoubleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;
//-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;

//-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;
//-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;

//-(void)handleRotationWithGestureRecognizer:(UIRotationGestureRecognizer *)rotationGestureRecognizer;


//@property (weak, nonatomic) IBOutlet UIView *viewOrange;
//@property (weak, nonatomic) IBOutlet UIView *viewBlack;
//@property (weak, nonatomic) IBOutlet UIView *viewGreen;


@end

@implementation myMotionViewController

#pragma mark - View Lifecycle
NSTimer *t2;
BOOL gLightState2=YES;
LFXHSBKColor *gColor2;


- (BOOL) prefersStatusBarHidden {return YES;}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (motion == UIEventSubtypeMotionShake)
    {
        LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
        static LFXHSBKColor *savedColor;
        
        NSLog(@"***SHAKE SHAKE SHAKE***");
        gLightState2 = !gLightState2; NSLog(@"lightState:%d",gLightState2);
        [localNetworkContext.allLightsCollection setPowerState:gLightState2];
        
        for (LFXLight *aLight in localNetworkContext.allLightsCollection)
        {
            if (gLightState2 == LFXPowerStateOn)
            {
                NSLog(@"In ON");
                savedColor = gColor2;
                savedColor.brightness=1;
                [aLight setColor:gColor2 ];
            }
            else
            {
                NSLog(@"In OFF");
                savedColor = aLight.color;
            }
            
            //LFXHSBKColor *color = [LFXHSBKColor colorWithHue:arc4random()%360 saturation:1.0 brightness:1.0];
            //aLight.color.brightness=1;
        }
        //LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
        //self.selectedLight.powerState = sender.on ? LFXPowerStateOn : LFXPowerStateOff;
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedLight = nil;
    self.dataSource = [[LightDataSource alloc] init];
    self.dataSource.delegate = self;
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // set up start button
    greenImage = [[UIImage imageNamed:@"green_button.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
    redImage = [[UIImage imageNamed:@"red_button.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
    
    //setup motion detector
    self.deviceQueue = [[NSOperationQueue alloc] init];
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 5.0 / 60.0;
    self.motionManager.gyroUpdateInterval = 0.1;
    //[[gColor alloc] init];
    
    LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
    
    for (LFXLight *aLight in localNetworkContext.allLightsCollection)
    {
        
        [aLight addLightObserver:self];
    }
    
    // UIDevice *device = [UIDevice currentDevice];
    
    /*
     [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
     toQueue:self.deviceQueue
     withHandler:^(CMDeviceMotion *motion, NSError *error)
     {
     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
     CGFloat x = motion.gravity.x;
     CGFloat y = motion.gravity.y;
     CGFloat z = motion.gravity.z;
     
     CGFloat Roll = motion.attitude.roll * 180 / M_PI;
     //NSLog(@"Pitch %f ",motion.attitude.pitch * 180 / M_PI);
     NSLog(@"Roll  %f ",motion.attitude.roll * 180 / M_PI);
     //NSLog(@"Yaw   %f ",motion.attitude.yaw * 180 / M_PI);
     
     //NSLog(@"x %f ",x);
     //NSLog(@"y %f ",y);
     //NSLog(@"z %f ",z);
     self.rollSlider.value = Roll;
     
     
     }];
     }];
     
     
     */
    //Tap/Gesture handlers
    /*
     UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
     [self.testView addGestureRecognizer:singleTapGestureRecognizer];
     //
     UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
     doubleTapGestureRecognizer.numberOfTapsRequired = 2;
     doubleTapGestureRecognizer.numberOfTouchesRequired = 2;
     [self.testView addGestureRecognizer:doubleTapGestureRecognizer];
     */
    /*
     UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
     swipeRightOrange.direction = UISwipeGestureRecognizerDirectionRight;
     UISwipeGestureRecognizer *swipeLeftOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
     swipeLeftOrange.direction = UISwipeGestureRecognizerDirectionLeft;
     [self.viewOrange addGestureRecognizer:swipeRightOrange];
     [self.viewOrange addGestureRecognizer:swipeLeftOrange];
     
     UISwipeGestureRecognizer *swipeRightBlack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
     swipeRightBlack.direction = UISwipeGestureRecognizerDirectionRight;
     [self.viewBlack addGestureRecognizer:swipeRightBlack];
     
     UISwipeGestureRecognizer *swipeLeftGreen = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
     swipeLeftGreen.direction = UISwipeGestureRecognizerDirectionLeft;
     [self.viewGreen addGestureRecognizer:swipeLeftGreen];
     */
    /*
     UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationWithGestureRecognizer:)];
     [self.testView addGestureRecognizer:rotationGestureRecognizer];
     Rotation = 0;
     savedRotation = 0;
     */
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
 -(void)handleRotationWithGestureRecognizer:(UIRotationGestureRecognizer *)rotationGestureRecognizer{
 self.testView.transform = CGAffineTransformRotate(self.testView.transform, rotationGestureRecognizer.rotation);
 Rotation = savedRotation;
 Rotation = (rotationGestureRecognizer.rotation) * 180 / M_PI;
 NSLog(@"rotation: %f",Rotation);
 CGFloat hue = (Rotation + 90)*2;
 
 
 LFXHSBKColor *colour = [LFXHSBKColor colorWithHue:hue saturation:self.selectedLight.color.saturation brightness:self.selectedLight.color.brightness];
 [self.selectedLight setColor:colour];
 
 savedRotation = Rotation;
 //rotationGestureRecognizer.rotation = 0.0;
 }
 
 */
/*
 -(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer
 {
 [UIView animateWithDuration:0.1 animations:^{
 self.viewOrange.frame = CGRectOffset(self.viewOrange.frame, 320.0, 0.0);
 self.viewBlack.frame = CGRectOffset(self.viewBlack.frame, 320.0, 0.0);
 self.viewGreen.frame = CGRectOffset(self.viewGreen.frame, 320.0, 0.0);
 }];
 }
 
 -(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer
 {
 [UIView animateWithDuration:0.1 animations:^{
 self.viewOrange.frame = CGRectOffset(self.viewOrange.frame, -320.0, 0.0);
 self.viewBlack.frame = CGRectOffset(self.viewBlack.frame, -320.0, 0.0);
 self.viewGreen.frame = CGRectOffset(self.viewGreen.frame, -320.0, 0.0);
 }];
 }
 */
/*
 -(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer{
 CGFloat newWidth = 100.0;
 NSLog(@"width1:%f",self.testView.frame.size.width);
 if (self.testView.frame.size.width == 100.0) {
 newWidth = 200.0;
 }
 NSLog(@"width2:%f",self.testView.frame.size.width);
 
 CGPoint currentCenter = self.testView.center;
 
 self.testView.frame = CGRectMake(self.testView.frame.origin.x, self.testView.frame.origin.y, newWidth, self.testView.frame.size.height);
 self.testView.center = currentCenter;
 }
 
 -(void)handleDoubleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer{
 CGSize newSize = CGSizeMake(100.0, 100.0);
 if (self.testView.frame.size.width == 100.0) {
 newSize.width = 200.0;
 newSize.height = 200.0;
 }
 
 CGPoint currentCenter = self.testView.center;
 
 self.testView.frame = CGRectMake(self.testView.frame.origin.x, self.testView.frame.origin.y, newSize.width, newSize.height);
 self.testView.center = currentCenter;
 }
 */
/*
 -(void)outputMotionData:(CMDeviceMotion*)motion
 {
 CGFloat Roll = motion.attitude.roll * 180 / M_PI;
 //NSLog(@"Pitch %f ",motion.attitude.pitch * 180 / M_PI);
 NSLog(@"Roll  %f ",motion.attitude.roll * 180 / M_PI);
 //NSLog(@"Yaw   %f ",motion.attitude.yaw * 180 / M_PI);
 
 //NSLog(@"x %f ",x);
 //NSLog(@"y %f ",y);
 //NSLog(@"z %f ",z);
 self.rollSlider.value = Roll;
 
 
 }
 */
- (void)setSelectedLight:(LFXLight *)selectedLight
{
    _selectedLight = selectedLight;
    
    if (nil == selectedLight)
    {
        for (UIView * view in self.controlsToDisable) [(id)view setEnabled:NO];
        
        self.onOffSwitch.on = NO;
        self.lightNameLabel.text = @"None Selected";
    }
    else
    {
        for (UIView * view in self.controlsToDisable) [(id)view setEnabled:YES];
        
        self.lightNameLabel.text = selectedLight.label;
        self.onOffSwitch.on = selectedLight.powerState == LFXPowerStateOn;
        
        LFXHSBKColor * colour = selectedLight.color;
        self.brightnessSlider.value = colour.brightness;
        self.kelvinSlider.value = colour.kelvin;
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)effectButtonPressed:(id)sender
{
    NSLog(@"Effect Pressed");
    UIButton *touchedButton = (UIButton*) sender;
    //lightState = 1;
    //select the touched button
    [self performSelector:@selector(flipButton2:) withObject:sender afterDelay:0.0];
    
    if(self.effectButton != nil)
    {   //check to see if a button is selected...
        [self flipButton2:self.effectButton];
        
        self.effectButton = touchedButton;
    }
    
}
- (void) flipButton2:(UIButton*) button
{
    
    if(button.selected)
    {
        [button setSelected:NO];
        //turn off stuff here
        
        [t2 invalidate];
        t2 = nil;
        
    }
    else
    {
        [button setSelected:YES];
        t2 = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector:@selector(onTick:) userInfo: nil repeats:YES];
        
    }
    NSLog(@"Selected?: %d",self.effectButton.selected);
}


CGFloat gBrightness2=0;
CGFloat gHue=0;
CGFloat gSaturation=0;

-(void)onTick:(NSTimer *)timer
{
    NSLog(@"Tick..");
    
    
    gBrightness2= 1;      if (gBrightness2>1) gBrightness2=1;if (gBrightness2<0) gBrightness2=0;
    gHue = gHue+5;               if (gHue>360) gHue=0;if (gHue<0) gHue=360;
    gSaturation = 0.85; if (gSaturation>1) gSaturation=1;if (gSaturation<0) gSaturation=0;
    
    LFXHSBKColor *colour = [LFXHSBKColor colorWithHue:gHue saturation:gSaturation brightness:gBrightness2];
    
    LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
    [localNetworkContext.allLightsCollection setColor:colour];
    
    // change test UIview background colour to indicate change on device screen
    self.testView.backgroundColor= [UIColor colorWithHue:(gHue/360.0) saturation:gSaturation brightness:gBrightness2 alpha:1];
    
}

- (IBAction)motionButtonPressed:(id)sender
{
    NSLog(@"Motion Pressed");
    UIButton *touchedButton = (UIButton*) sender;
    
    //lightState = 1;
    //select the touched button
    [self performSelector:@selector(flipButton:) withObject:sender afterDelay:0.0];
    
    if(self.motionButton != nil)
    {   //check to see if a button is selected...
        [self flipButton:self.motionButton];
        
        self.motionButton = touchedButton;
    }
    
    
}

- (void) flipButton:(UIButton*) button
{
    if(button.selected)
    {
        [button setSelected:NO];
        [self.motionManager stopDeviceMotionUpdates];
        NSLog(@"STOPPING MOTION UPDATES");
        
    }
    else
    {
        [button setSelected:YES];
        //        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
        //                                                                toQueue:self.deviceQueue
        //                                                            withHandler:^(CMDeviceMotion *motion, NSError *error)
        //         {
        //             [self outputMotionData:motion];
        //
        //         }];
        
        
        
        //        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
        //                                     withHandler:^(CMDeviceMotion *data, NSError *error)
        //        {
        //                                         if (data.userAcceleration.x < -2.5f)
        //                                         {
        //                                             NSLog(@"OUCH!");
        //                                         }
        //        }];
        
        
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
                                                                toQueue:self.deviceQueue
                                                            withHandler:^(CMDeviceMotion *motion, NSError *error)
         {
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 
                 CGFloat brightness;
                 CGFloat hue;
                 CGFloat saturation;
                 
                 if (motion.userAcceleration.x < -2.0f)
                 {
                     NSLog(@"***********************************OUCH!");
                 }
                 
                 
                 
                 CGFloat Roll =  motion.attitude.roll  * 180 / M_PI;
                 CGFloat Pitch = motion.attitude.pitch * 180 / M_PI;
                 CGFloat Yaw =   motion.attitude.yaw * 180 / M_PI;    if (Yaw>90)Yaw=90;
                 
                 //NSLog(@"Pitch %f ",motion.attitude.pitch * 180 / M_PI);
                 NSLog(@"Roll  %f ",Roll);
                 NSLog(@"Pitch %f ",Pitch);
                 NSLog(@"Yaw %f ",Yaw);
                 
                 //NSLog(@"Yaw   %f ",motion.attitude.yaw * 180 / M_PI);
                 
                 //NSLog(@"x %f ",x);
                 //NSLog(@"y %f ",y);
                 //NSLog(@"z %f ",z);
                 self.rollSlider.value = Roll;
                 self.pitchSlider.value = Pitch;
                 self.yawSlider.value = Yaw;
                 
                 brightness= (Roll+90.0)/180.0;      if (brightness>1) brightness=1;if (brightness<0) brightness=0;
                 hue = (Pitch + 90)*2;               if (hue>360) hue=360;if (hue<0) hue=0;
                 saturation = fabs((Yaw-90.0)/180.0); if (saturation>1) saturation=1;if (saturation<0) saturation=0;
                 
                 NSLog(@"brightness:%f",brightness);
                 NSLog(@"hue:%f",hue);
                 NSLog(@"saturation:%f",saturation);
                 //self.selectedLight.color.brightness = brightness;
                 
                 LFXHSBKColor *colour = [LFXHSBKColor colorWithHue:hue saturation:saturation brightness:brightness];
                 gColor2 = colour;
                 //LFXHSBKColor * colour = self.selectedLight.color;
                 //[color colorWithBrightness:<#(CGFloat)#>]
                 //colour.brightness = brightness;
                 //colour.hue = hue;
                 //[self.selectedLight
                 //NSLog(@"LIFX brightness:%f",self.selectedLight.color.brightness);
                 
                 //[self.selectedLight setColor:colour];
                 
                 LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
                 [localNetworkContext.allLightsCollection setColor:colour];
                 
                 // change test UIview background colour to indicate change on device screen
                 self.testView.backgroundColor= [UIColor colorWithHue:(hue/360.0) saturation:saturation brightness:brightness alpha:1];
                 
                 
             }];
         }];
        
        
    }
    NSLog(@"Selected?: %d",self.motionButton.selected);
    
}

//self.motionButton.selected = !self.motionButton.selected;

//[self.motionButton setImage:greenImage forState:UIControlStateSelected];
//[self.motionButton setTitle:@"ON"];
//[self.button setBackgroundColor:[UIColor greenColor]];

//   - (void) methodThatYourButtonCalls: (id) sender {


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



#pragma mark - IBActions

- (IBAction)brightnessOrKelvinChanged:(UISlider *)sender
{
    
    LFXHSBKColor *colour = [LFXHSBKColor colorWithHue:self.selectedLight.color.hue
                                           saturation:self.selectedLight.color.saturation
                                           brightness:self.brightnessSlider.value
                                               kelvin:self.kelvinSlider.value];
    
    // LFXHSBKColor * colour = [LFXHSBKColor whiteColorWithBrightness:self.brightnessSlider.value
    //                                                         kelvin:self.kelvinSlider.value];
    self.selectedLight.color = colour;
}

- (IBAction)onOff:(UISwitch *)sender
{
    self.selectedLight.powerState = sender.on ? LFXPowerStateOn : LFXPowerStateOff;
}

#pragma mark - LightDataSourceDelegate

- (void)lightDataSource:(LightDataSource *)lightSource didInsertLightAtIndex:(NSInteger)idx
{
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)lightDataSource:(LightDataSource *)lightSource didRemoveLightAtIndex:(NSInteger)idx
{
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)light:(LFXLight *)light didChangeColor:(LFXHSBKColor *)color
{
    
    gColor2 = color;
    NSLog(@"Color Change Detected.Hue:%f Brightness:%f Saturation:%f ",color.hue,color.brightness,color.saturation);
}

#pragma mark - TableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LightCell"];
    cell.textLabel.text = [self.dataSource.lights[indexPath.row] label];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedLight = self.dataSource.lights[indexPath.row];
}

@end
