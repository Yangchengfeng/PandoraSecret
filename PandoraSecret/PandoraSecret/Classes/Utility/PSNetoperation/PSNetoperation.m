//
//  PSNetoperation.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/8.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSNetoperation.h"

@implementation PSNetoperation

#pragma mark - 利用搭建在阿里云服务器
+ (void)getRequestWithConcretePartOfURL:(NSString *)urlStr parameter:(id)param success:(success)success  andError:(responseError)responseError {
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLStr]];
    [httpManager GET:urlStr parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(responseError) {
            responseError(error);
        }
    }];
}

+ (void)getRequestWithConcretePartOfURL:(NSString *)urlStr parameter:(id)param success:(success)success failure:(failure)failure andError:(responseError)responseError {
    [self getRequestWithConcretePartOfURL:urlStr parameter:param success:^(id responseObject) {
        if([responseObject[@"status"] isEqual:@1]) {
            if(success) {
                success(responseObject);
            }
        } else {
            if(failure) {
                failure(responseObject);
            }
        }
    } andError:^(NSError *error) {
        if(responseError) {
            responseError(error);
        }
    }];
}

+ (void)postRequestWithConcretePartOfURL:(NSString *)urlStr parameter:(id)param success:(success)success  andError:(responseError)responseError {
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLStr]];
    [httpManager POST:urlStr parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(responseError) {
            responseError(error);
        }
    }];
}

+ (void)postRequestWithConcretePartOfURL:(NSString *)urlStr parameter:(id)param success:(success)success failure:(failure)failure andError:(responseError)responseError {
    [self postRequestWithConcretePartOfURL:urlStr parameter:param success:^(id responseObject) {
        if([responseObject[@"status"] isEqual:@1]) {
            if(success) {
                success(responseObject);
            }
        } else {
            if(failure) {
                failure(responseObject);
            }
        }
    } andError:^(NSError *error) {
        if(responseError) {
            responseError(error);
        }
    }];
}

#pragma mark - 图床上传

+ (void)postPicUploadWithImage:(UIImage *)image success:(success)success failure:(failure)failure andError:(responseError)responseError {
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    
    [httpManager POST:kBasePicUploadURLStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 时间+uuid
        NSData *data = UIImageJPEGRepresentation(image, 0.3);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@_%@.png", [UIDevice currentDevice].identifierForVendor, str];
        
        [formData appendPartWithFileData:data name:@"smfile" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject[@"code"] isEqualToString:@"success"]) {
            if(success) {
                success(responseObject);
            }
        } else {
            if(failure) {
                failure(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(responseError) {
            responseError(error);
        }
    }];
}

@end
