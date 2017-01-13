//
//  TBCoordinateQuadTree.m
//  TBAnnotationClustering
//
//  Created by Theodore Calmes on 9/27/13.
//  Copyright (c) 2013 Theodore Calmes. All rights reserved.
//

#import "TBCoordinateQuadTree.h"
#import "TBClusterAnnotation.h"
#import "AqiPointMapModel.h"

//aqi数据
typedef struct AqiPointInfo {
    NSInteger level;
    NSInteger value;
} AqiPointInfo;

TBQuadTreeNodeData TBDataFromModel(AqiPointModel *model) {
    double latitude = model.lat.doubleValue;
    double longitude = model.lng.doubleValue;

    AqiPointInfo *aqiPointInfo = malloc(sizeof(AqiPointInfo));

    aqiPointInfo->value = model.value.integerValue;
    aqiPointInfo->level = model.colour_level.integerValue;

    return TBQuadTreeNodeDataMake(latitude, longitude, aqiPointInfo);
}

TBBoundingBox TBBoundingBoxForMapRect(MKMapRect mapRect) {
    CLLocationCoordinate2D topLeft = MKCoordinateForMapPoint(mapRect.origin);
    CLLocationCoordinate2D botRight = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)));

    CLLocationDegrees minLat = botRight.latitude;
    CLLocationDegrees maxLat = topLeft.latitude;

    CLLocationDegrees minLon = topLeft.longitude;
    CLLocationDegrees maxLon = botRight.longitude;

    return TBBoundingBoxMake(minLat, minLon, maxLat, maxLon);
}

MKMapRect TBMapRectForBoundingBox(TBBoundingBox boundingBox) {
    MKMapPoint topLeft = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.x0, boundingBox.y0));
    MKMapPoint botRight = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.xf, boundingBox.yf));

    return MKMapRectMake(topLeft.x, botRight.y, fabs(botRight.x - topLeft.x), fabs(botRight.y - topLeft.y));
}

NSInteger TBZoomScaleToZoomLevel(MKZoomScale scale) {
    double totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0;
    NSInteger zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom);
    NSInteger zoomLevel = MAX(0, zoomLevelAtMaxZoom + floor(log2f(scale) + 0.5));

    return zoomLevel;
}

float TBCellSizeForZoomScale(MKZoomScale zoomScale) {
    NSInteger zoomLevel = TBZoomScaleToZoomLevel(zoomScale);

    switch (zoomLevel) {
        case 13:
        case 14:
        case 15:
            return 64;
        case 16:
        case 17:
        case 18:
            return 32;
        case 19:
            return 16;

        default:
            return 88;
    }
}

@implementation TBCoordinateQuadTree

- (void)buildTreeWithDataSource:(id)dataSource {
    @autoreleasepool {
        if ([dataSource isKindOfClass:[NSArray class]]) {
            
            NSArray *datas =dataSource;
            
            NSInteger count = datas.count - 1;
            
            TBQuadTreeNodeData *dataArray = malloc(sizeof(TBQuadTreeNodeData) * count);
            for (NSInteger i = 0; i < count; i++) {
                AqiPointModel *model = datas[i];
                dataArray[i] = TBDataFromModel(model);
            }
            
            TBBoundingBox world = TBBoundingBoxMake(0, 0, 320, 320);
            _root = TBQuadTreeBuildWithData(dataArray, (int)count, world, 4);
        }
     }
}

- (NSArray *)clusteredAnnotationsWithinMapRect:(MAMapRect)rect withZoomScale:(double)zoomScale
{
    double TBCellSize = TBCellSizeForZoomScale(zoomScale);
    double scaleFactor = zoomScale / TBCellSize;

    NSInteger minX = floor(MAMapRectGetMinX(rect) * scaleFactor);
    NSInteger maxX = floor(MAMapRectGetMaxX(rect) * scaleFactor);
    NSInteger minY = floor(MAMapRectGetMinY(rect) * scaleFactor);
    NSInteger maxY = floor(MAMapRectGetMaxY(rect) * scaleFactor);

    NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];
    for (NSInteger x = minX; x <= maxX; x++) {
        for (NSInteger y = minY; y <= maxY; y++) {
            MKMapRect mapRect = MKMapRectMake(x / scaleFactor, y / scaleFactor, 1.0 / scaleFactor, 1.0 / scaleFactor);
            
            __block double totalX = 0;
            __block double totalY = 0;
            __block int count = 0;
            __block NSInteger level = 0;
            __block NSInteger value = 0;

            NSMutableArray *valueArr = [[NSMutableArray alloc] init];
            NSMutableArray *levelArr = [[NSMutableArray alloc] init];

            TBQuadTreeGatherDataInRange(self.root, TBBoundingBoxForMapRect(mapRect), ^(TBQuadTreeNodeData data) {
                totalX += data.x;
                totalY += data.y;
                count++;

                AqiPointInfo pointInfo = *(AqiPointInfo *)data.data;
                [valueArr addObject:@(pointInfo.value)];
                [levelArr addObject:@(pointInfo.level)];
                
                level = pointInfo.level;
                value = pointInfo.value;
            });

            if (count == 1) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalX, totalY);
                TBClusterAnnotation *annotation = [[TBClusterAnnotation alloc] initWithCoordinate:coordinate
                                                                                         andValue:[valueArr.lastObject integerValue]
                                                                                         andLevel:[levelArr.lastObject integerValue]];
                annotation.title = @"aha";
                annotation.subtitle = @"sdfsdf";
                [clusteredAnnotations addObject:annotation];
            }

            if (count > 1) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalX / count, totalY / count);
                TBClusterAnnotation *annotation = [[TBClusterAnnotation alloc] initWithCoordinate:coordinate
                                                                                         andValue:value
                                                                                         andLevel:level];
                [clusteredAnnotations addObject:annotation];
            }
        }
    }

    return [NSArray arrayWithArray:clusteredAnnotations];
}

- (void)dealloc {

}
@end
