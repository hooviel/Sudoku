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
 *  储存用户输入的数字，二维数组；[pow(baseNumber, 2)][pow(baseNumber, 2)]
 */
@property (nonatomic, strong) NSMutableArray *arrArrInput;
/**
 *  储存结果，答案；数量[pow(baseNumber, 4)]
 */
@property (nonatomic, strong) NSMutableArray *arrResult;
/**
 *  记录哪些位置是确定的，确定为1(YES)，否则为0(NO)
 */
@property (nonatomic, strong) NSMutableArray *arrFix;
/**
 *  所有未确定数字的坐标位置的数字可能性，初始值为0，表示没有可能值
 */
@property (nonatomic, strong) NSMutableArray *arrArrPossible;
/**
 *  未确定数字的坐标栈，存储的是未确定位置的线性坐标
 */
@property (nonatomic, strong) NSMutableArray *arrStack;

/**
 *  加载游戏数据
 */
- (void)load;

/**
 *  重置
 */
- (void)reset;

/**
 *  判断指定行是否存在相同的数字
 *
 *  @param row   行索引
 *  @param value 数字
 *
 *  @return return BOOL
 */
- (BOOL)isExistInRow:(NSInteger)row value:(NSInteger)value;
/**
 *  判断指定列是否存在相同的数字
 *
 *  @param col   列索引
 *  @param value 数字
 *
 *  @return return BOOL
 */
- (BOOL)isExistInCol:(NSInteger)col value:(NSInteger)value;
/**
 *  判断指定行列坐标所在的小矩阵是否存在相同的数字
 *
 *  @param row   行索引
 *  @param col   列索引
 *  @param value 数字
 *
 *  @return return BOOL
 */
- (BOOL)isExistInSquareWithRow:(NSInteger)row col:(NSInteger)col value:(NSInteger)value;
/**
 *  检查线性所以除的指定值是否存在于当前 行、列、小矩阵中
 *
 *  @param index 线性索引
 *  @param value 数字
 *
 *  @return return value description
 */
- (BOOL)isExistByResultIndex:(NSInteger)index value:(NSInteger)value;

/**
 *  线性索引转换到矩阵的 行索引
 *
 *  @param index 线性索引
 *
 *  @return return value description
 */
- (NSInteger)translateIndexToRowAtIndex:(NSInteger)index;
/**
 *  线性索引转换到矩阵的 列索引
 *
 *  @param index 线性缩影
 *
 *  @return return value description
 */
- (NSInteger)translateIndexToColAtIndex:(NSInteger)index;
/**
 *  将结果转换到用户输入的矩阵容器中
 *
 *  @param index 线性索引
 */
- (void)translateResultToInputAtIndex:(NSInteger)index;
/**
 *  将用户输入的矩阵转换到结果线性容器总
 */
- (void)translateInputToResult;

/**
 *  出题
 */
- (void)makeProblem;
/**
 *  随机输入第一行的数字
 */
- (void)randomInputFirstRow;
/**
 *  填充矩阵
 */
- (void)fillMatrix;
/**
 *  设置所有未确定坐标的可能值
 */
- (void)setAllPossible;
/**
 *  检查是否确定了所有坐标位置的数字，也就是说，所有坐标上的数字只有一个可能值；
 *
 *  @return return BOOL
 */
- (BOOL)isFixedAll;
/**
 *  检查是否填充了所有输入坐标
 *
 *  @return return BOOL
 */
- (BOOL)isFilledAll;

@end
