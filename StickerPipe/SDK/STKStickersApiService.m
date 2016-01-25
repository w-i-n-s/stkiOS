
//
//  STKStickersApiClient.m
//  StickerFactory
//
//  Created by Vadim Degterev on 07.07.15.
//  Copyright (c) 2015 908 Inc. All rights reserved.
//

#import "STKStickersApiService.h"
#import <AFNetworking.h>
#import "STKUUIDManager.h"
#import "STKApiKeyManager.h"
#import "STKUtility.h"

static NSString *const packsURL = @"packs";

@implementation STKStickersApiService

- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_queue_t completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        self.sessionManager.completionQueue = completionQueue;
    }
    return self;
}


- (void)getStickersPacksForUserWithSuccess:(void (^)(id response, NSTimeInterval lastModifiedDate))success
                        failure:(void (^)(NSError *error))failure {
    
    [self.sessionManager GET:packsURL parameters:nil
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         
                         NSHTTPURLResponse *response = ((NSHTTPURLResponse *)[task response]);
                         NSTimeInterval timeInterval = 0;
                         if ([response respondsToSelector:@selector(allHeaderFields)]) {
                             NSDictionary *headers = [response allHeaderFields];
                             timeInterval = [headers[@"Last-Modified"] doubleValue];
                         }
                         
                         if ([responseObject[@"data"] count] == 0) {
                             STKLog(@"get empty stickers pack JSON");
                         }
                         
                         if (success) {
                             success(responseObject, timeInterval);
                         }
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         if (failure) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 failure(error);
                             });
                         }
                     }];

}

- (void)getStickersPackWithType:(NSString*)type
                        success:(void (^)(id response, NSTimeInterval lastModifiedDate))success
                        failure:(void (^)(NSError *error))failure {
    
    NSDictionary *parameters = nil;
    if (type) {
        parameters = @{@"type" : type};
    }

    [self.sessionManager GET:packsURL parameters:parameters
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         
                         NSHTTPURLResponse *response = ((NSHTTPURLResponse *)[task response]);
                         NSTimeInterval timeInterval = 0;
                         if ([response respondsToSelector:@selector(allHeaderFields)]) {
                             NSDictionary *headers = [response allHeaderFields];
                            timeInterval = [headers[@"Last-Modified"] doubleValue];
                         }

                         if ([responseObject[@"data"] count] == 0) {
                             STKLog(@"get empty stickers pack JSON");
                         }
                         
                         if (success) {
                            success(responseObject, timeInterval);
                         }
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         if (failure) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 failure(error);
                             });
                         }
                     }];
}


- (void)getStickerPackWithName:(NSString *)packName
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *))failure
{
    NSString *route = [NSString stringWithFormat:@"pack/%@", packName];
    
    [self.sessionManager GET:route parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end