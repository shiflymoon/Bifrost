//
//  ShoppingCartViewController.m
//  Sale
//
//  Created by yangke on 2019/2/28.
//  Copyright © 2019 yangke. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingCartManager.h"
#import "YZSTableViewModel.h"
#import "YZWeakDefine.h"
#import "CTMediator+GoodModule.h"

@interface ShoppingCartViewController ()<YZSTableViewModelDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YZSTableViewModel *viewModel;
@property (nonatomic, strong) NSArray *shoppingCartItemList;
@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Shopping Cart";
    self.navigationItem.backBarButtonItem.title = @"";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.shoppingCartItemList = [[[ShoppingCartManager sharedInstance] cartItemDict] allValues];
    [self reloadViewModel];
}

- (YZSTableViewModel*)viewModel {
    if(!_viewModel) {
        _viewModel = [[YZSTableViewModel alloc] init];
        self.tableView.dataSource = _viewModel;
        self.tableView.delegate = _viewModel;
        _viewModel.delegate = self;
    }
    return _viewModel;
}

- (void)reloadViewModel {
    [self.viewModel.sectionModelArray removeAllObjects];
    //goods info section
    {
        YZSTableViewSectionModel *sectionModel = [[YZSTableViewSectionModel alloc] init];
        [self.viewModel.sectionModelArray addObject:sectionModel];
        static NSString *CellIdentifier = @"GoodsCell";
        YZWeak(self);
        
        //popular goods list
        for (ShoppingCartItem *item in [ShoppingCartManager sharedInstance].cartItemDict.allValues) {
            YZSTableViewCellModel *cellModel = [[YZSTableViewCellModel alloc] init];
            [sectionModel.cellModelArray addObject:cellModel];
            cellModel.height = 44;
            NSDictionary* goods = [[CTMediator sharedInstance] goodModule_goodsById:item.goodsId];
            YZWeak(item)
            cellModel.renderBlock = ^UITableViewCell * _Nonnull(NSIndexPath * _Nonnull indexPath, UITableView * _Nonnull tableView) {
                YZStrong(self)
                YZStrong(item)
                UITableViewCell *cell = [self reusableCellWithId:CellIdentifier inView:tableView];
                NSString *text = [NSString stringWithFormat:@"%@ : ￥%.2f x %lu",goods[kGoodsModelParamGoodName],[goods[kGoodsModelParamGoodPrice] floatValue],item.num];
                cell.textLabel.text = text;
                return cell;
            };
        }
        //Total Price
        YZSTableViewCellModel *cellModel = [[YZSTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = 44;
        cellModel.renderBlock = ^UITableViewCell * _Nonnull(NSIndexPath * _Nonnull indexPath, UITableView * _Nonnull tableView) {
            YZStrong(self)
            UITableViewCell *cell = [self reusableCellWithId:CellIdentifier inView:tableView];
            cell.textLabel.text = [NSString stringWithFormat:@"Total Price : ￥%.2f", [self totalPrice]];
            return cell;
        };
    }
    [self.tableView reloadData];
}

- (CGFloat)totalPrice {
    CGFloat totalPrice = 0;
    
    for (ShoppingCartItem *item in self.shoppingCartItemList) {
        NSDictionary * goods = [[CTMediator sharedInstance] goodModule_goodsById:item.goodsId];
        totalPrice += [goods[kGoodsModelParamGoodPrice] floatValue] * item.num;
    }
    return totalPrice;
}

- (UITableViewCell*)reusableCellWithId:(NSString*)identifier
                                inView:(UITableView*)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

@end
