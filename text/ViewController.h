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

    TFScroller *mScroller;
}

@property(nonatomic,retain)	TFScroller *mScroller;

@end
