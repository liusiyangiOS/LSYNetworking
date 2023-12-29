//
//  ViewController.m
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/9/9.
//

#import "ViewController.h"
#import "XXXFriendInfoRequest.h"
#import "XXXFriendListRequest.h"
#import "XXXFirendInfo.h"
#import "LSYDownloadRequest.h"

@interface ViewController (){
    //friend info接口请求次数
    int _requestCount;
    
    UIButton *_downloadButton;
    UIProgressView *_progressView;
    
    LSYDownloadRequest *_downloadRequest;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *requestInfoButton = [self newButtonWithTitle:@"请求friend info" action:@selector(requestInfoButtonClicked)];
    requestInfoButton.frame = CGRectMake(20, 100, 150, 30);
    [self.view addSubview:requestInfoButton];
    
    UIButton *requestListButton = [self newButtonWithTitle:@"请求friend list" action:@selector(requestListButtonClicked)];
    requestListButton.frame = CGRectMake(200, 100, 150, 30);
    [self.view addSubview:requestListButton];
    
    _downloadButton = [self newButtonWithTitle:@"开始下载" action:@selector(downloadButtonClicked:)];
    [_downloadButton setTitle:@"停止下载" forState:UIControlStateSelected];
    _downloadButton.frame = CGRectMake(20, 150, 150, 30);
    [self.view addSubview:_downloadButton];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 200, 200, 10)];
    [self.view addSubview:_progressView];
}

#pragma mark - private method

- (UIButton *)newButtonWithTitle:(NSString *)title action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    button.layer.borderColor = UIColor.blueColor.CGColor;
    button.layer.borderWidth = 1;
    return button;
}

#pragma mark - action method

- (void)requestInfoButtonClicked{
    XXXFriendInfoRequest *request = [[XXXFriendInfoRequest alloc] init];
    //属性会自动转换为请求参数
    request.friendId = _requestCount;
    if (_requestCount == 0) {
        request.errorType = 2;
    }else if (_requestCount > 6){
        request.errorType = 1;
    }
    [request startRequestWithSuccessBlock:^(XXXFirendInfo *responseData) {
        NSLog(@"Request success:%@",responseData);
    } failureBlock:^(NSError * _Nonnull error) {
        NSLog(@"Request failed:%@",error);
        //如果想要区分error是业务逻辑的error还是HTTP的error,用isBusinessError这个字段来判断
        if (error.isBusinessError) {
            if (error.code == LSYNetworkNeedAuthenticationErrorCode) {
                //获取后台返回的其他信息进行处理
                //NSDictionary *extraInfo = error.extraInfo;
            }
        }
    }];
    
    _requestCount ++;
    if (_requestCount > 7) {
        _requestCount = 0;
    }
}

- (void)requestListButtonClicked{
    XXXFriendListRequest *request = [[XXXFriendListRequest alloc] init];
    request.size = 10;
    request.page = 0;
    [request startRequestWithSuccessBlock:^(NSArray<XXXFirendInfo *> *responseData) {
        NSLog(@"Request success:%@",responseData);
    } failureBlock:^(NSError * _Nonnull error) {
        NSLog(@"Request failed:%@",error);
    }];
}

- (void)downloadButtonClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (!_downloadRequest) {
            _downloadRequest = [LSYDownloadRequest new];
            _downloadRequest.url = @"https://issuepcdn.baidupcs.com/issue/netdisk/MACguanjia/BaiduNetdisk_mac_4.11.0_arm64.dmg";
        }
        [_downloadRequest startWithProgressBlock:^(int64_t completed, int64_t total) {
            [_progressView setProgress:completed * 1.0 / total];
        } successBlock:^(id responseData) {
            NSLog(@"Download success:%@",responseData);
            _downloadRequest = nil;
            sender.selected = NO;
            _progressView.progress = 0;
        } failureBlock:^(NSError *error) {
            NSLog(@"Download failed:%@",error);
            sender.selected = NO;
        }];
    }else{
        [_downloadRequest cancel];
    }
}

@end
