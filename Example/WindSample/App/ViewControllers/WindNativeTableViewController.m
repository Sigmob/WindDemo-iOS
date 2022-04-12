//
//  WindNativeTableViewController.m
//  WindmillSample
//
//  Created by Codi on 2021/12/9.
//

#import "WindNativeTableViewController.h"
#import <WindSDK/WindSDK.h>
#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "WindFeedAdViewStyle.h"
#import "FeedNormalModel.h"
#import "WindFeedNormalTableViewCell.h"
#import "WindFeedAdLeftTableViewCell.h"
#import "WindFeedAdLargeTableViewCell.h"
#import "WindFeedVideoTableViewCell.h"
#import <UIView+Toast.h>

@interface WindNativeTableViewController ()<WindNativeAdsManagerDelegate, WindNativeAdViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) WindNativeAdsManager *nativeAdsManager;
@property (nonatomic, strong) NSMutableDictionary *nativeExpressViewHeightDict;
@end

@implementation WindNativeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    _nativeExpressViewHeightDict = [NSMutableDictionary new];
    self.dataSource = [NSMutableArray new];
    [self pbud_resetDemoData];
    [self init_tableView];
    [self loadAdData];
}

// 重置测试数据，非广告数据
- (void)pbud_resetDemoData {
    NSString *feedPath = [[NSBundle mainBundle] pathForResource:@"feedInfo" ofType:@"cactus"];
    NSString *feedStr = [NSString stringWithContentsOfFile:feedPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr = [FeedNormalModel mj_objectArrayWithKeyValuesArray:[feedStr mj_JSONObject]];
    self.dataSource = [NSMutableArray new];
    [self.dataSource addObjectsFromArray:arr];
    NSInteger datasCount = arr.count;
    if (datasCount > 3) {
        for (int i = 0; i < datasCount; i++) {
            NSUInteger index = rand() % (datasCount - 3) + 2;
            [self.dataSource addObject:[arr objectAtIndex:index]];
        }
    }
}

- (void)pbud_insertIntoDataSourceWithArray:(NSArray *)array {
    if (self.dataSource.count > 3) {
        //随机
        for (id item in array) {
            NSUInteger index = rand() % (self.dataSource.count - 3) + 2;
            [self.dataSource insertObject:item atIndex:index];
        }
    }else {
        [self.dataSource addObjectsFromArray:array];
    }
}

- (void)init_tableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view).offset(0);
    }];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[WindFeedNormalTableViewCell class]
           forCellReuseIdentifier:@"WindFeedNormalTableViewCell"];
    [self.tableView registerClass:[WindFeedNormalTitleTableViewCell class] forCellReuseIdentifier:@"WindFeedNormalTitleTableViewCell"];
    [self.tableView registerClass:[WindFeedNormalTitleImgTableViewCell class] forCellReuseIdentifier:@"WindFeedNormalTitleImgTableViewCell"];
    [self.tableView registerClass:[WindFeedNormalBigImgTableViewCell class] forCellReuseIdentifier:@"WindFeedNormalBigImgTableViewCell"];
    [self.tableView registerClass:[WindFeedNormalthreeImgTableViewCell class] forCellReuseIdentifier:@"WindFeedNormalthreeImgTableViewCell"];
    [self.tableView registerClass:[WindFeedAdLeftTableViewCell class]
           forCellReuseIdentifier:@"WindFeedAdLeftTableViewCell"];
    [self.tableView registerClass:[WindFeedAdLargeTableViewCell class]
           forCellReuseIdentifier:@"WindFeedAdLargeTableViewCell"];
    [self.tableView registerClass:[WindFeedVideoTableViewCell class]
           forCellReuseIdentifier:@"WindFeedVideoTableViewCell"];
}


- (void)loadAdData {
    if (!self.nativeAdsManager) {
        WindAdRequest *request = [WindAdRequest request];
        request.placementId = self.placementId;
        request.userId = @"your user id";
        request.options = @{@"test_key_1":@"test_value"};//s2s激励回传自定义参数，可以为nil
        self.nativeAdsManager = [[WindNativeAdsManager alloc] initWithRequest:request];
    }
    self.nativeAdsManager.delegate = self;
    [self.nativeAdsManager loadAdDataWithCount:3];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    id model = self.dataSource[index];
    if ([model isKindOfClass:[FeedNormalModel class]]) {
        return [(FeedNormalModel *)model cellHeight];
    }
    if ([model isKindOfClass:[WindNativeAd class]]) {
        WindNativeAd *nativeAd = (WindNativeAd *)model;
        CGFloat width = CGRectGetWidth(self.tableView.bounds);
        return [WindFeedAdViewStyle cellHeightWithModel:nativeAd width:width];
    }
    return 0;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSString *)classNameWithCellType:(NSString *)type {
    if ([type isEqualToString: @"title"]) {
        return @"WindFeedNormalTitleTableViewCell";
    }else if ([type isEqualToString: @"titleImg"]){
        return @"WindFeedNormalTitleImgTableViewCell";
    }else if ([type isEqualToString: @"bigImg"]){
        return @"WindFeedNormalBigImgTableViewCell";
    }else if ([type isEqualToString: @"threeImgs"]){
        return @"WindFeedNormalthreeImgTableViewCell";
    }else{
        return @"unkownCell";
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    id model = self.dataSource[index];
    if ([model isKindOfClass:[FeedNormalModel class]]) {
        NSString *clazz=[self classNameWithCellType:[(FeedNormalModel *)model type]];
        WindFeedNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:clazz forIndexPath:indexPath];
        if (!cell) {
            cell = [(WindFeedNormalTableViewCell *)[NSClassFromString(clazz) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:clazz];
        }
        if (indexPath.row == 0) {
            cell.separatorLine.hidden = YES;
        }
        [cell refreshUIWithModel:model];
        return cell;
    }
    if ([model isKindOfClass:[WindNativeAd class]]) {
        WindNativeAd *nativeAd = (WindNativeAd *)model;
        WindFeedAdBaseTableViewCell<WindFeedCellProtocol> *cell;
        if (nativeAd.feedADMode == WindFeedADModeSmallImage) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"WindFeedAdLeftTableViewCell" forIndexPath:indexPath];
        }else if (nativeAd.feedADMode == WindFeedADModeLargeImage) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"WindFeedAdLargeTableViewCell" forIndexPath:indexPath];
        }else if (nativeAd.feedADMode == WindFeedADModeVideo || nativeAd.feedADMode == WindFeedADModeVideoPortrait || nativeAd.feedADMode == WindFeedADModeVideoLandSpace) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"WindFeedVideoTableViewCell" forIndexPath:indexPath];
        }
        [cell refreshUIWithModel:nativeAd rootViewController:self delegate:self];
        return cell;
    }
    return nil;
}


#pragma mark - WindNativeAdsManagerDelegate
- (void)nativeAdsManagerSuccessToLoad:(WindNativeAdsManager *)adsManager nativeAds:(NSArray<WindNativeAd *> *)nativeAdDataArray {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), adsManager.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self pbud_insertIntoDataSourceWithArray:nativeAdDataArray];
    [self.tableView reloadData];
}

- (void)nativeAdsManager:(WindNativeAdsManager *)adsManager didFailWithError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), adsManager.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
}

#pragma mark - WindNativeAdViewDelegate
- (void)nativeExpressAdViewRenderSuccess:(WindNativeAdView *)nativeExpressAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
}

- (void)nativeExpressAdViewRenderFail:(WindNativeAdView *)nativeExpressAdView error:(NSError *)error {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
}

/**
 广告曝光回调
 
 @param nativeAdView WindNativeAdView 实例
 */
- (void)nativeAdViewWillExpose:(WindNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
}


/**
 广告点击回调
 
 @param nativeAdView WindNativeAdView 实例
 */
- (void)nativeAdViewDidClick:(WindNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
}


/**
 广告详情页关闭回调
 
 @param nativeAdView WindNativeAdView 实例
 */
- (void)nativeAdDetailViewClosed:(WindNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
}


/**
 广告详情页面即将展示回调
 
 @param nativeAdView WindNativeAdView 实例
 */
- (void)nativeAdDetailViewWillPresentScreen:(WindNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
}


/**
 视频广告播放状态更改回调
 
 @param nativeAdView WindNativeAdView 实例
 @param status 视频广告播放状态
 @param userInfo 视频广告信息
 */
- (void)nativeAdView:(WindNativeAdView *)nativeAdView playerStatusChanged:(WindMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
}

- (void)nativeAdView:(WindNativeAdView *)nativeAdView dislikeWithReason:(NSArray<WindDislikeWords *> *)filterWords{
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    //dislike，需要主动移除广告视图，否则有可能出现点击关闭无反应
    [nativeAdView unregisterDataObject];
    NSUInteger index = [self.dataSource indexOfObject:nativeAdView.nativeAd];
    [self.dataSource removeObject:nativeAdView.nativeAd];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
