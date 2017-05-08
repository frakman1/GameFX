//
//  GameViewController.h
//  GameFX
//
//  Created by alnaumf on 4/14/15.
//  Copyright (c) 2015 Fraksoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YMCAudioPlayer.h"


@interface GameViewController : UIViewController
{
IBOutlet UIView *volumeSlider;
}
@property (nonatomic, strong) YMCAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer1;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer2;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer3;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer4;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer5;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer6;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer7;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer8;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer9;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer10;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer11;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer12;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer13;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer14;
@property (nonatomic, strong) AVAudioPlayer *mysoundaudioPlayer15;

@property (nonatomic,strong) NSString *gameSelection;
@property (nonatomic,strong) NSString *background;


@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;
@property (weak, nonatomic) IBOutlet UILabel *audioPlayerBackgroundLayer;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;



//sound buttons
- (IBAction)sound1Pressed:(UIButton *)sender;
- (IBAction)sound2Pressed:(UIButton *)sender;
- (IBAction)bluePressed:(UIButton *)sender;
- (IBAction)redPressed:(UIButton *)sender;
- (IBAction)yellowPressed:(UIButton *)sender;
- (IBAction)blackPressed:(UIButton *)sender;
- (IBAction)bluecrossPressed:(UIButton *)sender;

//cure X images
@property (weak, nonatomic) IBOutlet UIImageView *blueX;
@property (weak, nonatomic) IBOutlet UIImageView *redX;
@property (weak, nonatomic) IBOutlet UIImageView *yellowX;
@property (weak, nonatomic) IBOutlet UIImageView *blackX;


@property (weak, nonatomic) IBOutlet UIButton *sound1Button;
@property (weak, nonatomic) IBOutlet UIButton *sound2Button;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *yellowButton;
@property (weak, nonatomic) IBOutlet UIButton *blackButton;
@property (weak, nonatomic) IBOutlet UIButton *bluecrossButton;




@property BOOL isPaused;
@property BOOL scrubbing;

@property NSTimer *timer;




@end
