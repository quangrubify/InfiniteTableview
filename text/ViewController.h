//
//  ViewController.h
//  text
//
//  Created by quang on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFScroller.h"

@interface ViewController : UIViewController<TFScrollerDelegate>
{

    TFScroller *mScroller1;
    TFScroller *mScroller2;    
    TFScroller *mScroller3;        
    TFScroller *mScroller4;        
}

@property(nonatomic,retain)	TFScroller *mScroller1;
@property(nonatomic,retain)	TFScroller *mScroller2;
@property(nonatomic,retain)	TFScroller *mScroller3;
@property(nonatomic,retain)	TFScroller *mScroller4;

@end
