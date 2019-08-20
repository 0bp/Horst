//
//  HorstSplitView.m
//  Horst
//
//  Created by Boris Penck on 22.12.11.
//  Copyright (c) 2011 Boris Penck. All rights reserved.
//

#import "HorstSplitView.h"

@implementation HorstSplitView

- (void) setSplitterPosition: (CGFloat) newPosition
{	
	NSView *view0 = [self.subviews objectAtIndex: 0];
	NSView *view1 = [self.subviews objectAtIndex: 1];
	
	NSRect view0TargetFrame = NSMakeRect(view0.frame.origin.x, 
                                       view0.frame.origin.y, 
                                       newPosition, 
                                       view0.frame.size.height);
  
	NSRect view1TargetFrame = NSMakeRect(newPosition + self.dividerThickness, 
                                       view1.frame.origin.y, 
                                       NSMaxX(view1.frame) - newPosition - self.dividerThickness, 
                                       view1.frame.size.height); 
	
  view0.frame = view0TargetFrame;
  view1.frame = view1TargetFrame;
}

- (float)splitterPosition
{
	NSView *view0 = [self.subviews objectAtIndex: 0];
  return view0.frame.size.width;
}


- (void)splitView:(NSSplitView *)splitView resizeSubviewsWithOldSize:(NSSize)oldSize
{
	NSView *view0 = [self.subviews objectAtIndex: 0];
	NSView *view1 = [self.subviews objectAtIndex: 1];

  NSSize splitViewSize = [splitView frame].size;
  
  NSSize leftSize = [view0 frame].size;
  leftSize.height = splitViewSize.height;
  
  NSSize rightSize;
  rightSize.width = splitViewSize.width - [splitView dividerThickness] - leftSize.width;
  rightSize.height = splitViewSize.height;
  
  [view0 setFrameSize:leftSize];
  [view1 setFrameSize:rightSize];
}


@end
