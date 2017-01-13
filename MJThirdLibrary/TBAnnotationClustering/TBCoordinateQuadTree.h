//
//  TBCoordinateQuadTree.h
//  TBAnnotationClustering
//
//  Created by Theodore Calmes on 9/27/13.
//  Copyright (c) 2013 Theodore Calmes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "TBQuadTree.h"

@interface TBCoordinateQuadTree : NSObject

@property (nonatomic, assign) TBQuadTreeNode *root;

- (void)buildTreeWithDataSource:(id)dataSource;
- (NSArray *)clusteredAnnotationsWithinMapRect:(MAMapRect)rect withZoomScale:(double)zoomScale;

@end
