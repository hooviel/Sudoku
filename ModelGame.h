//
//  ModelGame.h
//  Sudoku
//
//  Created by David on 15/5/14.
//  Copyright (c) 2015年 David. All rights reserved.
//

#import "ModelBase.h"

@interface ModelGame : ModelBase

/**
 *  矩阵基数，矩阵维数(行或列 数数量) = pow(baseNumber, 2); 默认为3
 */
@property (nonatomic, assign) NSInteger baseNumber;
/**
 *  开始的数字，默认为1
 */
@property (nonatomic, assign) NSInteger beginNumber;
/**
 *  数字间隔，默认为1
 */
@property (nonatomic, assign) NSInteger intervalsNumber;
/**
 *  游戏难度, 默认1
 */
@property (nonatomic, assign) NSInteger gameDifficulty;
/**
 *  矩阵维数 = pow(baseNumber, 2)
 */
@property (nonatomic, assign, readonly) NSInteger matrixDimension;

/**
 *  种子数字，矩阵中所有被正确填充的数字都来种子数字
 */
@property (nonatomic, strong, readonly) NSArray *arrSeedsNumber;


/**
 *  加载游戏数据
 */
- (void)load;

/**
 *  重置
 */
- (void)reset;

@end
