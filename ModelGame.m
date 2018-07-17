//
//  ModelGame.m
//  Sudoku
//
//  Created by David on 15/5/14.
//  Copyright (c) 2015年 David. All rights reserved.
//

#import "ModelGame.h"

@interface ModelGame ()

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

@implementation ModelGame
{
    
}

@synthesize matrixDimension = _matrixDimension;

#pragma mark - property
/**
 *  取值区间:[2,4]
 *
 *  @param baseNumber
 */
- (void)setBaseNumber:(NSInteger)baseNumber
{
    if (NSLocationInRange(baseNumber, NSMakeRange(2, 3))) {
        _baseNumber = baseNumber;
    }
}

/**
 *  取值范围：beginNumber > 0
 *
 *  @param beginNumber
 */
- (void)setBeginNumber:(NSInteger)beginNumber
{
    if (beginNumber>0) {
        _beginNumber = beginNumber;
    }
}

/**
 *  intervalsNumber > 0
 *
 *  @param intervalsNumber
 */
- (void)setIntervalsNumber:(NSInteger)intervalsNumber
{
    if (intervalsNumber>0) {
        _intervalsNumber = intervalsNumber;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDefaultConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)initDefaultConfig
{
    _baseNumber = 2;
    _beginNumber = 1;
    _intervalsNumber = 1;
    _gameDifficulty = 1;
    
    // 设置随机基数（知道为啥你的随机数，每次启动都是一样的随机顺序了吧？）
    srandom((unsigned int)time(0));
}

/**
 *  加载游戏数据
 */
- (void)load
{
    [self reset];
}
/**
 *  重置
 */
- (void)reset
{
    _matrixDimension = (NSInteger)powf(_baseNumber, 2);
    _arrStack = [NSMutableArray array];
    _arrArrInput = [NSMutableArray arrayWithCapacity:_matrixDimension];
    NSMutableArray *arrSeedsNumber = [NSMutableArray arrayWithCapacity:_matrixDimension];
    for (NSInteger row=0; row<_matrixDimension; row++) {
        NSMutableArray *arrColInput = [NSMutableArray arrayWithCapacity:_matrixDimension];
        for (NSInteger col=0; col<_matrixDimension; col++) {
            [arrColInput addObject:@0];
        }
        [_arrArrInput addObject:arrColInput];
        [arrSeedsNumber addObject:@(_beginNumber+_intervalsNumber*row)];
    }
    _arrSeedsNumber = [NSArray arrayWithArray:arrSeedsNumber];
    
    NSInteger matrixSize = (NSInteger)powf(_matrixDimension, 2);
    _arrResult = [NSMutableArray arrayWithCapacity:matrixSize];
    _arrFix = [NSMutableArray arrayWithCapacity:matrixSize];
    for (NSInteger i=0; i<matrixSize; i++) {
        [_arrResult addObject:@0];
        [_arrFix addObject:@0];
    }
    
    _arrArrPossible = [NSMutableArray arrayWithCapacity:matrixSize];
    for (NSInteger i=0; i<matrixSize; i++) {
        NSMutableArray *arrPossible = [NSMutableArray arrayWithCapacity:_matrixDimension];
        for (NSInteger j=0; j<_matrixDimension; j++) {
            [arrPossible addObject:@0];
        }
        [_arrArrPossible addObject:arrPossible];
    }
    
    
    [self randomInputFirstRow];
}

/**
 *  判断指定行是否存在相同的数字
 *
 *  @param row   行索引
 *  @param value 数字
 *
 *  @return return BOOL
 */
- (BOOL)isExistInRow:(NSInteger)row value:(NSInteger)value
{
    BOOL isExist = NO;
    for(NSInteger i=0; i<_matrixDimension; i++)
    {
        NSInteger val = [_arrArrInput[row][i] integerValue];
        if (val==value) {
            isExist = YES;
            break;
        }
    }
    return isExist;
}
/**
 *  判断指定列是否存在相同的数字
 *
 *  @param col   列索引
 *  @param value 数字
 *
 *  @return return BOOL
 */
- (BOOL)isExistInCol:(NSInteger)col value:(NSInteger)value
{
    BOOL isExist = NO;
    for(NSInteger i=0; i<_matrixDimension; i++)
    {
        NSInteger val = [_arrArrInput[i][col] integerValue];
        if (val==value) {
            isExist = YES;
            break;
        }
    }
    return isExist;
}
/**
 *  判断指定行列坐标所在的小矩阵是否存在相同的数字
 *
 *  @param row   行索引
 *  @param col   列索引
 *  @param value 数字
 *
 *  @return return BOOL
 */
- (BOOL)isExistInSquareWithRow:(NSInteger)row col:(NSInteger)col value:(NSInteger)value
{
    BOOL isExist = NO;
    NSInteger
    ROW = (NSInteger)(row/_baseNumber),
    COL = (NSInteger)(col/_baseNumber);
    for(NSInteger i=ROW*_baseNumber; i<(ROW+1)*_baseNumber; i++)
    {
        
        for(NSInteger j=COL*_baseNumber; j<(COL+1)*_baseNumber; j++)
        {
            NSInteger val = [_arrArrInput[i][j] integerValue];
            if (val==value) {
                isExist = YES;
                break;
            }
        }
        
        if (isExist) break;
    }
    return isExist;
}

/**
 *  检查线性所以除的指定值是否存在于当前 行、列、小矩阵中
 *
 *  @param index 线性索引
 *  @param value 数字
 *
 *  @return return value description
 */
- (BOOL)isExistByResultIndex:(NSInteger)index value:(NSInteger)value
{
    BOOL isExist = NO;
    NSInteger row = [self translateIndexToRowAtIndex:index];
    NSInteger col = [self translateIndexToColAtIndex:index];
    if ([self isExistInCol:col value:value]
        || [self isExistInRow:row value:value]
        || [self isExistInSquareWithRow:row col:col value:value]) {
        isExist = YES;
    }
    return isExist;
}

// ------------------- 线性数组和二维数组转换函数
/**
 *  线性索引转换到矩阵的 行索引
 *
 *  @param index 线性索引
 *
 *  @return return value description
 */
- (NSInteger)translateIndexToRowAtIndex:(NSInteger)index
{
    return index/_matrixDimension;
}

/**
 *  线性索引转换到矩阵的 列索引
 *
 *  @param index 线性缩影
 *
 *  @return return value description
 */
- (NSInteger)translateIndexToColAtIndex:(NSInteger)index
{
    return index%_matrixDimension;
}

/**
 *  将结果转换到用户输入的矩阵容器中
 *
 *  @param index 线性索引
 */
- (void)translateResultToInputAtIndex:(NSInteger)index
{
    NSInteger row = [self translateIndexToRowAtIndex:index];
    NSInteger col = [self translateIndexToColAtIndex:index];
    _arrArrInput[row][col] = _arrResult[index];
}
/**
 *  将用户输入的矩阵转换到结果线性容器总
 */
- (void)translateInputToResult
{
    for (NSInteger row=0; row<_arrArrInput.count; row++) {
        NSMutableArray *arrColInput = _arrArrInput[row];
        for (NSInteger col=0; col<arrColInput.count; col++) {
            _arrResult[row*_matrixDimension+col] = _arrArrInput[row][col];
        }
    }
}

// ------------------- 游戏相关

/**
 *  出题
 */
- (void)makeProblem
{
    [self randomInputFirstRow];
    [self fillMatrix];
}

/**
 *  随机输入第一行行
 */
- (void)randomInputFirstRow
{
    // 已打乱排序的种子
    NSMutableArray *arrNumbOrdered = [NSMutableArray arrayWithCapacity:_matrixDimension];
    for (NSInteger i=0; i<_matrixDimension; i++) {
        [arrNumbOrdered addObject:@0];
    }
    
    // 随机打乱种子
    for (NSInteger i=0;i<_matrixDimension;) {
        NSInteger index=rand()%_matrixDimension;
        NSInteger number = [_arrSeedsNumber[index] integerValue];
        
        // 检查已打乱排序的种子中是否存在指定数字，
        BOOL isExist = NO;
        for (NSInteger j=0; j<_matrixDimension; j++) {
            if (number==[arrNumbOrdered[j] integerValue]) {
                isExist = YES;
                break;
            }
        }
        
        // 如果不存在相同的种子，则添加到错排种子列表中，并开始设置下一个种子；
        if (!isExist) {
            arrNumbOrdered[i]=@(number);
            i++;
        }
    }
    
    /**
     *  将随机固定的数字填入游戏容器中
     */
    for (NSInteger col=0; col<_matrixDimension; col++) {
        _arrResult[col] = arrNumbOrdered[col];
        _arrFix[col] = @(YES);
        [self translateResultToInputAtIndex:col];
    }
}

/**
 *  填充矩阵
 */
- (void)fillMatrix
{
    [self setAllPossible];
    NSInteger matrixSize = (NSInteger)powf(_matrixDimension, 2);
    if ([self isFixedAll]) {
        // 一次设置可能值就已经固定填充了矩阵那就直接打印矩阵出来呗；
        [self printAll];
    }
    else {
        for (NSInteger i=0; i<matrixSize; i++) {
            if (![_arrFix[i] boolValue]) {
                [_arrStack addObject:@(i)];
            }
        }
        
        // 回溯算法，填充矩阵
        if ([self backtrackingFill]) {
            [self printAll];
        }
        else {
            NSLog(@"题目有误");
        }
    }
}

/**
 *  回溯算法填充矩阵
 */
- (BOOL)backtrackingFill
{
    NSInteger maxWillFixedCount = _arrStack.count;
    NSInteger indexOfStack = 0;
    
    BOOL isNotReversing = YES;
    NSInteger temp = 0;
    while (YES) {
//        [NSThread sleepForTimeInterval:0.00001];
        if (isNotReversing) {
            // 表示向前
            NSInteger tryFixIndex = [_arrStack[indexOfStack] integerValue];
            for (NSInteger i=0; i<_matrixDimension; i++) {
                NSInteger tryPossibleNumber = [_arrArrPossible[tryFixIndex][i] integerValue];
                if (0!=tryPossibleNumber && ![self isExistByResultIndex:tryFixIndex value:tryPossibleNumber]) {
                    _arrResult[tryFixIndex] = @(tryPossibleNumber);
                    _arrFix[tryFixIndex] = @(YES);
                    [self translateResultToInputAtIndex:tryFixIndex];
                    indexOfStack++;
                    if (indexOfStack>=maxWillFixedCount) {
                        return YES;
                    }
                    break;
                }
            }
            
            if (![_arrFix[tryFixIndex] boolValue]) {
                indexOfStack--;
                if (indexOfStack<0) {
                    return NO;
                }
                isNotReversing = NO;
            }
        }
        else {
            // 表示正在逆向
            NSInteger tryFixIndex = [_arrStack[indexOfStack] integerValue];
            temp = ([_arrResult[tryFixIndex] integerValue]-_beginNumber)/_intervalsNumber;
            temp++;
            if(temp>=_matrixDimension)//当前节点没有更换的可能性，继续退回
            {
                _arrFix[tryFixIndex] = @(NO);
                _arrResult[tryFixIndex] = @(0);
                [self translateResultToInputAtIndex:tryFixIndex];
                --indexOfStack;
                if(indexOfStack<0) {
                    return NO;
                }
                continue;
            }
            
            NSInteger tryPossibleNumber = 0;
            while(0==(tryPossibleNumber=[_arrArrPossible[tryFixIndex][temp] integerValue]) || [self isExistByResultIndex:tryFixIndex value:tryPossibleNumber])
            {
                temp++;
                if(temp>=_matrixDimension)
                    break;
            }
            
            if(temp>=_matrixDimension)//当前节点没有更换的可能性，继续退回
            {
                _arrFix[tryFixIndex] = @(NO);
                _arrResult[tryFixIndex] = @(0);
                [self translateResultToInputAtIndex:tryFixIndex];
                --indexOfStack;
                if(indexOfStack<0) {
                    return NO;
                }
            }
            else
            {
                _arrFix[tryFixIndex] = @(YES);
                _arrResult[tryFixIndex] = @(tryPossibleNumber);
                [self translateResultToInputAtIndex:tryFixIndex];
                ++indexOfStack;
                isNotReversing = YES;//重新设定flag
            }
        }
    }
    
    return NO;
}

/**
 *  设置所有未确定坐标的可能值
 */
- (void)setAllPossible
{
    NSInteger matrixSize = (NSInteger)powf(_matrixDimension, 2);
    for (NSInteger i=0; i<matrixSize; i++) {
        for (NSInteger j=0; j<_matrixDimension; j++) {
            NSInteger number = [_arrSeedsNumber[j] integerValue];
            if (0!=[_arrResult[i] integerValue]) {
                //如果指定线性位置的的数字已经确定了，则将可能值设置为0，表示没有可能值；
                _arrArrPossible[i][j] = @(0);
            }
            else if ([self isExistByResultIndex:i value:number]) {
                // 如果指定线性位置上的数字在行、列、小矩阵中是否存在，存在可能值则为0
                _arrArrPossible[i][j] = @(0);
            }
            else {
                // 其他情况将可能值保存
                _arrArrPossible[i][j] = @(number);
            }
        }
    }
}

/**
 *  检查是否确定了所有坐标位置的数字，也就是说，所有坐标上的数字只有一个可能值；
 *
 *  @return return BOOL
 */
- (BOOL)isFixedAll
{
    BOOL flag = YES;
    // 所有位置的所有可能值的总数量
    NSInteger matrixSize = (NSInteger)powf(_matrixDimension, 2);
    NSInteger k[matrixSize];
    memset(k, 0, sizeof(k));
    
    for (NSInteger i=0; i<matrixSize; i++) {
        if (0!=[_arrResult[i] integerValue]) {
            // 不等于0，表示已经确定的位置
            _arrFix[i] = @(YES);
        }
        else {
            _arrFix[i] = @(NO);
        }
    }
    
    for (NSInteger i=0; i<matrixSize; i++) {
        BOOL isFixed = [_arrFix[i] boolValue];
        if (isFixed) continue;
        
        // 唯一的可能数字
        NSInteger onlyPossibleNumber = 0;
        
        for (NSInteger j=0; j<_matrixDimension; j++) {
            NSInteger possibleNumber = [_arrArrPossible[i][j] integerValue];
            if (0!=possibleNumber) {
                onlyPossibleNumber = possibleNumber;
                k[i]++;
            }
            
            if (k[i]>1 && flag) {
                flag = NO;
            }
        }
        
        if (1==k[i]) {
            _arrResult[i] = @(onlyPossibleNumber);
            _arrFix[i] = @(YES);
            [self translateResultToInputAtIndex:i];
        }
    }
    
    return flag;
}

/**
 *  检查是否填充了所有输入坐标
 *
 *  @return return BOOL
 */
- (BOOL)isFilledAll
{
    BOOL isFilled = YES;
    NSInteger matrixSize = (NSInteger)powf(_matrixDimension, 2);
    for (NSInteger i=0; i<matrixSize; i++) {
        NSInteger number = [_arrResult[i] integerValue];
        if (0==number) {
            isFilled = NO;
            break;
        }
    }
    return isFilled;
}

//输出函数
- (void)printAll
{
    NSInteger matrixSize = (NSInteger)powf(_matrixDimension, 2);
    for(NSInteger i=0; i<matrixSize; i++) {
        if(i%_matrixDimension==0)
            printf("\n\n\t\t");
        printf("%4ld", [_arrResult[i] integerValue]);
        
    }
    printf("\n\n\n");
}

@end
