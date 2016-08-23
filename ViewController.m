//
//  ViewController.m
//  QLPreviewControllerDemo
//
//  Created by 孔彬 on 16/8/16.
//  Copyright © 2016年 KB. All rights reserved.
//

#import "ViewController.h"
#import <QuickLook/QuickLook.h>
#import "AFNetworking.h"

@interface ViewController () <QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@end

@implementation ViewController

- (IBAction)URLDocument:(id)sender {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileName = @"79262309-b0db-4039-bdcf-2cabdd04f0f7.docx";
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (exist) {
        NSLog(@"直接打开");
        QLPreviewController *previewController = [[QLPreviewController alloc] init];
        previewController.dataSource = self;
        previewController.delegate = self;
        [self presentViewController:previewController animated:YES completion:nil];
    } else {
        NSLog(@"开始下载");
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSString *wordPath = @"http://uqg-test.img-cn-beijing.aliyuncs.com/CompanyData/Attachment/UQG_FreeTrail_4/2016/8/8/79262309-b0db-4039-bdcf-2cabdd04f0f7.docx";
        NSURL *URL = [NSURL URLWithString:wordPath];

        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            //这里已经写入本地了
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //在这里你可以获取到文件名以及路径
            NSLog(@"File downloaded to: %@", filePath);
            if (!error) {
                QLPreviewController *previewController = [[QLPreviewController alloc] init];
                previewController.dataSource = self;
                previewController.delegate = self;
                [self presentViewController:previewController animated:YES completion:nil];
            } else {
                NSLog(@"下载失败");
            }
        }];
        [downloadTask resume];
    }
}



#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileName = @"79262309-b0db-4039-bdcf-2cabdd04f0f7.docx";
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    return [NSURL fileURLWithPath:filePath];
}

- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
    NSLog(@"视图即将dismiss");
}

@end
