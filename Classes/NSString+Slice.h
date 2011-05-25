//
//  NSString+Slice.h
//  XFTest
//
//  Created by jrk on 24/8/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Slice)

//returns a substring containing chars from "fromIndex" to "toIndex" (including char at toIndex).
//specify toIndex: -1 to get a slice from fromIndex to the end of the string
- (NSString *) stringBySlicingFrom: (NSUInteger) fromIndex to: (NSInteger) toIndex;
- (NSString *) stringBySlicingFrom: (NSUInteger) fromIndex;
- (NSString *) stringBySlicingTo: (NSInteger) toIndex;

@end
