//
//  Helper.h
//  Horst
//
//  Created by Boris Penck on 19.12.11.
//  Copyright (c) 2011 Boris Penck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject <NSConnectionDelegate> 

- (id)initWithName:(NSString*)name;
- (NSString *)hosts;
- (BOOL)hosts:(NSString *)content hash:(NSString *)hash;

@end
