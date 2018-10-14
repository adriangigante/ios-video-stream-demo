#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>


@interface ViewController ()
{
    AVPlayerViewController *_newViewPlayer;
}
@property (strong, nonatomic) IBOutlet UITextView *surfReport;
@property (strong, nonatomic) IBOutlet UITextView *surfConditions;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadSwellnetReport];
        [self loadMSWReport];
        [self loadPlayer];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSwellnetReport
{
    //Get swellnet report
    NSString *url = @"https://www.swellnet.com/reports/australia/new-south-wales/eastern-beaches";
    NSURL *urlRequest = [NSURL URLWithString:url];
    NSError *err = nil;
    NSString *html = [NSString stringWithContentsOfURL:urlRequest encoding:NSUTF8StringEncoding error:&err];
    if(err)
    {
        //Handle
    }
    //NSLog(@"%@", html);
    NSArray *report = [html componentsSeparatedByString:@"<div class=\"field-content\"><p>"];
    if ([report count] > 1)
    {
        //NSLog(@"%@", report [1]);
        self.surfReport.text = [report[1] componentsSeparatedByString:@"</p>"][0];
    }else{
        self.surfReport.text = @"Report not available";
    }
}

- (void)loadMSWReport
{
    //Get Magic Sea Weed report
    NSString *url = @"https://magicseaweed.com/Sydney-Bondi-Surf-Report/996/";
    NSURL *urlRequest = [NSURL URLWithString:url];
    NSError *err = nil;
    NSString *html = [NSString stringWithContentsOfURL:urlRequest encoding:NSUTF8StringEncoding error:&err];
    if(err)
    {
        //Handle
    }
    //NSLog(@"%@", html);
 
    NSArray *auxArray = nil;
    
    //Surf
    //ing-text text-dark">
    auxArray = [html componentsSeparatedByString:@"ing-text text-dark\">"];
    NSString *surf = [auxArray[1] componentsSeparatedByString:@"<"][0];
    NSLog(@"surf: %@g", surf);
    
    //Wind
    auxArray = [html componentsSeparatedByString:@"h5 nomargin-top\"> "];
    NSString *wind = [auxArray[1] componentsSeparatedByString:@" <"][0];
    NSLog(@"wind: %@", wind);
    
    self.surfConditions.text = [NSString stringWithFormat:@"Surf: %@ ft\nWind:   %@", surf, wind];
}

- (void)loadPlayer
{
    NSURL *videoURL = [NSURL URLWithString:@"https://cf-stream.coastalwatch.com/cw/bondicamera.stream/chunklist_w640007274.m3u8"];
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    //playerLayer.frame = self.view.bounds;
    playerLayer.frame = CGRectMake(0, -130, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view.layer addSublayer:playerLayer];
    [player play];
}

- (IBAction)playClicked:(id)sender
{
    // Code that executes when user taps Play
    //NSURL *videoStreamURL = [NSURL URLWithString:@"https://edgecastcdn.net/242977/default1/bondicamera.m3u8"];
    //_newViewPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:videoStreamURL];
    //[self presentMoviePlayerViewControllerAnimated:_newViewPlayer];
    
    //NSURL *videoURL = [NSURL URLWithString:@"https://edgecastcdn.net/242977/default1/bondicamera.m3u8"];
    //AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    //AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    //playerLayer.frame = self.view.bounds;
    //[self.view.layer addSublayer:playerLayer];
    //[player play];
    
    
    //Play camera
    NSURL *videoURL = [NSURL URLWithString:@"https://cf-stream.coastalwatch.com/cw/bondicamera.stream/chunklist_w640007274.m3u8"];
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    [self presentViewController:playerViewController animated:YES completion:nil];
    [player play];
}

@end
