//
//  TBClusterAnnotation.m
//  TBAnnotationClustering
//
//  Created by Theodore Calmes on 10/8/13.
//  Copyright (c) 2013 Theodore Calmes. All rights reserved.
//

#import "TBClusterAnnotation.h"

@implementation TBClusterAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate andValue:(NSInteger)value andLevel:(NSInteger)level {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _title = [NSString stringWithFormat:@"%d hotels in this area", (int)value];
        _value = value;
        _level = level;
    }
    return self;
}

- (NSUInteger)hash {
    NSString *toHash = [NSString stringWithFormat:@"%.5F%.5F", self.coordinate.latitude, self.coordinate.longitude];
    return [toHash hash];
}

- (BOOL)isEqual:(id)object {
    return [self hash] == [object hash];
}

@end
