//
//  ViewController.m
//  text
//
//  Created by quang on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize mScroller;

-(void)dealloc
{
    self.mScroller = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mScroller = [[[TFScroller alloc] initWithFrame:CGRectMake(0, 175, 320, 50) ] autorelease];
    self.mScroller.mDelegate = self;
    [self.mScroller scrollViewInitialisation];
	[self.view addSubview:self.mScroller.mScrollView];    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark TFSCROLLER DELEGATE FUNCTIONS

-(void)run:(id)sender
{
    NSLog(@"\nhacaiodhciouhaoidhoichaid...\n");
}

-(UIView*)tfScroller:(TFScroller*)tfscroller viewForIndex:(NSInteger)pInteger
{
    UIButton *v = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [v setTitle:[NSString stringWithFormat:@"Label %d", pInteger] forState:UIControlStateNormal];
    [v addTarget:self action:@selector(run:) forControlEvents: UIControlEventTouchUpInside];
    
    if (pInteger%2 == 1) {
        [v setTitleColor: [UIColor redColor] forState:UIControlStateNormal];
    }else
    {
        [v setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    }
    
    return v;
	
}

-(NSUInteger)numberOfPagesInScroller:(TFScroller*)tfscroller 
{
	return 20;
}

-(CGFloat)widthForPagesInScroller:(TFScroller*)tfscroller 
{
	return 100;
}
-(CGFloat)gapForPagesInScroller:(TFScroller*)tfscroller 
{
	return 10;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
