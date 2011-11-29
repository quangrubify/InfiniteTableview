//
//  ViewController.m
//  text
//
//  Created by quang on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize mScroller1, mScroller2, mScroller3, mScroller4;

-(void)dealloc
{
    self.mScroller1 = nil;
    self.mScroller2 = nil;
    self.mScroller3 = nil;
    self.mScroller4 = nil; 
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
    
    UIButton *bt =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bt setTitle:@"Click" forState:UIControlStateNormal];
    [self.view addSubview: bt];
    bt.center = CGPointMake(400, 320/2);
    [bt addTarget:self action:@selector(click) forControlEvents:UIControlStateNormal];
    
    self.mScroller1 = [[[TFScroller alloc] initWithFrame:CGRectMake(0, 50, 320, 50) ] autorelease];
    self.mScroller1.mDelegate = self;
    [self.mScroller1 scrollViewInitialisation];
	[self.view addSubview:self.mScroller1.mScrollView];  
    self.mScroller1.mScrollView.backgroundColor = [UIColor redColor];
    
    self.mScroller2 = [[[TFScroller alloc] initWithFrame:CGRectMake(0, 120, 320, 50) ] autorelease];
    self.mScroller2.mDelegate = self;
    [self.mScroller2 scrollViewInitialisation];
	[self.view addSubview:self.mScroller2.mScrollView];  
    self.mScroller2.mScrollView.backgroundColor = [UIColor redColor];
    
    
    self.mScroller3 = [[[TFScroller alloc] initWithFrame:CGRectMake(0, 190, 320, 50) ] autorelease];
    self.mScroller3.mDelegate = self;
    [self.mScroller3 scrollViewInitialisation];
	[self.view addSubview:self.mScroller3.mScrollView];  
    self.mScroller3.mScrollView.backgroundColor = [UIColor redColor];
    
    
    self.mScroller4 = [[[TFScroller alloc] initWithFrame:CGRectMake(0, 260, 320, 50) ] autorelease];
    self.mScroller4.mDelegate = self;
    [self.mScroller4 scrollViewInitialisation];
	[self.view addSubview:self.mScroller4.mScrollView];  
    self.mScroller4.mScrollView.backgroundColor = [UIColor redColor];
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
    UIButton *v = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    NSString *title = @"NO title";
    
    if (tfscroller == self.mScroller1) {
        title = @"S1";
    }else     if (tfscroller == self.mScroller2) {
        title = @"S2";
    }else     if (tfscroller == self.mScroller3) {
        title = @"Sc3";
    }else     if (tfscroller == self.mScroller4) {
        title = @"S4";
    }
    
    NSString *str = [NSString stringWithFormat:@"%@ -- Label %d", title, pInteger];
    [v setTitle: str forState:UIControlStateNormal];
    [v addTarget:self action:@selector(run:) forControlEvents: UIControlEventTouchUpInside];
    
    if (pInteger%2 == 1) {
        [v setTitleColor: [UIColor redColor] forState:UIControlStateNormal];
    }else
    {
        [v setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    }
    v.frame = CGRectMake(0, 0, 50, 50);
    return [v autorelease];
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
