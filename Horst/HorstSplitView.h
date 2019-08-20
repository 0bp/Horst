//
//  HorstSplitView.h
//  Horst
//
//  Created by Boris Penck on 22.12.11.
//  Copyright (c) 2011 Boris Penck. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface HorstSplitView : NSSplitView <NSSplitViewDelegate>

- (void) setSplitterPosition: (CGFloat) newPosition;
- (float) splitterPosition;

@end
