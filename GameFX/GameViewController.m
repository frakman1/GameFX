//
//  PandemicViewController.m
//  GameFX
//
//  Created by alnaumf on 4/14/15.
//  Copyright (c) 2015 Fraksoft. All rights reserved.
//

#import "GameViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView+Glow.h"
//#import <QuartzCore/QuartzCore.h>

//#import "SimpleAudioEngine.h"
//#import "cocos2d.h"

#import <LIFXKit/LIFXKit.h>
#import "UIImageAverageColorAddition.h"


@interface GameViewController ()
{
}

@end

@implementation GameViewController

NSTimer *t;
BOOL gLightState;
LFXHSBKColor *gColor;
BOOL isPaused;
CGFloat gBrightness=0.4;
//CGFloat gHue=0;
//CGFloat gSaturation=0;
CGFloat gIncrement=0.01;





#pragma mark - Handle Shake Event

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (motion == UIEventSubtypeMotionShake)
    {
        LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
        static LFXHSBKColor *savedColor ;
        savedColor = localNetworkContext.allLightsCollection.color;
        NSLog(@"savedColor:%@",savedColor);

        
        NSLog(@"***SHAKE SHAKE SHAKE***");
        gLightState = !gLightState; NSLog(@"lightState going to :%d",gLightState);
        [localNetworkContext.allLightsCollection setPowerState:gLightState];
 /*
        for (LFXLight *aLight in localNetworkContext.allLightsCollection)
        {
            if (gLightState == LFXPowerStateOn)
            {
                NSLog(@"In ON");
                savedColor = gColor;
                savedColor.brightness=1;
                [aLight setColor:gColor ];
            }
            else
            {
                NSLog(@"In OFF");
                savedColor = aLight.color;
            }
  
            //LFXHSBKColor *color = [LFXHSBKColor colorWithHue:arc4random()%360 saturation:1.0 brightness:1.0];
            //aLight.color.brightness=1;
        }
  */
        //LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
        //self.selectedLight.powerState = sender.on ? LFXPowerStateOn : LFXPowerStateOff;
        
    }
}

#pragma mark -


-(void)onTick:(NSTimer *)timer
{
    NSLog(@"Tick..");
    if (!isPaused)
    {
    NSLog(@"gBrightness:%f gIncrement:%f",gBrightness,gIncrement);
    gBrightness= gBrightness+gIncrement;      if (gBrightness>0.99) gIncrement=gIncrement*(-1.0);if (gBrightness<0.4) gIncrement=gIncrement*(-1.0);
    NSLog(@"new gBrightness:%f gIncrement:%f",gBrightness,gIncrement);
    //gHue = gHue+5;               if (gHue>360) gHue=0;if (gHue<0) gHue=360;
    //gSaturation = 0.85; if (gSaturation>1) gSaturation=1;if (gSaturation<0) gSaturation=0;
    
    gColor = [LFXHSBKColor colorWithHue:gColor.hue saturation:gColor.saturation brightness:gBrightness];
    
    LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
    [localNetworkContext.allLightsCollection setColor:gColor];
    
    // change test UIview background colour to indicate change on device screen
    self.audioPlayerBackgroundLayer.backgroundColor = [UIColor colorWithHue:(gColor.hue/360.0) saturation:gColor.saturation brightness:gBrightness alpha:1];
    }
}


-(void) glowButtons
{
    NSLog(@"Entering %s()",__FUNCTION__);
    
    [self.sound1Button.imageView startGlowingWithColor:[UIColor whiteColor] intensity:0.5];
    [self.sound2Button.imageView startGlowingWithColor:[UIColor whiteColor] intensity:0.5];
    [self.bluecrossButton.imageView startGlowingWithColor:[UIColor whiteColor] intensity:0.5];
    
    [self.redButton.imageView startGlowingWithColor:[UIColor redColor] intensity:0.5];
    [self.yellowButton.imageView startGlowingWithColor:[UIColor yellowColor] intensity:0.5];
    [self.blackButton.imageView startGlowingWithColor:[UIColor blackColor] intensity:0.5];
    if ( [self.gameSelection isEqualToString:@"pandemic"]  )
    {
        [self.blueButton.imageView startGlowingWithColor:[UIColor blueColor] intensity:0.5];
    }
    else if ([self.gameSelection isEqualToString:@"flashpoint"])
    {
        [self.blueButton.imageView startGlowingWithColor:[UIColor redColor] intensity:0.5];
        [self.redButton.imageView startGlowingWithColor:[UIColor whiteColor] intensity:0.5];
    }
    
    
}
-(void) stopGlowing
{
    
    [self.sound1Button.imageView stopGlowing];
    [self.sound2Button.imageView stopGlowing];
    [self.bluecrossButton.imageView stopGlowing];
    [self.blueButton.imageView stopGlowing];
    [self.redButton.imageView stopGlowing];
    [self.yellowButton.imageView stopGlowing];
    [self.blackButton.imageView stopGlowing];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Music Player
//volume slider on the right side
-(IBAction)updateslider:(id)sender
{
    UISlider * slider = (UISlider*)sender;
    NSLog(@"Slider Value: %.1f", [slider value]);
    self.audioPlayer.audioPlayer.volume=[slider value];
}

/*
 * Setup the AudioPlayer with
 * Filename and FileExtension like mp3
 * Loading audioFile and sets the time Labels
 */
- (void)setupAudioPlayer:(NSString*)fileName
{
    //insert Filename & FileExtension
    NSString *fileExtension = @"mp3";
    
    //init the Player to get file properties to set the time labels
    [self.audioPlayer initPlayer:fileName fileExtension:fileExtension];
    self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
    
    //init the current timedisplay and the labels. if a current time was stored
    //for this player then take it and update the time display
    self.timeElapsed.text = @"0:00";
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    
}
/*
 * PlayButton is pressed
 * plays or pauses the audio and sets
 * the play/pause Text of the Button
 */
- (IBAction)playAudioPressed:(id)playButton
{
    NSLog(@"Entering %s()",__FUNCTION__);
    [self.timer invalidate];
    //play audio for the first time or if pause was pressed
    if (!self.isPaused) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_pause.png"]
                                   forState:UIControlStateNormal];
        
        //start a timer to update the time label display
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.audioPlayer playAudio];
        self.isPaused = TRUE;
        
    } else {
        //player is paused and Button is pressed again
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_play.png"]
                                   forState:UIControlStateNormal];
        
        [self.audioPlayer pauseAudio];
        self.isPaused = FALSE;
    }
}
/*
 * Updates the time label display and
 * the current value of the slider
 * while audio is playing
 */
- (void)updateTime:(NSTimer *)timer
{
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    if (!self.scrubbing)
    {
        self.currentTimeSlider.value = [self.audioPlayer getCurrentAudioTime];
    }
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                             [self.audioPlayer timeFormat:[self.audioPlayer getCurrentAudioTime]]];
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration] - [self.audioPlayer getCurrentAudioTime]]];
    
    //When resetted/ended reset the playButton
    if (![self.audioPlayer isPlaying])
    {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_play.png"]
                                   forState:UIControlStateNormal];
        [self.audioPlayer pauseAudio];
        self.isPaused = FALSE;
        // auto replay ***FRAK***
        NSLog(@"Sending self play");
        [self playAudioPressed:self.view];
    }
}

/*
 * Sets the current value of the slider/scrubber
 * to the audio file when slider/scrubber is used
 */
- (IBAction)setCurrentTime:(id)scrubber
{
    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
    [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
    
    [self.audioPlayer setCurrentAudioTime:self.currentTimeSlider.value];
    self.scrubbing = FALSE;
}

/*
 * Sets if the user is scrubbing right now
 * to avoid slider update while dragging the slider
 */
- (IBAction)userIsScrubbing:(id)sender
{
    self.scrubbing = TRUE;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - LIFX Flashing

- (void)FlashLightOnSeparateThread: (UIImageView *) myX
//- (void)FlashLightOnSeparateThread
{
    NSLog (@"Flashing... ");
    
    CGFloat hue, saturation, brightness, alpha;
    
    isPaused=YES;
    LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
    [localNetworkContext.allLightsCollection setPowerState:LFXPowerStateOn];
    
    LFXHSBKColor *color = localNetworkContext.allLightsCollection.color;
    color.hue = 1;
    color.brightness = 1;
    color.saturation = 1;
    [localNetworkContext.allLightsCollection setColor:color];
    //usleep(500000);
    sleep(1);
    //color.hue = 0.1;
    color.brightness = 0.1;
    //color.saturation = 0.1;
    [localNetworkContext.allLightsCollection setColor:color] ;
    //usleep(500000);
    sleep(1);
    color.hue = 1;
    color.brightness = 1;
    color.saturation = 1;
    [localNetworkContext.allLightsCollection setColor:color];
    //usleep(500000);
    sleep(1);
    //[localNetworkContext.allLightsCollection setColor:color];
    //usleep(500000);
   // sleep(1);
    
    
    //restore color settings from the label background
    [self.audioPlayerBackgroundLayer.backgroundColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    color = [LFXHSBKColor colorWithHue:(hue*360) saturation:0.7 brightness:0.85];
    [localNetworkContext.allLightsCollection setColor:color];
    isPaused=NO;
}


#pragma mark - Button Presses - IBACTIONS

- (IBAction)sound1Pressed:(UIButton *)sender
{
    NSLog (@"button 1 pressed ");
    [NSThread detachNewThreadSelector: @selector(FlashLightOnSeparateThread:) toTarget: self withObject:self.blackX];
    //[self FlashLightOnSeparateThread];
/*
    BOOL didChange = NO;

    if ([self.audioPlayer isPlaying])
    {
        NSLog(@"Stopping Audio...");
        //[self playAudioPressed:self.view];
        self.audioPlayer.audioPlayer.volume=0.5;
        didChange = YES;
    }
*/
    self.mysoundaudioPlayer1.currentTime = 0;
    [self.mysoundaudioPlayer1 play];
/*
    if (didChange==YES)
    {
        while ([self.mysoundaudioPlayer1 isPlaying])
        {
            //NSLog(@"waiting...");
        }
        //[self playAudioPressed:self.view];
        self.audioPlayer.audioPlayer.volume=1;
       
    }
    didChange = NO;
*/
    
    
    //NSLog(@"Volume is %f",self.mysoundaudioPlayer1.volume);
    NSLog(@"Button -playButton1Pressed- has been pressed!\n");

}

- (IBAction)sound2Pressed:(UIButton *)sender
{
    //BOOL didChange = NO;
    [NSThread detachNewThreadSelector: @selector(FlashLightOnSeparateThread:) toTarget: self withObject:self.blackX];
/*
    if ([self.audioPlayer isPlaying])
    {
        NSLog(@"Stopping Audio...");
        self.audioPlayer.audioPlayer.volume=0.5;
        didChange = YES;
    }
*/
    self.mysoundaudioPlayer2.currentTime = 0;
   [self.mysoundaudioPlayer2 play];
/*
    if (didChange==YES)
    {
        while ([self.mysoundaudioPlayer2 isPlaying])
        {
            //NSLog(@"waiting...");
        }
        self.audioPlayer.audioPlayer.volume=1;
    }
    didChange = NO;
*/
    
    NSLog(@"Button -playButton2Pressed- has been pressed!");

    
}
- (IBAction)bluecrossPressed:(UIButton *)sender
{
//    BOOL didChange = NO;
    [NSThread detachNewThreadSelector: @selector(FlashLightOnSeparateThread:) toTarget: self withObject:self.blackX];
    
    //    if ([self.audioPlayer isPlaying])
    //    {
    //        NSLog(@"Attenuating Audio...");
    //        self.audioPlayer.audioPlayer.volume=0.5;
    //        didChange = YES;
    //    }
    
    self.mysoundaudioPlayer9.currentTime = 0;
    [self.mysoundaudioPlayer9 play];
    
    //    if (didChange==YES)
    //    {
    //        while ([self.mysoundaudioPlayer9 isPlaying])
    //        {
    //            //NSLog(@"waiting...");
    //        }
    //        self.audioPlayer.audioPlayer.volume=1;
    //    }
    //    didChange = NO;
    
    NSLog(@"Button -bluecrossPressed- has been pressed!");
    
}



- (void)ToggleXOnSeparateThread: (UIImageView *) myX
{
    myX.alpha = !myX.alpha;
}

- (IBAction)bluePressed:(UIButton *)sender
{
   // BOOL didChange = NO;
    NSLog(@"bluePressed gameSelection:%@...",self.gameSelection);
    
    [NSThread detachNewThreadSelector: @selector(FlashLightOnSeparateThread:) toTarget: self withObject:self.blueX];
    
    if ([self.gameSelection isEqualToString:@"pandemic"])
    {
        
        //toggle Xs
        [NSThread detachNewThreadSelector: @selector(ToggleXOnSeparateThread:) toTarget: self withObject:self.blueX];
        
        //        if ([self.audioPlayer isPlaying])
        //        {
        //            NSLog(@"Attenuating Audio...");
        //            self.audioPlayer.audioPlayer.volume=0.5;
        //            didChange = YES;
        //        }
        
        self.mysoundaudioPlayer3.currentTime = 0;
        [self.mysoundaudioPlayer3 play];
        
        
        [self.blueButton.imageView stopGlowing];
        
        //        if (didChange==YES)
        //        {
        //           while ([self.mysoundaudioPlayer3 isPlaying])
        //            {
        //                //NSLog(@"waiting...");
        //            }
        //            self.audioPlayer.audioPlayer.volume=1;
        //        }
        //        didChange = NO;
        
        //Game over?
        if ( (self.blueX.alpha==1) && (self.redX.alpha==1) && (self.yellowX.alpha==1) && (self.blackX.alpha==1) )
        {
            [self.mysoundaudioPlayer7 play];
            UIGraphicsBeginImageContext(self.view.frame.size);
            [[UIImage imageNamed:@"win.jpg"] drawInRect:self.view.bounds];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        }
    }
    
    if ([self.gameSelection isEqualToString:@"flashpoint"])
    {
        if (self.blueButton.tag == 0)
        {
            self.blueButton.tag = 1;
            self.mysoundaudioPlayer8.numberOfLoops = -1;
            [self.mysoundaudioPlayer8 play];
            UIImage *btnImage = [UIImage imageNamed:@"fireplace.png"];
            [self.blueButton setImage:btnImage forState:UIControlStateNormal];
        }
        else
        {
            self.blueButton.tag = 0;
            [self.mysoundaudioPlayer8 stop];
            UIImage *btnImage = [UIImage imageNamed:@"fireplaceoff.png"];
            [self.blueButton setImage:btnImage forState:UIControlStateNormal];
        }
        
        return;
    }
    
    if ([self.gameSelection isEqualToString:@"forbiddendesert"])
    {
        if (self.blueButton.tag == 0)
        {
            self.blueButton.tag = 1;
            self.mysoundaudioPlayer13.numberOfLoops = -1;
            [self.mysoundaudioPlayer13 play];
            UIImage *btnImage = [UIImage imageNamed:@"desert_on.png"];
            [self.blueButton setImage:btnImage forState:UIControlStateNormal];
        }
        else
        {
            self.blueButton.tag = 0;
            [self.mysoundaudioPlayer13 stop];
            UIImage *btnImage = [UIImage imageNamed:@"desert_off.png"];
            [self.blueButton setImage:btnImage forState:UIControlStateNormal];
        }
        
        return;
    }
    
    
    if ([self.gameSelection isEqualToString:@"bang"])
    {
        if (self.blueButton.tag == 0)
        {
            self.blueButton.tag = 1;
            self.mysoundaudioPlayer10.numberOfLoops = -1;
            [self.mysoundaudioPlayer10 play];
            UIImage *btnImage = [UIImage imageNamed:@"gun_on.png"];
            [self.blueButton setImage:btnImage forState:UIControlStateNormal];
        }
        else
        {
            self.blueButton.tag = 0;
            [self.mysoundaudioPlayer10 stop];
            UIImage *btnImage = [UIImage imageNamed:@"gun_off.png"];
            [self.blueButton setImage:btnImage forState:UIControlStateNormal];
        }
        
        return;
    }
    
    if ([self.gameSelection isEqualToString:@"machikoro"])
    {
        self.mysoundaudioPlayer12.currentTime = 0;
        [self.mysoundaudioPlayer12 play];

        return;
    }
    
    if ([self.gameSelection isEqualToString:@"forbiddenisland"])
    {
        self.mysoundaudioPlayer14.currentTime = 0;
        [self.mysoundaudioPlayer14 play];
        
        return;
    }
    
    
    NSLog(@"Button -bluePressed- has been pressed!");

}

- (IBAction)redPressed:(UIButton *)sender
{
    //BOOL didChange = NO;
    [NSThread detachNewThreadSelector: @selector(FlashLightOnSeparateThread:) toTarget: self withObject:self.redX];
    
    if ([self.gameSelection isEqualToString:@"bang"])
    {
       if (self.redButton.tag == 0)
       {
            self.redButton.tag = 1;
            //self.mysoundaudioPlayer11.numberOfLoops = -1;
            [self.mysoundaudioPlayer11 play];
            UIImage *btnImage2 = [UIImage imageNamed:@"tumbleweed_on.png"];
            [self.redButton setImage:btnImage2 forState:UIControlStateNormal];
        }
        else
        {
            self.redButton.tag = 0;
            [self.mysoundaudioPlayer11 stop];
            self.mysoundaudioPlayer11.currentTime = 0;

            UIImage *btnImage2 = [UIImage imageNamed:@"tumbleweed_off.png"];
            [self.redButton setImage:btnImage2 forState:UIControlStateNormal];
        }
        
        
        return;
    }
    if ([self.gameSelection isEqualToString:@"flashpoint"])
    {
        self.mysoundaudioPlayer15.currentTime = 0;
        [self.mysoundaudioPlayer15 play];
        
        return;
    }

    if ([self.gameSelection isEqualToString:@"pandemic"])
    {

        [NSThread detachNewThreadSelector: @selector(ToggleXOnSeparateThread:) toTarget: self withObject:self.redX];
        
        [self.redButton.imageView stopGlowing];
        
    //    if ([self.audioPlayer isPlaying])
    //    {
    //        NSLog(@"Attentuating Audio...");
    //        self.audioPlayer.audioPlayer.volume=0.5;
    //        didChange = YES;
    //    }
        
        self.mysoundaudioPlayer4.currentTime = 0;
        [self.mysoundaudioPlayer4 play];
        
    //    if (didChange==YES)
    //    {
    //        while ([self.mysoundaudioPlayer4 isPlaying])
    //        {
    //            //NSLog(@"waiting...");
    //        }
    //        self.audioPlayer.audioPlayer.volume=1;
    //    }
    //    didChange = NO;
        
        if ( (self.blueX.alpha==1) && (self.redX.alpha==1) && (self.yellowX.alpha==1) && (self.blackX.alpha==1) )
        {
            [self.mysoundaudioPlayer7 play];
            UIGraphicsBeginImageContext(self.view.frame.size);
            [[UIImage imageNamed:@"win.jpg"] drawInRect:self.view.bounds];
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        }

    }
    
    NSLog(@"Button -redPressed- has been pressed!");

}

- (IBAction)yellowPressed:(UIButton *)sender
{
    //BOOL didChange = NO;
    [NSThread detachNewThreadSelector: @selector(FlashLightOnSeparateThread:) toTarget: self withObject:self.yellowX];

    [NSThread detachNewThreadSelector: @selector(ToggleXOnSeparateThread:) toTarget: self withObject:self.yellowX];
    
    [self.yellowButton.imageView stopGlowing];
    
//    if ([self.audioPlayer isPlaying])
//    {
//        NSLog(@"Attenuating Audio...");
//        self.audioPlayer.audioPlayer.volume=0.5;
//        didChange = YES;
//    }
    
    self.mysoundaudioPlayer5.currentTime = 0;
    [self.mysoundaudioPlayer5 play];
    
//    if (didChange==YES)
//    {
//        while ([self.mysoundaudioPlayer5 isPlaying])
//        {
//            //NSLog(@"waiting...");
//        }
//        self.audioPlayer.audioPlayer.volume=1;
//    }
//    didChange = NO;
    
    if ( (self.blueX.alpha==1) && (self.redX.alpha==1) && (self.yellowX.alpha==1) && (self.blackX.alpha==1) )
    {
        [self.mysoundaudioPlayer7 play];
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:@"win.jpg"] drawInRect:self.view.bounds];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    }

    
    NSLog(@"Button -yellowPressed- has been pressed!");

}

- (IBAction)blackPressed:(UIButton *)sender
{
    //BOOL didChange = NO;
    [NSThread detachNewThreadSelector: @selector(FlashLightOnSeparateThread:) toTarget: self withObject:self.blackX];

    [NSThread detachNewThreadSelector: @selector(ToggleXOnSeparateThread:) toTarget: self withObject:self.blackX];

    [self.blackButton.imageView stopGlowing];

//    if ([self.audioPlayer isPlaying])
//    {
//        NSLog(@"Attentuating Audio...");
//        self.audioPlayer.audioPlayer.volume=0.5;
//        didChange = YES;
//    }
    
    self.mysoundaudioPlayer6.currentTime = 0;
    [self.mysoundaudioPlayer6 play];
    
//    if (didChange==YES)
//    {
//        while ([self.mysoundaudioPlayer6 isPlaying])
//        {
//            //NSLog(@"waiting...");
//        }
//        self.audioPlayer.audioPlayer.volume=1;
//    }
//    didChange = NO;
    
    if ( (self.blueX.alpha==1) && (self.redX.alpha==1) && (self.yellowX.alpha==1) && (self.blackX.alpha==1) )
    {
        [self.mysoundaudioPlayer7 play];
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:@"win.jpg"] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    
    NSLog(@"Button -blackPressed- has been pressed!");

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"going back...");
    //[self.audioPlayer stopAudio];
    

    
}



#pragma mark - View States

// Status bar begone!
- (BOOL) prefersStatusBarHidden {return YES;}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Entering %s()",__FUNCTION__);
    NSLog(@"\n gameSelection:%@",self.gameSelection);
    NSLog(@"\n background:%@",self.background);
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Create vertical volume slider                                x,   y   width, height
    UISlider *myslider = [[UISlider alloc] initWithFrame:CGRectMake(225, 270, 160, 30)];
    myslider.value=1;
    
    CGAffineTransform sliderRotation = CGAffineTransformIdentity;
    sliderRotation = CGAffineTransformRotate(sliderRotation,-(M_PI / 2));
    myslider.transform = sliderRotation;
    [self.view addSubview:myslider];
    
    
    // create volume level max and min icons
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maxlevel.png"]];
    imgView.frame=CGRectMake(280,170,45,45);
    UIImageView *imgView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minlevel.png"]];
    imgView2.frame=CGRectMake(285,360,45,45);
    
    [self.view addSubview:imgView];
    [self.view addSubview:imgView2];
    
    //make it respond to changes
    [myslider addTarget:self action:@selector(updateslider:) forControlEvents:UIControlEventValueChanged];
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Todo: Replace above volume implementation with this better one:
    //MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:volumeSlider.bounds] autorelease];
    //[volumeSlider addSubview:volumeView];
    //[volumeView sizeToFit];

    // This section makes the app play in the background//
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (!success) { /* handle the error condition */ }
    NSError *activationError = nil;
    success = [audioSession setActive:YES error:&activationError];
    if (!success) { /* handle the error condition */}
    /////////////////////////////////////////////////////////////////////////////////
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appplicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    //glow all buttons
    [self glowButtons];
    
    // Setup Main soundtrack player
    self.audioPlayer = [[YMCAudioPlayer alloc] init];
    [self setupAudioPlayer:self.gameSelection];
    
    //pandemic sound buttons
    // Construct URL to sound files
    NSString *path = [NSString stringWithFormat:@"%@/sound1.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl = [NSURL fileURLWithPath:path];
    NSString *path2 = [NSString stringWithFormat:@"%@/alarm.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl2 = [NSURL fileURLWithPath:path2];
    NSString *path3 = [NSString stringWithFormat:@"%@/cure1.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl3 = [NSURL fileURLWithPath:path3];
    NSString *path4 = [NSString stringWithFormat:@"%@/cure2.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl4 = [NSURL fileURLWithPath:path4];
    NSString *path5= [NSString stringWithFormat:@"%@/cure3.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl5 = [NSURL fileURLWithPath:path5];
    NSString *path6 = [NSString stringWithFormat:@"%@/cure4.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl6 = [NSURL fileURLWithPath:path6];
    NSString *path7 = [NSString stringWithFormat:@"%@/END.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl7 = [NSURL fileURLWithPath:path7];
    NSString *path9 = [NSString stringWithFormat:@"%@/phew.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl9 = [NSURL fileURLWithPath:path9];
    
    // Create audio player object and initialize with URL to sounds
    self.mysoundaudioPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.mysoundaudioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl2 error:nil];
    self.mysoundaudioPlayer3 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl3 error:nil];
    self.mysoundaudioPlayer4 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl4 error:nil];
    self.mysoundaudioPlayer5 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl5 error:nil];
    self.mysoundaudioPlayer6 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl6 error:nil];
    self.mysoundaudioPlayer7 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl7 error:nil];
    self.mysoundaudioPlayer9 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl9 error:nil];
    
    //flashpoint sounds
    NSString *path8 = [NSString stringWithFormat:@"%@/Fireplace sound effects.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl8 = [NSURL fileURLWithPath:path8];
    self.mysoundaudioPlayer8 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl8 error:nil];
    NSString *path15 = [NSString stringWithFormat:@"%@/explosion.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl15 = [NSURL fileURLWithPath:path15];
    self.mysoundaudioPlayer15 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl15 error:nil];
    
    
    //Bang sounds
    NSString *path10 = [NSString stringWithFormat:@"%@/guns.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl10 = [NSURL fileURLWithPath:path10];
    NSString *path11 = [NSString stringWithFormat:@"%@/wahwah.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl11 = [NSURL fileURLWithPath:path11];
    self.mysoundaudioPlayer10 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl10 error:nil];
    self.mysoundaudioPlayer11 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl11 error:nil];
    
    //Machi Koro sounds
    NSString *path12 = [NSString stringWithFormat:@"%@/cash.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl12 = [NSURL fileURLWithPath:path12];
    self.mysoundaudioPlayer12 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl12 error:nil];
    
    //Forbidden Desert sounds
    NSString *path13 = [NSString stringWithFormat:@"%@/desert.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl13 = [NSURL fileURLWithPath:path13];
    self.mysoundaudioPlayer13 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl13 error:nil];
    
    //Forbidden Island sounds
    NSString *path14 = [NSString stringWithFormat:@"%@/sink.mp3",[[NSBundle mainBundle] resourcePath]];NSURL *soundUrl14 = [NSURL fileURLWithPath:path14];
    self.mysoundaudioPlayer14 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl14 error:nil];
    
    // hide the buttons on non pandemic games
    if ( ![self.gameSelection isEqualToString:@"pandemic"]  )
    {
        self.sound1Button.hidden = TRUE;
        self.sound2Button.hidden = TRUE;
        self.bluecrossButton.hidden = TRUE;
        
        self.blueButton.hidden = TRUE;
        self.redButton.hidden = TRUE;
        self.yellowButton.hidden = TRUE;
        self.blackButton.hidden = TRUE;
    }
    
}

- (void)applicationEnteredBackground:(NSNotification *)notification {
    NSLog(@"Application Entered Bakcground");
    
    [self stopGlowing];
    
}


- (void)appplicationIsActive:(NSNotification *)notification {
    NSLog(@"Application Did Become Active");
    [self glowButtons];
    
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
    NSLog(@"Application Entered Foreground");
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSLog(@"viewWillAppear. gameSelection:%@",self.gameSelection);
    
    //set up background image
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:self.background] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // put fireplace button
    if ([self.gameSelection isEqualToString:@"flashpoint"])
    {
        UIImage *btnImage = [UIImage imageNamed:@"fireplaceoff.png"];
        [self.blueButton setImage:btnImage forState:UIControlStateNormal];
        //self.blueButton.imageView initWithImage
        self.blueButton.hidden = FALSE;
        [self.blueButton.imageView startGlowingWithColor:[UIColor redColor] intensity:0.5];
        
        UIImage *btnImage2 = [UIImage imageNamed:@"boom_on.png"];
        [self.redButton setImage:btnImage2 forState:UIControlStateNormal];
        //self.blueButton.imageView initWithImage
        self.redButton.hidden = FALSE;
        [self.redButton.imageView startGlowingWithColor:[UIColor redColor] intensity:0.5];
        
    }
    
    // put gun button
    if ([self.gameSelection isEqualToString:@"bang"])
    {
        CGRect frame = self.blueButton.frame;
        NSLog(@"frame.x:%f",frame.origin.x);
        NSLog(@"frame.y:%f",frame.origin.y);
        frame.origin.y -= 35;  // change the location
        //frame.origin.x += 100;  // change the location
        //frame.size.width += 100;  // change the size
        [self.blueButton setFrame:frame];
        
        UIImage *btnImage = [UIImage imageNamed:@"gun_off.png"];
        [self.blueButton setImage:btnImage forState:UIControlStateNormal];
        //self.blueButton.imageView initWithImage
        self.blueButton.hidden = FALSE;
        [self.blueButton.imageView startGlowingWithColor:[UIColor redColor] intensity:0.5];
        
        CGRect frame2 = self.redButton.frame;
        NSLog(@"frame2.x:%f",frame2.origin.x);
        NSLog(@"frame2.y:%f",frame2.origin.y);
        frame2.origin.y -= 35;  // change the location
        //frame.origin.x += 100;  // change the location
        //frame.size.width += 100;  // change the size
        [self.redButton setFrame:frame2];
        
        UIImage *btnImage2 = [UIImage imageNamed:@"tumbleweed_off.png"];
        [self.redButton setImage:btnImage2 forState:UIControlStateNormal];
        //self.redButton.imageView initWithImage
        self.redButton.hidden = FALSE;
        [self.redButton.imageView startGlowingWithColor:[UIColor whiteColor] intensity:0.5];
    }
    
    // put coin button
    if ([self.gameSelection isEqualToString:@"machikoro"])
    {
        NSLog(@"putting coin icon");
        UIImage *btnImage = [UIImage imageNamed:@"coin_on.png"];
        [self.blueButton setImage:btnImage forState:UIControlStateNormal];
        //self.blueButton.imageView initWithImage
        self.blueButton.hidden = FALSE;
        [self.blueButton.imageView startGlowingWithColor:[UIColor whiteColor] intensity:0.5];
    }
    
    // put desert button
    if ([self.gameSelection isEqualToString:@"forbiddendesert"])
    {
        UIImage *btnImage = [UIImage imageNamed:@"desert_off.png"];
        [self.blueButton setImage:btnImage forState:UIControlStateNormal];
        //self.blueButton.imageView initWithImage
        self.blueButton.hidden = FALSE;
        [self.blueButton.imageView startGlowingWithColor:[UIColor redColor] intensity:0.5];
    }
    
    // put desert button
    if ([self.gameSelection isEqualToString:@"forbiddenisland"])
    {
        UIImage *btnImage = [UIImage imageNamed:@"sink.png"];
        [self.blueButton setImage:btnImage forState:UIControlStateNormal];
        //self.blueButton.imageView initWithImage
        self.blueButton.hidden = FALSE;
        [self.blueButton.imageView startGlowingWithColor:[UIColor blueColor] intensity:0.5];
    }
    UIGraphicsEndImageContext();
    
    //Auto Play
    if (self.isPaused == FALSE)
    {
        [self playAudioPressed:self.view];
    }
    
    //Calculate merged background color. set background label color and LIFX to that
    CGFloat red, green, blue;
    CGFloat hue, saturation, brightness, alpha;
    
    self.audioPlayerBackgroundLayer.backgroundColor = [image mergedColor];
    [self.audioPlayerBackgroundLayer.backgroundColor getRed:&red green:&green blue:&blue alpha:NULL];
    NSLog(@"%@",[NSString stringWithFormat:@"average color: %.2f %.2f %.2f", red, green, blue]);
    [self.audioPlayerBackgroundLayer.backgroundColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    NSLog(@"%@",[NSString stringWithFormat:@"hue: %.2f saturation: %.2f  brightness: %.2f alpha: %.2f", hue, saturation, brightness, alpha]);
    LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
    [localNetworkContext.allLightsCollection setPowerState:LFXPowerStateOn];
    gColor = [LFXHSBKColor colorWithHue:(hue*360) saturation:0.7 brightness:0.85];
    [localNetworkContext.allLightsCollection setColor:gColor];
    gLightState = YES;
    
    //spawn pulsing effect thread
    t = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector:@selector(onTick:) userInfo: nil repeats:YES];
    isPaused=NO;
}


-(void) viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
    {
        if(self.timer)
        {
            [self.timer invalidate];
            self.timer = nil;
        }
 
        [self.audioPlayer stopAudio];
        
        NSLog (@"Stopping audio");
    }
    [t invalidate];
    t = nil;
    [self resignFirstResponder];

    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
     NSLog (@"***MEMORY HOG***");
}


@end
