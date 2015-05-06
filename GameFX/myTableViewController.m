//
//  myTableViewController.m
//  GameFX
//
//  Created by alnaumf on 4/14/15.
//  Copyright (c) 2015 Fraksoft. All rights reserved.
//

#import "myTableViewController.h"
#import "GameViewController.h"
#import "UIView+Glow.h"
#import <MediaPlayer/MediaPlayer.h>
#import <LIFXKit/LIFXKit.h>





@interface myTableViewController ()

@property (nonatomic,strong) NSString *gameName ;
@property (nonatomic,strong) UIImage *image;
@end

@implementation myTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Auto Max Volume
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    musicPlayer.volume = 1.0f;

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
   // UIGraphicsBeginImageContext(self.navigationItem.titleView.frame.size);
   // [[UIImage imageNamed:@"gamefxicon5.png"] drawInRect:self.navigationItem.titleView.bounds];
    
    //UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    NSLog(@"entering %s() ",__FUNCTION__);
    
   self.gameName = [[NSString alloc] initWithFormat:@"none"];
   
   //self.image = [UIImage imageNamed:@"gamefxicon5.png"];
   //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gamefxicon5.png"]];
   //[self.navigationItem.titleView startGlowingWithColor:[UIColor blackColor] intensity:0.5];
 
    
}
- (BOOL) prefersStatusBarHidden {return YES;}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"entering %s() ",__FUNCTION__);
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gamefxicon5.png"]];
    [self.navigationItem.titleView startGlowingWithColor:[UIColor blackColor] intensity:0.5];
    
    LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
    [localNetworkContext.allLightsCollection setPowerState:LFXPowerStateOn];
    
    LFXHSBKColor *color = localNetworkContext.allLightsCollection.color;
    NSLog(@"brightness before : %f",localNetworkContext.allLightsCollection.color.brightness);
    color.brightness = localNetworkContext.allLightsCollection.color.brightness /=2;
    NSLog(@"brightness after : %f",localNetworkContext.allLightsCollection.color.brightness);
    
    //LFXHSBKColor *color = [LFXHSBKColor colorWithHue:275 saturation:1.0 brightness:0.85];
  
    [localNetworkContext.allLightsCollection setColor:color];


}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"entering %s() ",__FUNCTION__);
    if (indexPath.row == 0)
    {
        return 260;
    }
    if (indexPath.row == 1)
    {//escape
        return 210;
    }
    if (indexPath.row == 7)
    {//ascension
        return 260;
    }

//    if (indexPath.row == 2)
//    {
//        return 260;
//    }

    return 260;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows(games) in the section.
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor whiteColor];
    UIImageView *photo;
    // Pandemic
    if (indexPath.row ==0 )
    {
        //cell.textLabel.text = @"Pandemic";
        //cell.imageView.image = [UIImage imageNamed:@"pandemic1.jpg"];
        //self.gameName = @"pandemic";
        //NSLog(@"\nCell name:%@",self.gameName);
        
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(52.0, 10.0, 200.0, 250)];
        //photo.tag = PHOTO_TAG;
        photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:photo];
        photo.image = [UIImage imageNamed:@"pandemic1.jpg"];
    }

    ///Escape
    if (indexPath.row ==1 )
    {
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(52.0, 10.0, 200.0, 200)];
        //photo.tag = PHOTO_TAG;
        photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:photo];
        photo.image = [UIImage imageNamed:@"escape2.png"];
    }
    ///Forbidden Island
    if (indexPath.row ==2 )
    {
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(52.0, 10.0, 200.0, 250)];
        //photo.tag = PHOTO_TAG;
        photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:photo];
        photo.image = [UIImage imageNamed:@"forbiddenisland.png"];
            
    }
    ///Flash Point Fire Rescue
    if (indexPath.row ==3 )
    {
       photo = [[UIImageView alloc] initWithFrame:CGRectMake(52.0, 10.0, 200.0, 250)];
        //photo.tag = PHOTO_TAG;
        photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:photo];
        photo.image = [UIImage imageNamed:@"flashpoint.jpg"];
        
    }
    ///Forbidden Desert
    if (indexPath.row ==4 )
    {
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(52.0, 10.0, 200.0, 250)];
        //photo.tag = PHOTO_TAG;
        photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:photo];
        photo.image = [UIImage imageNamed:@"forbiddendesert.jpg"];
        
    }

    ///Bang - Western
    if (indexPath.row ==5 )
    {
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(52.0, 10.0, 200.0, 250)];
        //photo.tag = PHOTO_TAG;
        photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:photo];
        photo.image = [UIImage imageNamed:@"bang.png"];
        
    }
    ///Machi Koro
    if (indexPath.row ==6 )
    {
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(52.0, 10.0, 200.0, 250)];
        //photo.tag = PHOTO_TAG;
        photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:photo];
        photo.image = [UIImage imageNamed:@"machikoro.jpg"];
        
    }
    ///Ascension
    if (indexPath.row ==7 )
    {
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(52.0, 10.0, 200.0, 250)];
        //photo.tag = PHOTO_TAG;
        photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:photo];
        photo.image = [UIImage imageNamed:@"ascension.jpg"];
        
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 )
    {
        self.gameName = @"pandemic";
    }
    if (indexPath.row == 1 )
    {
        self.gameName = @"escape";
    }
    if (indexPath.row == 2 )
    {
        self.gameName = @"forbiddenisland";
    }
    if (indexPath.row == 3 )
    {
        self.gameName = @"flashpoint";
    }
    if (indexPath.row == 4 )
    {
        self.gameName = @"forbiddendesert";
    }
    if (indexPath.row == 5 )
    {
        self.gameName = @"bang";
    }
    if (indexPath.row == 6 )
    {
        self.gameName = @"machikoro";
    }
    if (indexPath.row == 7 )
    {
        self.gameName = @"ascension";
    }
    [self performSegueWithIdentifier:@"toGameVCSegue" sender:self];
    

}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"toGameVCSegue"])
    {
        NSLog(@"prepare to segue. self game:%@",self.gameName);
        GameViewController *targetVc = [segue destinationViewController];
        targetVc.gameSelection = self.gameName;
        if (self.tableView.indexPathForSelectedRow.row == 0)
        {
            targetVc.background = @"pandemic2.jpg";
        }
        if (self.tableView.indexPathForSelectedRow.row  == 1)
        {
            targetVc.background = @"escape2.png";
        }
        if (self.tableView.indexPathForSelectedRow.row  == 2)
        {
            targetVc.background = @"forbiddenisland.png";
        }
        if (self.tableView.indexPathForSelectedRow.row  == 3)
        {
            targetVc.background = @"flashpoint.jpg";
        }
        if (self.tableView.indexPathForSelectedRow.row  == 4)
        {
            targetVc.background = @"forbiddendesert.jpg";
        }
        if (self.tableView.indexPathForSelectedRow.row  == 5)
        {
            targetVc.background = @"bang.png";
        }
        if (self.tableView.indexPathForSelectedRow.row  == 6)
        {
            targetVc.background = @"machikoro.jpg";
        }
        if (self.tableView.indexPathForSelectedRow.row  == 7)
        {
            targetVc.background = @"ascension.jpg";
        }
       
        
    }
    
}


@end
