/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A category on NSIndexSet for convienience methods.
 */

@import Foundation;

@interface NSIndexSet (Convenience)
- (NSArray *)aapl_Camera_indexPathsFromIndexesWithSection:(NSUInteger)section;
- (NSArray *)aapl_indexPathsFromIndexesWithSection:(NSUInteger)section;

@end
