//
//  TBClusterAnnotation.h
//  TBAnnotationClustering
//
//  Created by Theodore Calmes on 10/8/13.
//  Copyright (c) 2013 Theodore Calmes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface TBClusterAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate andValue:(NSInteger)value andLevel:(NSInteger)level;

@end
