//
//  TFScroller.m
//  HardRock
//
//  Created by Rajat Talwar on 03/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TFScroller.h"

@implementation TFScroller
@synthesize mImageViewsArray,mScrollView,mImageArray,mDelegate,mResumeTimer,scrollingEnabled,mTimer;


-(id)initWithFrame:(CGRect)pFrame 
{
	
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
		mFrame = pFrame;
	}
	
	return self;
}

-(void)goToNextPage
{
	mManual = TRUE;
	CGPoint currentOffset = mScrollView.contentOffset;
	[mScrollView setContentOffset:CGPointMake(currentOffset.x + (mGap+mWidthPage), 0) animated:YES];
}

-(void)goToPreviousPage
{
	CGPoint currentOffset = mScrollView.contentOffset;
	
	mManual =TRUE;
	
	[mScrollView setContentOffset:CGPointMake(currentOffset.x - (mGap+mWidthPage), 0) animated:YES];
}

-(CABasicAnimation*)getAnimationforPoint:(CGPoint)pPoint
{
	CGPoint startPoint = pPoint;
	CGPoint endPoint = pPoint;
	endPoint.x-=TRAVERSE_AMOUNT;
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:ANIMATION_PROPERTY];
	[animation setFromValue:[NSValue valueWithCGPoint:startPoint]];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	[animation setToValue:[NSValue valueWithCGPoint:endPoint]];
	[animation setDuration:ANIMATION_DURATION];
	animation.delegate =self;
	animation.removedOnCompletion = NO;
	return animation;
}


-(UIView*)getViewLinkedToAnimation:(CAAnimation*)anim
{
	UIView *imageView= nil;
	
	for (int i = 0; i < [mImageViewsArray count]; i++) {
		imageView = [mImageViewsArray objectAtIndex:i];
		if (anim==[[imageView layer] animationForKey:ANIMATION_PROPERTY]) {
			break;
		}	
		
	}
	
	return imageView;
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	
	if (!flag) {
		return;
	}
	
	UIView *imageView = [self getViewLinkedToAnimation:anim];
	
	CGFloat leftOffset = imageView.frame.origin.x + imageView.frame.size.width ;
	if (leftOffset < 0) { // if the button has crossed the left margin.
		
		CGRect newFrame = imageView.frame;
		[[imageView layer] removeAllAnimations];
		
		////DLog(@"offset is %f and origin of last button is %f",leftOffset,mLastButton.frame.origin.x);
		newFrame.origin.x = mLastButton.frame.origin.x + (WIDTH_SCROLLER_THUMBNAIL + TFSCROLLER_SPACING_WIDTH) + ((imageView==mFirstButton)?TRAVERSE_AMOUNT:0) ;
		imageView.frame = newFrame;
		mLastButton = imageView;
		
		[[imageView layer] addAnimation:[self getAnimationforPoint:[imageView center]] forKey:ANIMATION_PROPERTY];
		CGPoint newPoint =  imageView.center;
		newPoint.x-=TRAVERSE_AMOUNT;
		[[imageView layer] setPosition:newPoint];
		
		
	}
	else {						// animating the buttons which are still in the view.
		[[imageView layer] removeAnimationForKey:ANIMATION_PROPERTY];
		
		[[imageView layer] addAnimation:[self getAnimationforPoint:imageView.center] forKey:ANIMATION_PROPERTY];
		
		CGPoint newPoint =  imageView.center;
		newPoint.x-=TRAVERSE_AMOUNT;
		[[imageView layer] setPosition:newPoint];
	}
	
}


-(void)stopScrolling
{
	if (!isScrolling) {
		return;
	}
	isScrolling = FALSE;
	
	CGFloat lowestX = 0;
	for (int   i = 0; i<[mImageViewsArray count]; i++) {
		UIView *imgview = [mImageViewsArray objectAtIndex:i];
		[[imgview layer] removeAllAnimations];
		
		if (imgview.frame.origin.x < lowestX) {
			lowestX = imgview.frame.origin.x;
		}
	}
	
	if (lowestX < 0) {
		
		
		for (UIView *obj in [mScrollView subviews]) {
			
			CGPoint buttonCenter = obj.center;
			buttonCenter.x += -lowestX;
			obj.center =buttonCenter;
		}
	}
	
}

-(void)animateAll
{
	for (NSUInteger   i = 0; i<[mImageViewsArray count]; i++)
	{
		UIView *imgview = [mImageViewsArray objectAtIndex:i];
		[[imgview layer] removeAllAnimations];
		[[imgview layer] addAnimation:[self getAnimationforPoint:[imgview center]] forKey:ANIMATION_PROPERTY];
		CGPoint newPoint =  imgview.center;
		newPoint.x-=TRAVERSE_AMOUNT;
		[[imgview layer] setPosition:newPoint];
	}
}

-(void)startSrolling
{
	if (!scrollingEnabled) {
		return;
	}
	isScrolling = TRUE;
	[self animateAll];
	
}


+(void)removeAllSubViewsFrom:(UIView*)pView
{
	for (UIView *subView in [pView subviews]) {
		
		[subView removeFromSuperview];
	}
}



-(void)scrollViewInitialisation{
	//DLog(@"the delegate is %@",self.mDelegate);
	mActualPages = [self.mDelegate numberOfPagesInScroller:self];
	
	mWidthPage = [self.mDelegate widthForPagesInScroller:self];
	mGap = [self.mDelegate gapForPagesInScroller:self ];
	self.scrollingEnabled = TRUE;
	mTotalPages = 50;
	if (mWidthPage<mFrame.size.width) {
		//DLog(@"scrollwidth is %f and width is %f",mFrame.size.width,mWidthPage);
		CGFloat ratio =		(mFrame.size.width/mWidthPage);
		mTotalPages = (int)(50*ratio);
	}
	CGFloat step = 2*mGap + mWidthPage;
	
	mLag = step +mWidthPage/2 - mFrame.size.width/2;
    
	if (!mScrollView) {
        
		UIScrollView *temp=[[UIScrollView alloc] initWithFrame:mFrame];
		self.mScrollView = temp;
		
		[temp release];
	}
	
	[TFScroller removeAllSubViewsFrom:mScrollView];
	
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < mTotalPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }

	self.mImageViewsArray = [controllers autorelease];
	[NSThread detachNewThreadSelector:@selector(loadScrollViewWithPage:) toTarget:self withObject:[NSNumber numberWithInt:0]];
    [NSThread detachNewThreadSelector:@selector(loadScrollViewWithPage:) toTarget:self withObject:[NSNumber numberWithInt:1]];
    [NSThread detachNewThreadSelector:@selector(loadScrollViewWithPage:) toTarget:self withObject:[NSNumber numberWithInt:2]];   
    
	CGFloat width = mTotalPages * (mGap + mWidthPage)  + mGap;
	mScrollView.contentSize = CGSizeMake(width, mScrollView.frame.size.height);
    mScrollView.showsHorizontalScrollIndicator = NO;
    mScrollView.showsVerticalScrollIndicator = NO;
    mScrollView.scrollsToTop = YES;
	mScrollView.delegate = self;
	mScrollView.userInteractionEnabled=YES;
    [self scrollToCorrect:mScrollView andFlag: YES];
}

-(void)setMImageArray:(NSMutableArray*)pImages
{
	[self stopScrolling];
	[pImages retain];
	[mImageArray release];
	mImageArray = pImages;
	
	[self scrollViewInitialisation];
	[self startSrolling];
	
}

- (void)loadScrollViewWithPage:(NSNumber*)num
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new] ;
	int page = [num intValue];
	if (page < 0) {
        [pool drain];
		return;
	}
	if (page>= mTotalPages) {
        [pool drain];        
		return;
	}
    
	UIView *imageView = [mImageViewsArray objectAtIndex:page];
    if ((NSNull *)imageView == [NSNull null])
    {
        imageView = [[self.mDelegate tfScroller:self viewForIndex:(page%mActualPages) ] retain];
        imageView.frame = CGRectMake(0, mGap, mWidthPage, self.mScrollView.frame.size.height - mGap*2);
        
		@synchronized(self){
        [mImageViewsArray replaceObjectAtIndex:page withObject:imageView];
			[imageView release];
		}
    }
    
	if (nil == imageView.superview) {
		
		CGRect frame = mScrollView.frame;
		frame.origin.x = mGap + ( mWidthPage +mGap ) * page;
		frame.origin.y = mGap;
		
		frame.size = imageView.frame.size;
		
		imageView.frame = frame;
		[mScrollView performSelectorOnMainThread:@selector(addSubview:) withObject:imageView waitUntilDone:NO];
	}

	[pool drain];
}

-(void)addAllButtonsToScrollView
{
	UIView *imageView = nil ;
	
	if ([mImageViewsArray count] > 0) {
		mFirstButton = [mImageViewsArray objectAtIndex:0];
		
	}
	
	for (int i = 0; i<[mImageViewsArray count];i++) {
		imageView = [mImageViewsArray objectAtIndex:i];
		
		if (nil == imageView.superview) {
			
			CGRect frame = mScrollView.frame;
			//frame.origin.x = (frame.size.width/2) * i;
			frame.origin.x = mGap + ( mWidthPage + mGap ) * i;
			frame.origin.y = 0;
			
			frame.size = imageView.frame.size;
			
			imageView.frame = frame;
			[mScrollView addSubview:imageView];
		}
	}
    
	mLastButton = imageView;
	if ([mImageViewsArray count]==1) { // If only one image is to be displayed in scroller
		UIView *imageView = [mImageViewsArray objectAtIndex:0];
		imageView.center = CGPointMake(mScrollView.frame.size.width/2, mScrollView.frame.size.height/2); 
		mScrollView.contentSize = mScrollView.frame.size;                                               
	}
}


-(void)imageButtonClicked:(id)sender
{
	if ([(id)mDelegate respondsToSelector:@selector(tfscroller:didSelectImageAtIndex:)]) {
		
		UIButton *button = (UIButton*)sender;
		[self.mDelegate tfscroller:self didSelectImageAtIndex:button.tag];
	}
}

-(void)memoryWarning
{
	NSLog(@"memoryWarning");
	NSInteger normalIndex= mActualPages*((mTotalPages/2)/mActualPages) + (mSelectedIndex%mActualPages);

	for (int i =0 ; i< mTotalPages; i++) {
		
		if (i >(normalIndex -2) && i < (normalIndex+2) ) {
			
			continue;
		}
		
		UIView *imageView = [mImageViewsArray objectAtIndex:i];
		
		if ((NSNull *)imageView == [NSNull null]) {
			continue;
		}
		[imageView removeFromSuperview];
		[mImageViewsArray replaceObjectAtIndex:i withObject:[NSNull null]];
	}
}
-(void)magazineTeaser:(UIView*)magazineTeaser didSelectPageAtIndex:(NSInteger)pIndex
{
	
	[self.mDelegate tfscroller:self didSelectImageAtIndex:pIndex];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = ((int)scrollView.contentOffset.x - mLag)/((int)(mGap+mWidthPage) );
    NSLog(@"\nPage: %d\n", page);
    
	[NSThread detachNewThreadSelector:@selector(loadScrollViewWithPage:) toTarget:self withObject:[NSNumber numberWithInt:(page -2)]];

	[NSThread detachNewThreadSelector:@selector(loadScrollViewWithPage:) toTarget:self withObject:[NSNumber numberWithInt:(page -1)]];

	[NSThread detachNewThreadSelector:@selector(loadScrollViewWithPage:) toTarget:self withObject:[NSNumber numberWithInt:page]];

	[NSThread detachNewThreadSelector:@selector(loadScrollViewWithPage:) toTarget:self withObject:[NSNumber numberWithInt:(page +1)]];

	[NSThread detachNewThreadSelector:@selector(loadScrollViewWithPage:) toTarget:self withObject:[NSNumber numberWithInt:(page + 2)]];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	NSLog(@"scrollViewDidEndScrollingAnimation");
	if (mManual) {
		mManual = FALSE;
		
		int page = ((int)mScrollView.contentOffset.x - mLag)/((int)(mGap+mWidthPage) );

		NSInteger normalIndex= mActualPages*((mTotalPages/2)/mActualPages) + (page%mActualPages);
		[scrollView setContentOffset:CGPointMake(mLag +normalIndex*(mWidthPage+mGap), 0) animated:NO];
		return;
	}

	NSInteger normalIndex= mActualPages*((mTotalPages/2)/mActualPages) + (mSelectedIndex%mActualPages);
	[scrollView setContentOffset:CGPointMake(mLag +normalIndex*(mWidthPage+mGap), 0) animated:NO];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self scrollToCorrect:scrollView andFlag:YES];
}

-(void)scrollToCorrect:(UIScrollView*)scrollView andFlag:(BOOL)flag
{
	CGFloat min=mLag;
	int selectedI=0;
	selectedI = (int)round( ((int)scrollView.contentOffset.x - mLag)/(mGap+mWidthPage)  ) ;
	mSelectedIndex = selectedI;
	NSLog(@"finally min is %f index is %d",min,selectedI);
	mAnimation = TRUE;
	[scrollView setContentOffset:CGPointMake(mLag + selectedI*(mWidthPage+mGap), 0) animated:flag];
}

-(void)scheduleScrollingAfter:(NSTimeInterval)pSeconds
{
	
	if (mResumeTimer) {
		[mResumeTimer invalidate];
		[mResumeTimer release];
		mResumeTimer=nil;
		
	}

	self.mResumeTimer = [NSTimer scheduledTimerWithTimeInterval:pSeconds target:self selector:@selector(startSrolling) userInfo:nil repeats:NO];
}

#pragma mark -
#pragma mark THUMBNAILBUTTON DELEGATE

-(void)thumbnailButton:(UIView*)thumbnailButton imageLoadedForIndex:(NSInteger)pIndex
{
}

#pragma mark -
-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[mTimer invalidate];
	[mTimer release];
	mTimer=nil;
	
	if (mScrollView.superview) {
		[mScrollView removeFromSuperview];
	}
	
	[mScrollView release];
	mScrollView = nil;
	[mImageViewsArray release];
	mImageViewsArray = nil;
	
	
	[mImageArray release];
	mImageArray = nil;
	self.mDelegate = nil;
	[mResumeTimer invalidate];
	[mResumeTimer release];
	mResumeTimer = nil;
	[super dealloc];
}


@end
