//
//  ViewController.m
//  GegeMusic
//
//  Created by GQuEen on 16/5/14.
//  Copyright © 2016年 GegeChen. All rights reserved.
//

#import "ViewController.h"
#import "MBSegmentedView.h"
#import "GGSongModel.h"
#import "GGSongViewModel.h"
#import "GGMusicCell.h"
#import "GGPlayToolView.h"

#define MUSIC_API @"http://route.showapi.com/213-4"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) MBSegmentedView *segmentedView;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) GGPlayToolView *playToolView;

@property (assign ,nonatomic) BOOL isLoadedChinaData;
@property (assign ,nonatomic) BOOL isLoadedEMData;
@property (assign ,nonatomic) BOOL isLoadedHTData;
@property (assign ,nonatomic) BOOL isLoadedKData;

@property (strong, nonatomic) NSMutableArray *tableViewArray;
@property (strong, nonatomic) NSMutableArray *musicChinaData;
@property (strong, nonatomic) NSMutableArray *musicEMData;
@property (strong, nonatomic) NSMutableArray *musicHTData;
@property (strong, nonatomic) NSMutableArray *musicKData;

@property (strong, nonatomic) UITableView *currentSelectedTableView;
@property (strong, nonatomic) GGMusicCell *currentSelectedCell;
@property (strong, nonatomic) GGSongViewModel *currenSelectedViewModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationItem.title = @"热门榜单";
    
    NSArray *segments = @[@"内地",@"欧美",@"港台",@"韩国"];
    
    _segmentedView = [[MBSegmentedView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-65) withSegments:segments];
    [self setupTableView];
    __weak typeof(self) weakSelf = self;
    _segmentedView.clickSegmentBtnBlock = ^(UIButton *sender) {
        
        [weakSelf segmentBtnClick:sender];
    };
    [self loadNetDataWithTopStyle:GGMusicDataTopStyleChina];
    
    _segmentedView.scrollViewBlock = ^(NSInteger index) {
        if (index == 1 && !_isLoadedEMData) {
            [weakSelf loadNetDataWithTopStyle:GGMusicDataTopStyleEM];
        }else if (index == 2 && !_isLoadedHTData) {
            [weakSelf loadNetDataWithTopStyle:GGMusicDataTopStyleHT];
        }else if (index == 3 && !_isLoadedKData) {
            [weakSelf loadNetDataWithTopStyle:GGMusicDataTopStyleK];
        }
    };
    _playToolView = [[GGPlayToolView alloc]initWithFrame:CGRectMake(0, ScreenHeight-65, ScreenWidth, 65)];
    [self.view addSubview:self.playToolView];
    [self.view addSubview:self.segmentedView];
    // Do any additional setup after loading the view, typically from a nib.
}
//配置tableview
- (void)setupTableView {
    _tableViewArray = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(i*ScreenWidth, 0, ScreenWidth, self.segmentedView.backScrollView.frame.size.height) style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tag = i;
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 0;
        tableView.hidden = YES;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableViewArray addObject:tableView];
        [_segmentedView.backScrollView addSubview:tableView];
    }
}

//加载网络数据

- (void)loadNetDataWithTopStyle:(GGMusicDataTopStyle)topStyle {
    
    NSString *topid;
    __block NSInteger tag;
    __block NSMutableArray *dataArray;
    switch (topStyle) {
        case GGMusicDataTopStyleChina:
            topid = @"5";
            tag = 0;
            _musicChinaData = [NSMutableArray array];
            dataArray = self.musicChinaData;
            break;
        case GGMusicDataTopStyleEM:
            topid = @"3";
            tag = 1;
            _musicEMData = [NSMutableArray array];
            dataArray = self.musicEMData;
            break;
        case GGMusicDataTopStyleHT:
            topid = @"6";
            tag = 2;
            _musicHTData = [NSMutableArray array];
            dataArray = self.musicHTData;
            break;
        case GGMusicDataTopStyleK:
            topid = @"16";
            tag = 3;
            _musicKData = [NSMutableArray array];
            dataArray = self.musicKData;
            break;
        default:
            break;
    }
    
    NSDictionary *parameter = @{@"showapi_appid":@"6091",
                                @"showapi_sign":@"a3b9cb3921c74e0ba31d2d7b2fbbed77",
                                @"topid":topid};
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak typeof(self) weakSelf = self;

    [manger POST:@"http://route.showapi.com/213-4" parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        //记载数据的菊花
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *songList = dic[@"showapi_res_body"][@"pagebean"][@"songlist"];
        
        for (int i = 0; i < songList.count; i ++) {
            GGSongModel *model = [[GGSongModel alloc]initWithDictionary:songList[i]];
            GGSongViewModel *viewModel = [[GGSongViewModel alloc]init];
            viewModel.model = model;
            [dataArray addObject:viewModel];
        }
        
        UITableView *tableView = weakSelf.tableViewArray[tag];
        tableView.hidden = NO;
        [tableView reloadData];
        
        if (tag == 0) {
            weakSelf.isLoadedChinaData = YES;
        }else if (tag == 1) {
            weakSelf.isLoadedEMData = YES;
        }else if (tag == 2) {
            weakSelf.isLoadedHTData = YES;
        }else if (tag == 3) {
            weakSelf.isLoadedKData = YES;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败

        NSLog(@"数据请求失败");
    }];
}


#pragma mark - segmentedView 
- (void)segmentBtnClick:(UIButton *)sender {
    if (_segmentedView.currentSelectBtn != sender) {
        sender.selected = YES;
        _segmentedView.currentSelectBtn.selected = NO;
        _segmentedView.currentSelectBtn = sender;
    }
    _segmentedView.backScrollView.contentOffset = CGPointMake(sender.tag*ScreenWidth, 0);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.segmentedView.underLine.frame = CGRectMake(sender.frame.origin.x, weakSelf.segmentedView.underLine.frame.origin.y, weakSelf.segmentedView.underLine.frame.size.width, weakSelf.segmentedView.underLine.frame.size.height);
    } completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 0) {
        return self.musicChinaData.count;
    }else if (tableView.tag == 1) {
        return self.musicEMData.count;
    }
    else if (tableView.tag == 2) {
        return self.musicHTData.count;
    }
    else if (tableView.tag == 3) {
        return self.musicKData.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        return ((GGSongViewModel *)self.musicChinaData[indexPath.section]).cellHeight;
    }else if (tableView.tag == 1) {
        return ((GGSongViewModel *)self.musicEMData[indexPath.section]).cellHeight;
    }
    else if (tableView.tag == 2) {
        return ((GGSongViewModel *)self.musicHTData[indexPath.section]).cellHeight;
    }
    else if (tableView.tag == 3) {
        return ((GGSongViewModel *)self.musicKData[indexPath.section]).cellHeight;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.00001;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGMusicCell *cell = [GGMusicCell cellWithTableView:tableView];
    GGSongViewModel *viewModel;
    if (tableView.tag == 0) {
        viewModel = self.musicChinaData[indexPath.section];
    }else if (tableView.tag == 1) {
        viewModel = self.musicEMData[indexPath.section];
    }
    else if (tableView.tag == 2) {
        viewModel = self.musicHTData[indexPath.section];
    }
    else if (tableView.tag == 3) {
        viewModel = self.musicKData[indexPath.section];
    }else {
        return 0;
    }
    
    cell.viewModel = viewModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_currentSelectedTableView && !_currentSelectedCell) {
        //当第一次点击tableview的cell的时候
        _currentSelectedTableView = tableView;//保存本次点击的tableview 以便下次点击的时候判断是否为同一个tableview
        GGMusicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        _currentSelectedCell = cell;
        GGSongViewModel *newViewModel = cell.viewModel;
        newViewModel.playColor = MAIN_COLOR;
        _currenSelectedViewModel = newViewModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.play.backgroundColor = newViewModel.playColor;
        
        _playToolView.model = newViewModel.model;
    }else if (_currentSelectedTableView && tableView != self.currentSelectedTableView) {
        //不是第一次点击cell 且 点击的tableview不同
        GGMusicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell != self.currentSelectedCell) {
            GGSongViewModel *newViewModel = cell.viewModel;
            newViewModel.playColor = MAIN_COLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.play.backgroundColor = newViewModel.playColor;
            
            _playToolView.model = newViewModel.model;
            //获取上次点击的tableview的cell
            NSIndexPath *lastIndexPath = [self.currentSelectedTableView indexPathForSelectedRow];
            GGMusicCell *cell1 = [self.currentSelectedTableView cellForRowAtIndexPath:lastIndexPath];
            GGSongViewModel *newViewModel1 = cell1.viewModel;
            newViewModel1.playColor = [UIColor clearColor];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell1.play.backgroundColor = newViewModel1.playColor;
            _currentSelectedTableView = tableView;
            _currentSelectedCell = cell;
            _currenSelectedViewModel = newViewModel;
        }
    }else {
        //与上次点击的tableview为同一个的时候
        GGMusicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.viewModel.model != self.currenSelectedViewModel.model) {
            GGSongViewModel *newViewModel = cell.viewModel;
            newViewModel.playColor = MAIN_COLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.play.backgroundColor = newViewModel.playColor;
            
            _playToolView.model = newViewModel.model;
            
            GGMusicCell *cell1 = self.currentSelectedCell;
            GGSongViewModel *newViewModel1 = self.currenSelectedViewModel;
            newViewModel1.playColor = [UIColor clearColor];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell1.play.backgroundColor = newViewModel1.playColor;
            _currentSelectedCell = cell;
            _currenSelectedViewModel = newViewModel;
        }
    }
    
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    GGMusicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.play.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
