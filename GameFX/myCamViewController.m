//
//  myCamViewController.m
//  GameFX
//
//  Created by alnaumf on 6/18/15.
//  Copyright (c) 2015 Fraksoft. All rights reserved.
//

#import "myCamViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "AVCamPreviewView.h"
#import <LIFXKit/LIFXKit.h>
#import "UIImageAverageColorAddition.h"
#import <MediaPlayer/MediaPlayer.h>

#import "SCAudioMeter.h"


static void * CapturingStillImageContext = &CapturingStillImageContext;
static void * RecordingContext = &RecordingContext;
static void * SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;


@interface myCamViewController () <AVCaptureFileOutputRecordingDelegate>

// For use in the storyboards.
@property (nonatomic, weak) IBOutlet AVCamPreviewView *previewView;
@property (nonatomic, weak) IBOutlet UIButton *recordButton;
@property (nonatomic, weak) IBOutlet UIButton *cameraButton;
@property (nonatomic, weak) IBOutlet UIButton *stillButton;
@property (nonatomic,weak) IBOutlet UILabel* myLabel;

@property (nonatomic, strong) UISlider *volumeSlider;

- (IBAction)toggleMovieRecording:(id)sender;
- (IBAction)changeCamera:(id)sender;
- (IBAction)snapStillImage:(id)sender;
- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer;

// Session management.
@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;



// Utilities.
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic) BOOL lockInterfaceRotation;
@property (nonatomic) id runtimeErrorHandlingObserver;


@property (nonatomic, strong) SCAudioMeter *audioMeter;

@end

@implementation myCamViewController

AVAudioRecorder* recorder;
NSTimer *camTimer;
//UIImage *gImage;
UIColor *gcamColor ;
UIColor* gcamAverageColor;
CGFloat red, green, blue;
CGFloat hue, saturation, brightness, alpha;
LFXHSBKColor *gcamLifxColor;

//LFXHSBKColor *gColor;

-(void) camTick:(NSTimer *)timer
{
/*
    float pkpower = 0;
    float avgpower = 0;
    double pkpercentage = 0;
    double avgpercentage = 0;
*/
    //NSLog(@"camTick..");
#if !(TARGET_IPHONE_SIMULATOR)
    //take screenshot
     [self snapStillImage:self.view];
#endif
    // calculate volume meter levels
    //-------------------------------
 /*
    [recorder updateMeters];
    pkpower = [recorder peakPowerForChannel:0];
    avgpower = [recorder averagePowerForChannel:0];
    pkpercentage = pow (10, (0.05 * pkpower));
    avgpercentage = pow (10, (0.05 * avgpower));
    
    //Log the peak and average power
    NSLog(@"pkPower:%0.2f avgPower:%0.2f pkPct:%0.2f avgPct:%0.2f", pkpower,avgpower,pkpercentage,avgpercentage);
 */

    //process image
    //Calculate merged background color.
    //set background label color and LIFX to that
    //-------------------------------
    
    //CGFloat hue, saturation, brightness, alpha;
    //LFXHSBKColor *lifxColor;
    //UIColor *tmpColor;
    
    //tmpColor = [gImage mergedColor];
    //[tmpColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    //NSLog(@"%@",[NSString stringWithFormat:@"average color: %.2f %.2f %.2f", red, green, blue]);
    //[self.myLabel.backgroundColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    //NSLog(@"%@",[NSString stringWithFormat:@"hue: %.2f saturation: %.2f  brightness: %.2f alpha: %.2f", hue, saturation, brightness, alpha]);
    //lifxColor = [LFXHSBKColor colorWithHue:(hue*360) saturation:saturation brightness:avgpercentage+0.2];
    //gColor = [LFXHSBKColor colorWithHue:(pkpercentage*360) saturation:avgpercentage brightness:avgpercentage+0.3];
    //gColor = [LFXHSBKColor colorWithHue:gColor.hue saturation:gColor.saturation brightness:gBrightness];
    
    
    //LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
    //[localNetworkContext.allLightsCollection setColor:lifxColor];
    
    // change test UIview background colour to indicate change on device screen
    //self.myLabel.backgroundColor = [UIColor colorWithHue:(lifxColor.hue/360.0) saturation:lifxColor.saturation brightness:avgpercentage alpha:1];
    
    
    
    
    
   
/*
    UIWindow *keyWindow = self.previewView.window;
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //UIImage *capturedScreen = [self pb_takeSnapshot ];
    UIColor* averageColor = [capturedScreen mergedColor];
    CGFloat red, green, blue;
    CGFloat hue, saturation, brightness, alpha;
    LFXHSBKColor *lifxColor;
    
    [averageColor getRed:&red green:&green blue:&blue alpha:NULL];
    [averageColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
    [localNetworkContext.allLightsCollection setPowerState:LFXPowerStateOn];
    lifxColor = [LFXHSBKColor colorWithHue:(hue*360) saturation:saturation brightness:brightness];
    [localNetworkContext.allLightsCollection setColor:lifxColor overDuration:1];
    
    self.myLabel.backgroundColor = [capturedScreen mergedColor];
    NSLog(@"red:%f  green:%f  blue:%f",red,green,blue);
  */
    
    
    
}



- (BOOL)isSessionRunningAndDeviceAuthorized
{
    return [[self session] isRunning] && [self isDeviceAuthorized];
}

+ (NSSet *)keyPathsForValuesAffectingSessionRunningAndDeviceAuthorized
{
    return [NSSet setWithObjects:@"session.running", @"deviceAuthorized", nil];
}

- (void)checkDeviceAuthorizationStatus
{
    NSString *mediaType = AVMediaTypeVideo;
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted)
        {
            //Granted access to mediaType
            [self setDeviceAuthorized:YES];
        }
        else
        {
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"AVCam!"
                                            message:@"AVCam doesn't have permission to use Camera, please change privacy settings"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                [self setDeviceAuthorized:NO];
            });
        }
    }];
}

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the AVCaptureSession
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [self setSession:session];
    
    // Setup the preview view
    [[self previewView] setSession:session];
    
    // Check for device authorization
    [self checkDeviceAuthorizationStatus];
    
    // In general it is not safe to mutate an AVCaptureSession or any of its inputs, outputs, or connections from multiple threads at the same time.
    // Why not do all of this on the main queue?
    // -[AVCaptureSession startRunning] is a blocking call which can take a long time. We dispatch session setup to the sessionQueue so that the main queue isn't blocked (which keeps the UI responsive).
    
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self setSessionQueue:sessionQueue];
    
    dispatch_async(sessionQueue, ^{
        [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
        
        NSError *error = nil;
        
        AVCaptureDevice *videoDevice = [myCamViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (error)
        {
            NSLog(@"%@", error);
        }
        
        if ([session canAddInput:videoDeviceInput])
        {
            [session addInput:videoDeviceInput];
            [self setVideoDeviceInput:videoDeviceInput];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Why are we dispatching this to the main queue?
                // Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView can only be manipulated on main thread.
                // Note: As an exception to the above rule, it is not necessary to serialize video orientation changes on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
                
                [[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)[self interfaceOrientation]];
            });
        }
        
        AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        
        if (error)
        {
            NSLog(@"%@", error);
        }
        
        if ([session canAddInput:audioDeviceInput])
        {
            [session addInput:audioDeviceInput];
        }
        
        AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        if ([session canAddOutput:movieFileOutput])
        {
            [session addOutput:movieFileOutput];
            AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            if ([connection isVideoStabilizationSupported])
                [connection setEnablesVideoStabilizationWhenAvailable:YES];
            [self setMovieFileOutput:movieFileOutput];
        }
        
        AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        if ([session canAddOutput:stillImageOutput])
        {
            [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
            [session addOutput:stillImageOutput];
            [self setStillImageOutput:stillImageOutput];
        }
    });
    
 /*
    NSDictionary* recorderSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                                      [NSNumber numberWithInt:44100],AVSampleRateKey,
                                      [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                      [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                      nil];
    NSError* error = nil;
    recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"]]  settings:recorderSettings error:&error];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    //[recorder setDelegate:self];
    [recorder record];
    NSError *recorderror;
    [[AVAudioSession sharedInstance]
     setCategory:AVAudioSessionCategoryPlayAndRecord error:&recorderror];
    
    if (recorderror) {
        NSLog(@"Error setting category: %@", [recorderror description]);
    }

    //gImage = [[UIImage alloc] initWithCGImage: gImage.CGImage];
    gcamColor = [UIColor greenColor] ;
*/
    self.audioMeter = [[SCAudioMeter alloc] initWithSamplePeriod:0.05];
    
}


- (void)MicReadOnSeparateThread
{
    NSLog(@"MicReadOnSeparateThread");
   
}

- (void)viewWillAppear:(BOOL)animated
{
    dispatch_async([self sessionQueue], ^{
        [self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:SessionRunningAndDeviceAuthorizedContext];
        [self addObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:CapturingStillImageContext];
        [self addObserver:self forKeyPath:@"movieFileOutput.recording" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:RecordingContext];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
        
        __weak myCamViewController *weakSelf = self;
        [self setRuntimeErrorHandlingObserver:[[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionRuntimeErrorNotification object:[self session] queue:nil usingBlock:^(NSNotification *note) {
            myCamViewController *strongSelf = weakSelf;
            dispatch_async([strongSelf sessionQueue], ^{
                // Manually restarting the session since it must have been stopped due to an error.
                [[strongSelf session] startRunning];
                [[strongSelf recordButton] setTitle:NSLocalizedString(@"Record", @"Recording button record title") forState:UIControlStateNormal];
            });
        }]];
        [[self session] startRunning];
    });
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    //spawn average colour effect thread
    camTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector:@selector(camTick:) userInfo: nil repeats:YES];
    //NSLog(@"Launching MicReadOnSeparateThread");

    //[NSThread detachNewThreadSelector: @selector(MicReadOnSeparateThread) toTarget: self withObject:nil];
    [self.audioMeter beginAudioMeteringWithCallback:^(double value) {
        double dBValue = 10 * log10(value);
        double sanval = fabs(dBValue);
        double myval = (value+0.1) * 5; if (myval > 1) myval =1;
        NSLog(@"Value: %0.2f   dBValue:%0.2f  sanval:%0.2f  myval:%0.2f", value,dBValue,sanval,myval);
        //gcamLifxColor = [LFXHSBKColor colorWithHue:gcamLifxColor.hue saturation:gcamLifxColor.saturation brightness:myval];
        gcamLifxColor = [gcamLifxColor colorWithBrightness:myval];
        LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
        [localNetworkContext.allLightsCollection setColor:gcamLifxColor];
 
        
        
    }];
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
    
}





- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
    //[self.audioMeter.microphone stopFetchingAudio];
    [self.audioMeter endAudioMetering];
    [camTimer invalidate];
    camTimer = nil;
    //restore volume
    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    //find the volumeSlider
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
    [volumeViewSlider setValue:0.5f animated:YES];
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];

}


- (void)viewDidDisappear:(BOOL)animated
{
    dispatch_async([self sessionQueue], ^{
        [[self session] stopRunning];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
        [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
        
        [self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
        [self removeObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" context:CapturingStillImageContext];
        [self removeObserver:self forKeyPath:@"movieFileOutput.recording" context:RecordingContext];
    });
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    // Disable autorotation of the interface when recording is in progress.
    return ![self lockInterfaceRotation];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)toInterfaceOrientation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)runStillImageCaptureAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[self previewView] layer] setOpacity:0.0];
        [UIView animateWithDuration:.25 animations:^{
            [[[self previewView] layer] setOpacity:1.0];
        }];
    });
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == CapturingStillImageContext)
    {/*
        BOOL isCapturingStillImage = [change[NSKeyValueChangeNewKey] boolValue];
        
        if (isCapturingStillImage)
        {
            [self runStillImageCaptureAnimation];
        }
      */
    }
    else if (context == RecordingContext)
    {
        BOOL isRecording = [change[NSKeyValueChangeNewKey] boolValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRecording)
            {
                [[self cameraButton] setEnabled:NO];
                [[self recordButton] setTitle:NSLocalizedString(@"Stop", @"Recording button stop title") forState:UIControlStateNormal];
                [[self recordButton] setEnabled:YES];
            }
            else
            {
                [[self cameraButton] setEnabled:YES];
                [[self recordButton] setTitle:NSLocalizedString(@"Record", @"Recording button record title") forState:UIControlStateNormal];
                [[self recordButton] setEnabled:YES];
            }
        });
    }
    else if (context == SessionRunningAndDeviceAuthorizedContext)
    {
        BOOL isRunning = [change[NSKeyValueChangeNewKey] boolValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRunning)
            {
                [[self cameraButton] setEnabled:YES];
                [[self recordButton] setEnabled:YES];
                [[self stillButton] setEnabled:YES];
            }
            else
            {
                [[self cameraButton] setEnabled:NO];
                [[self recordButton] setEnabled:NO];
                [[self stillButton] setEnabled:NO];
            }
        });
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark UI

#pragma mark Actions

- (IBAction)toggleMovieRecording:(id)sender
{
    [[self recordButton] setEnabled:NO];
    
    dispatch_async([self sessionQueue], ^{
        if (![[self movieFileOutput] isRecording])
        {
            [self setLockInterfaceRotation:YES];
            
            if ([[UIDevice currentDevice] isMultitaskingSupported])
            {
                // Setup background task. This is needed because the captureOutput:didFinishRecordingToOutputFileAtURL: callback is not received until AVCam returns to the foreground unless you request background execution time. This also ensures that there will be time to write the file to the assets library when AVCam is backgrounded. To conclude this background execution, -endBackgroundTask is called in -recorder:recordingDidFinishToOutputFileURL:error: after the recorded file has been saved.
                [self setBackgroundRecordingID:[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil]];
            }
            
            // Update the orientation on the movie file output video connection before starting recording.
            [[[self movieFileOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] videoOrientation]];
            
            // Turning OFF flash for video recording
            [myCamViewController setFlashMode:AVCaptureFlashModeOff forDevice:[[self videoDeviceInput] device]];
            
            // Start recording to a temporary file.
            NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"movie" stringByAppendingPathExtension:@"mov"]];
            [[self movieFileOutput] startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
        }
        else
        {
            [[self movieFileOutput] stopRecording];
        }
    });
}

- (IBAction)changeCamera:(id)sender
{
    [[self cameraButton] setEnabled:NO];
    [[self recordButton] setEnabled:NO];
    [[self stillButton] setEnabled:NO];
    
    dispatch_async([self sessionQueue], ^{
        AVCaptureDevice *currentVideoDevice = [[self videoDeviceInput] device];
        AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
        AVCaptureDevicePosition currentPosition = [currentVideoDevice position];
        
        switch (currentPosition)
        {
            case AVCaptureDevicePositionUnspecified:
                preferredPosition = AVCaptureDevicePositionBack;
                break;
            case AVCaptureDevicePositionBack:
                preferredPosition = AVCaptureDevicePositionFront;
                break;
            case AVCaptureDevicePositionFront:
                preferredPosition = AVCaptureDevicePositionBack;
                break;
        }
        
        AVCaptureDevice *videoDevice = [myCamViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        
        [[self session] beginConfiguration];
        
        [[self session] removeInput:[self videoDeviceInput]];
        if ([[self session] canAddInput:videoDeviceInput])
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
            
            [myCamViewController setFlashMode:AVCaptureFlashModeAuto forDevice:videoDevice];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
            
            [[self session] addInput:videoDeviceInput];
            [self setVideoDeviceInput:videoDeviceInput];
        }
        else
        {
            [[self session] addInput:[self videoDeviceInput]];
        }
        
        [[self session] commitConfiguration];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self cameraButton] setEnabled:YES];
            [[self recordButton] setEnabled:YES];
            [[self stillButton] setEnabled:YES];
        });
    });
}


- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    dispatch_async([self sessionQueue], ^{
        AVCaptureDevice *device = [[self videoDeviceInput] device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
            {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
            {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    });
}

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ([device hasFlash] && [device isFlashModeSupported:flashMode])
    {
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    }
}

- (IBAction)snapStillImage:(id)sender
{
    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    //find the volumeSlider
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
    [volumeViewSlider setValue:0.0f animated:YES];
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async([self sessionQueue], ^{
        // Update the orientation on the still image output video connection before capturing.
        [[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] videoOrientation]];
        
        // Flash set to Auto for Still Capture..AVCaptureFlashModeOff AVCaptureFlashModeAuto
        [myCamViewController setFlashMode:AVCaptureFlashModeOff forDevice:[[self videoDeviceInput] device]];
        
        // Capture a still image.
        [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            
            if (imageDataSampleBuffer)
            {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage *image = [[UIImage alloc] initWithData:imageData];
 
                //******* process image
                NSLog(@"Process Image");
                self.myLabel.backgroundColor=[image mergedColor];
                [self.myLabel.backgroundColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
                LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
                gcamLifxColor = [LFXHSBKColor colorWithHue:(hue*360) saturation:saturation brightness:brightness];
                //[localNetworkContext.allLightsCollection setColor:gcamLifxColor overDuration:0.5];
                //********
              
                //[[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
            }
        }];
    });
}




- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint devicePoint = [(AVCaptureVideoPreviewLayer *)[[self previewView] layer] captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:[gestureRecognizer view]]];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)subjectAreaDidChange:(NSNotification *)notification
{
    CGPoint devicePoint = CGPointMake(.5, .5);
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

#pragma mark File Output Delegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (error)
        NSLog(@"%@", error);
    
    [self setLockInterfaceRotation:NO];
    
    // Note the backgroundRecordingID for use in the ALAssetsLibrary completion handler to end the background task associated with this recording. This allows a new recording to be started, associated with a new UIBackgroundTaskIdentifier, once the movie file output's -isRecording is back to NO — which happens sometime after this method returns.
    UIBackgroundTaskIdentifier backgroundRecordingID = [self backgroundRecordingID];
    [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
    
    [[[ALAssetsLibrary alloc] init] writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error)
            NSLog(@"%@", error);
        
        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
        
        if (backgroundRecordingID != UIBackgroundTaskInvalid)
            [[UIApplication sharedApplication] endBackgroundTask:backgroundRecordingID];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
