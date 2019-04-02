//
//  CMPageContentView.m
//  CMDisplayTitleView
//
//  Created by CrabMan on 2018/1/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CMPageContentView.h"
@interface CMPageContentView ()<UICollectionViewDelegate,UICollectionViewDataSource>

/**是否动画*/
@property (nonatomic,assign) BOOL isAniming;
/**配置*/
@property (nonatomic,strong) CMPageTitleConfig *config;

@end

@implementation CMPageContentView


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout Config:(CMPageTitleConfig *)config{
    
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.config = config;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell" ];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
    }
    return self;
}

#pragma mark --- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.config.cm_childControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    //移除之前的子控件
     [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
   // 添加控制器
        UIViewController *VC = self.config.cm_childControllers[indexPath.row];
        VC.view.frame = CGRectMake(0, 0, self.cm_width, self.cm_height);
    
        [cell.contentView addSubview:VC.view];
    UILabel *label = [UILabel new];
    label.text = [self.config.cm_childControllers[indexPath.row] title];
    [label sizeToFit];
    label.center = cell.contentView.center;
    label.textColor = [UIColor blackColor];

    [cell.contentView addSubview:label];
    
    return cell;
    
    
    
    
}


#pragma --- UIScrollViewDelegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (self.cm_delegate) {
        [self.cm_delegate cm_pageContentViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
 
}

/**
 scrollView减速完成
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger offSetInx = offSetX;
    NSInteger screenWInt = CMSCREEN_W;
    NSInteger extre = offSetInx % screenWInt;

    if (extre > CMSCREEN_W*0.5) {
        //往右边移动
        offSetX = offSetX + (CMSCREEN_W - extre);
        _isAniming = YES;
        [self setContentOffset:CGPointMake(offSetX, 0) animated:YES];
    } else if (extre < CMSCREEN_W * 0.5 && extre > 0){
        _isAniming = YES;
        offSetX = offSetX - extre;
        [self setContentOffset:CGPointMake(offSetX, 0) animated:YES];
    }

    //获取角标
    NSInteger index = offSetX / CMSCREEN_W;
    
    //选中标题
    if (self.cm_delegate) {

        [self.cm_delegate cm_pageContentViewDidEndDeceleratingWithIndex:index];

    }
   
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _isAniming = NO;


}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isAniming || self.config.cm_childControllers.count == 0) return;

    if (self.cm_delegate) {
        [self.cm_delegate cm_pageContentViewDidScroll:scrollView];
    }

}





@end
