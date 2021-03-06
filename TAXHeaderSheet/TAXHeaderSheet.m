//
//  TAXheaderSheet.m
//  InfusionTable
//
//  Created by 金井 慎一 on 2013/07/30.
//  Copyright (c) 2013年 Twelve Axis. All rights reserved.
//

#import "TAXHeaderSheet.h"
#import "TAXSpreadSheet.h"

@interface TAXHeaderSheet () <TAXSpreadSheetDataSource, TAXSpreadSheetDelegate>
{
    UIScrollView *_currentScrollingView;
}
@property (nonatomic) TAXSpreadSheet *containerSheet;
@property (nonatomic) NSMutableArray *sheetArray, *separatorArray, *classArray, *nibArray;
@end

@implementation TAXHeaderSheet

static NSString * const EmptyViewIdentifier = @"EmptyView";
static NSString * const CellIdentifier = @"Cell";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self p_setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self p_setup];
}

#pragma mark - Private methods

- (void)p_setup
{
    self.sheetArray = [NSMutableArray arrayWithCapacity:9];
    self.separatorArray = [NSMutableArray arrayWithCapacity:4];
    self.classArray = [NSMutableArray arrayWithCapacity:9];
    self.nibArray = [NSMutableArray arrayWithCapacity:9];
    
    // Make empty arrays.
    for (NSInteger idx = 0; idx < 9; idx ++) {
        _sheetArray[idx] = [NSNull null];
        _classArray[idx] = [NSMutableArray array];
        _nibArray[idx] = [NSMutableArray array];
    }
    
    for (NSInteger idx = 0; idx < 4; idx ++) {
        _separatorArray[idx] = [NSNull null];
    }
    
    TAXSpreadSheet *containerSheet = [[TAXSpreadSheet alloc] initWithFrame:self.bounds];
    containerSheet.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [containerSheet registerClass:[TAXSpreadSheet class] forCellWithReuseIdentifier:CellIdentifier];
    [containerSheet registerClass:[UICollectionReusableView class] forInterColumnViewWithReuseIdentifier:EmptyViewIdentifier];
    [containerSheet registerClass:[UICollectionReusableView class] forInterRowViewWithReuseIdentifier:EmptyViewIdentifier];

    containerSheet.scrollEnabled = NO;
    containerSheet.dataSource = self;
    containerSheet.delegate = self;
    containerSheet.backgroundColor = self.backgroundColor;
    
    self.containerSheet = containerSheet;
    [self addSubview:containerSheet];
    
    // Default Size    
    self.heightOfHeader = 100.0;
    self.heightOfFooter = 100.0;
    self.widthOfHeader = 100.0;
    self.widthOfFooter = 100.0;
    
    self.heightOfSeparatorTop = 0.0;
    self.heightOfSeparatorBottom = 0.0;
    self.widthOfSeparatorLeft = 0.0;
    self.widthOfSeparatorRight = 0.0;
    
    self.sizeForCell = CGSizeMake(50.0, 50.0);
    self.widthOfHeaderCell = 100.0;
    self.widthOfFooterCell = 100.0;
    self.heightOfHeaderCell = 50.0;
    self.heightOfFooterCell = 50.0;
}

- (TAXHeaderSheetSectionType)p_sectionTypeForColumn:(NSUInteger)column row:(NSUInteger)row
{
    switch (row) {
        case 0:{
            switch (column) {
                case 0:
                    return TAXHeaderSheetSectionTypeTopLeft;
                    break;
                case 1:
                    return TAXHeaderSheetSectionTypeTopMiddle;
                    break;
                case 2:
                    return TAXHeaderSheetSectionTypeTopRight;
                default:
                    break;
            }
        }
            break;
        case 1:{
            switch (column) {
                case 0:
                    return TAXHeaderSheetSectionTypeMiddleLeft;
                    break;
                case 1:
                    return TAXHeaderSheetSectionTypeBody;
                    break;
                case 2:
                    return TAXHeaderSheetSectionTypeMiddleRight;
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:{
            switch (column) {
                case 0:
                    return TAXHeaderSheetSectionTypeBottomLeft;
                    break;
                case 1:
                    return TAXHeaderSheetSectionTypeBottomMiddle;
                    break;
                case 2:
                    return TAXHeaderSheetSectionTypeBottomRight;
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return NSNotFound;
}

- (TAXHeaderSheetSectionType)p_sectionTypeForSpreadSheet:(TAXSpreadSheet*)spreadSheet
{
    NSIndexPath *indexPath = [_containerSheet indexPathForCell:spreadSheet];
    TAXHeaderSheetSectionType sectionType = [self p_sectionTypeForColumn:indexPath.item row:indexPath.section];
    return sectionType;
}

- (TAXSpreadSheet *)p_spreadSheetForSectionType:(TAXHeaderSheetSectionType)sectionType
{
    if ([_sheetArray[sectionType] isEqual:[NSNull null]]) {
        return nil;
    } else {
        return _sheetArray[sectionType];
    }
}

- (TAXHeaderSheetSectionType)p_sectionTypeForCollectionView:(UICollectionView *)collectionView
{
    TAXSpreadSheet *spreadSheet = (TAXSpreadSheet *)collectionView.superview;
    return [self p_sectionTypeForSpreadSheet:spreadSheet];
}

- (NSArray *)p_spreadSheetsOfHorizontalSectionType:(TAXHeaderSheetHorizontalSectionType)horizontalSectionType
{
    NSMutableArray *array = [NSMutableArray array];
    switch (horizontalSectionType) {
        case TAXHeaderSheetHorizontalSectionTypeTop:{
            if (self.heightOfHeader > 0) {
                if (self.widthOfHeader > 0) {
                    [array addObject:_sheetArray[TAXHeaderSheetSectionTypeTopLeft]];
                }
                [array addObject:_sheetArray[TAXHeaderSheetSectionTypeTopMiddle]];
                if (self.widthOfFooter > 0) {
                    [array addObject:_sheetArray[TAXHeaderSheetSectionTypeTopRight]];
                }
            }
            return array;
            break;
        }
        case TAXHeaderSheetHorizontalSectionTypeMiddle:{
            if (self.widthOfHeader > 0) {
                [array addObject:_sheetArray[TAXHeaderSheetSectionTypeMiddleLeft]];
            }
            [array addObject:_sheetArray[TAXHeaderSheetSectionTypeBody]];
            if (self.widthOfFooter > 0) {
                [array addObject:_sheetArray[TAXHeaderSheetSectionTypeMiddleRight]];
            }
            return array;
            break;
        }
        case TAXHeaderSheetHorizontalSectionTypeBottom:{
            if (self.heightOfFooter > 0) {
                if (self.widthOfHeader > 0) {
                    [array addObject:_sheetArray[TAXHeaderSheetSectionTypeBottomLeft]];
                }
                [array addObject:_sheetArray[TAXHeaderSheetSectionTypeBottomMiddle]];
                if (self.widthOfFooter > 0) {
                    [array addObject:_sheetArray[TAXHeaderSheetSectionTypeBottomRight]];
                }
            }
            return array;
            break;
        }
        default:
            return nil;
            break;
    }
}

- (NSArray *)p_spreadSheetsOfVerticalSectionType:(TAXHeaderSheetVerticalSectionType)verticalSectionType
{
    NSMutableArray *array = [NSMutableArray array];
    switch (verticalSectionType) {
        case TAXHeaderSheetVerticalSectionTypeLeft:{
            if (self.widthOfHeader > 0) {
                if (self.heightOfHeader > 0) {
                    [array addObject:_sheetArray[TAXHeaderSheetSectionTypeTopLeft]];
                }
                [array addObject:_sheetArray[TAXHeaderSheetSectionTypeMiddleLeft]];
                if (self.heightOfFooter > 0) {
                    [array addObject:_sheetArray[TAXHeaderSheetSectionTypeBottomLeft]];
                }
            }
            return array;
            break;
        }
        case TAXHeaderSheetVerticalSectionTypeMiddle:{
            if (self.heightOfHeader > 0) {
                [array addObject:_sheetArray[TAXHeaderSheetSectionTypeTopMiddle]];
            }
            [array addObject:_sheetArray[TAXHeaderSheetSectionTypeBody]];
            if (self.heightOfFooter > 0) {
                [array addObject:_sheetArray[TAXHeaderSheetSectionTypeBottomMiddle]];
            }
            return array;
            break;
        }
        case TAXHeaderSheetVerticalSectionTypeRight:{
            if (self.heightOfHeader > 0) {
                [array addObject:_sheetArray[TAXHeaderSheetSectionTypeTopRight]];
            }
            [array addObject:_sheetArray[TAXHeaderSheetSectionTypeMiddleRight]];
            if (self.widthOfFooter > 0) {
                [array addObject:_sheetArray[TAXHeaderSheetSectionTypeBottomRight]];
            }
            return array;
            break;

        }
        default:
            return nil;
            break;
    }
}

#pragma mark - Returning each section/separator as UIView

- (UIView *)viewForSectionType:(TAXHeaderSheetSectionType)sectionType
{
    return (UIView*)[self p_spreadSheetForSectionType:sectionType];
}

- (UIView *)viewForSeparatorType:(TAXHeaderSheetSeparatorType)separatorType
{
    if ([_separatorArray[separatorType] isEqual:[NSNull null]]) {
        return nil;
    } else {
        return (UIView *)_separatorArray[separatorType];
    }
}

# pragma mark - Reload Data

- (void)reloadData
{
    [_sheetArray enumerateObjectsUsingBlock:^(TAXSpreadSheet *spreadSheet, NSUInteger idx, BOOL *stop) {
        if ([spreadSheet respondsToSelector:@selector(reloadData)]) {
            [spreadSheet reloadData];
        }
    }];
    [_containerSheet invalidateLayout];
}

- (void)reloadDataOfSectionType:(TAXHeaderSheetSectionType)sectionType
{
    TAXSpreadSheet *spreadSheet = [self p_spreadSheetForSectionType:sectionType];
    [spreadSheet reloadData];
}

- (void)reloadDataOfHorizontalSectionType:(TAXHeaderSheetHorizontalSectionType)horizontalSectionType
{
    NSArray *array = [self p_spreadSheetsOfHorizontalSectionType:horizontalSectionType];
    [array enumerateObjectsUsingBlock:^(TAXSpreadSheet *spreadSheet, NSUInteger idx, BOOL *stop) {
        if ([spreadSheet respondsToSelector:@selector(reloadData)]) {
            [spreadSheet reloadData];
        }
    }];
}

- (void)reloadDataOfVerticalSectionType:(TAXHeaderSheetVerticalSectionType)verticalSectionType
{
    NSArray *array = [self p_spreadSheetsOfVerticalSectionType:verticalSectionType];
    [array enumerateObjectsUsingBlock:^(TAXSpreadSheet *spreadSheet, NSUInteger idx, BOOL *stop) {
        if ([spreadSheet respondsToSelector:@selector(reloadData)]) {
            [spreadSheet reloadData];
        }
    }];
}

# pragma mark - Invalidate Layout

- (void)invalidateLayoutOfSectionType:(TAXHeaderSheetSectionType)sectionType
{
    TAXSpreadSheet *spreadSheet = [self p_spreadSheetForSectionType:sectionType];
    [spreadSheet invalidateLayout];
}

# pragma mark - Background Color/View of Section

- (void)setBackgroundColorInAllSection:(UIColor *)backgroundColor
{
    [_sheetArray enumerateObjectsUsingBlock:^(TAXSpreadSheet *spreadSheet, NSUInteger idx, BOOL *stop) {
        if ([spreadSheet respondsToSelector:@selector(setBackgroundColor:)]) {
            spreadSheet.backgroundColor = backgroundColor;
        }
    }];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor inSectionType:(TAXHeaderSheetSectionType)sectionType
{
    TAXSpreadSheet *spreadSheet = [self p_spreadSheetForSectionType:sectionType];
    if ([spreadSheet respondsToSelector:@selector(setBackgroundColor:)]) {
        spreadSheet.backgroundColor = backgroundColor;
    }
}

- (void)setBackgroundView:(UIView *)backgroundView inSectionType:(TAXHeaderSheetSectionType)sectionType
{
    TAXSpreadSheet *spreadSheet = [self p_spreadSheetForSectionType:sectionType];
    if ([spreadSheet respondsToSelector:@selector(setBackgroundView:)]) {
        spreadSheet.backgroundView = backgroundView;
    }
}

# pragma mark - Inserting, Moving, and Deleting Rows/Columns

// Inserting, moving, and deleting rows.

- (void)insertRowsAtIndexPaths:(NSIndexSet *)indexPaths inHorizontalSectionType:(TAXHeaderSheetHorizontalSectionType)horizontalSectionType
{
    [[self p_spreadSheetsOfHorizontalSectionType:horizontalSectionType] enumerateObjectsUsingBlock:^(TAXSpreadSheet *spreadSheet, NSUInteger idx, BOOL *stop) {
        [spreadSheet insertRows:indexPaths];
    }];
}

- (void)moveRow:(NSInteger)fromRow toRow:(NSInteger)toRow inHorizontalSectionType:(TAXHeaderSheetHorizontalSectionType)horizontalSectionType
{
    [[self p_spreadSheetsOfHorizontalSectionType:horizontalSectionType] enumerateObjectsUsingBlock:^(TAXSpreadSheet *spreadSheet, NSUInteger idx, BOOL *stop) {
        [spreadSheet moveRow:fromRow toRow:toRow];
    }];
}

- (void)deleteRowsAtIndexPaths:(NSIndexSet *)indexPaths inHorizontalSectionType:(TAXHeaderSheetHorizontalSectionType)horizontalSectionType
{
    [[self p_spreadSheetsOfHorizontalSectionType:horizontalSectionType] enumerateObjectsUsingBlock:^(TAXSpreadSheet *spreadSheet, NSUInteger idx, BOOL *stop) {
        [spreadSheet deleteRows:indexPaths];
    }];
}

// Inserting, moving, and deleting columns.

- (void)insertColumnsAtIndexPaths:(NSIndexSet *)indexPaths inVerticalSectionType:(TAXHeaderSheetVerticalSectionType)verticalSectionType
{
    [[self p_spreadSheetsOfVerticalSectionType:verticalSectionType] enumerateObjectsUsingBlock:^(TAXSpreadSheet *spreadSheet, NSUInteger idx, BOOL *stop) {
        [spreadSheet insertColumns:indexPaths];
    }];
}

- (void)moveColumn:(NSInteger)fromColumn toColumn:(NSInteger)toColumn inVerticalSectionType:(TAXHeaderSheetVerticalSectionType)verticalSectionType
{
    [[self p_spreadSheetsOfVerticalSectionType:verticalSectionType] enumerateObjectsUsingBlock:^(TAXSpreadSheet *spreadSheet, NSUInteger idx, BOOL *stop) {
        [spreadSheet moveColumn:fromColumn toColumn:toColumn];
    }];
}

- (void)deleteColumnsAtIndexPaths:(NSIndexSet *)indexPaths inVerticalSectionType:(TAXHeaderSheetVerticalSectionType)verticalSectionType
{
    [[self p_spreadSheetsOfVerticalSectionType:verticalSectionType] enumerateObjectsUsingBlock:^(TAXSpreadSheet *spreadSheet, NSUInteger idx, BOOL *stop) {
        [spreadSheet deleteColumns:indexPaths];
    }];
}

# pragma mark - Deprecated Methods

- (NSArray *)p_spreadSheetsSameRowAsSectionType:(TAXHeaderSheetSectionType)sectionType
{
    switch (sectionType) {
        case TAXHeaderSheetSectionTypeTopLeft:
        case TAXHeaderSheetSectionTypeTopMiddle:
        case TAXHeaderSheetSectionTypeTopRight:
            return @[[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopLeft],
                     [self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopMiddle],
                     [self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopRight]];
            break;
        case TAXHeaderSheetSectionTypeMiddleLeft:
        case TAXHeaderSheetSectionTypeBody:
        case TAXHeaderSheetSectionTypeMiddleRight:
            return @[[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeMiddleLeft],
                     [self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBody],
                     [self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeMiddleRight]];
            break;
        case TAXHeaderSheetSectionTypeBottomLeft:
        case TAXHeaderSheetSectionTypeBottomMiddle:
        case TAXHeaderSheetSectionTypeBottomRight:
            return @[[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomLeft],
                     [self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomMiddle],
                     [self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomRight]];
            break;
        default:
            return nil;
            break;
    }
}

- (NSArray *)p_spreadSheetsSameColumnAsSectionType:(TAXHeaderSheetSectionType)sectionType
{
    switch (sectionType) {
        case TAXHeaderSheetSectionTypeTopLeft:
        case TAXHeaderSheetSectionTypeMiddleLeft:
        case TAXHeaderSheetSectionTypeBottomLeft:
            return @[[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopLeft],
                     [self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeMiddleLeft],
                     [self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomLeft]];
            break;
        case TAXHeaderSheetSectionTypeTopMiddle:
        case TAXHeaderSheetSectionTypeBody:
        case TAXHeaderSheetSectionTypeBottomMiddle:
            return @[[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopMiddle],
                     [self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBody],
                     [self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomMiddle]];
            break;
        case TAXHeaderSheetSectionTypeTopRight:
        case TAXHeaderSheetSectionTypeMiddleRight:
        case TAXHeaderSheetSectionTypeBottomRight:
            return @[[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopRight],
                     [self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeMiddleRight],
                     [self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomRight]];
            break;
        default:
            return nil;
            break;
    }
}

- (void)insertRowsAtIndexPaths:(NSIndexSet *)indexPaths inSectionType:(TAXHeaderSheetSectionType)sectionType
{
    for (TAXSpreadSheet *spreadSheet in [self p_spreadSheetsSameRowAsSectionType:sectionType]) {
        [spreadSheet insertRows:indexPaths];
    }
}

- (void)moveRow:(NSInteger)fromRow toRow:(NSInteger)toRow inSectionType:(TAXHeaderSheetSectionType)sectionType
{
    for (TAXSpreadSheet *spreadSheet in [self p_spreadSheetsSameRowAsSectionType:sectionType]) {
        [spreadSheet moveRow:fromRow toRow:toRow];
    }
}

- (void)deleteRowsAtIndexPaths:(NSIndexSet *)indexPaths inSectionType:(TAXHeaderSheetSectionType)sectionType
{
    for (TAXSpreadSheet *spreadSheet in [self p_spreadSheetsSameRowAsSectionType:sectionType]) {
        [spreadSheet deleteRows:indexPaths];
    }
}

- (void)insertColumnsAtIndexPaths:(NSIndexSet *)indexPaths inSectionType:(TAXHeaderSheetSectionType)sectionType
{
    for (TAXSpreadSheet *spreadSheet in [self p_spreadSheetsSameColumnAsSectionType:sectionType]) {
        [spreadSheet insertColumns:indexPaths];
    }
}

- (void)moveColumn:(NSInteger)fromColumn toColumn:(NSInteger)toColumn inSectionType:(TAXHeaderSheetSectionType)sectionType
{
    for (TAXSpreadSheet *spreadSheet in [self p_spreadSheetsSameColumnAsSectionType:sectionType]) {
        [spreadSheet moveColumn:fromColumn toColumn:toColumn];
    }
}

- (void)deleteColumnsAtIndexPaths:(NSIndexSet *)indexPaths inSectionType:(TAXHeaderSheetSectionType)sectionType
{
    for (TAXSpreadSheet *spreadSheet in [self p_spreadSheetsSameColumnAsSectionType:sectionType]) {
        [spreadSheet deleteColumns:indexPaths];
    }
}

# pragma mark - SpreadSheet DataSource

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (NSUInteger)numberOfRowsInSpreadSheet:(TAXSpreadSheet *)spreadSheet
{
    if (spreadSheet == _containerSheet) {
        return 3;
    } else {
        NSIndexPath *indexPath = [_containerSheet indexPathForCell:spreadSheet];
        NSUInteger row = indexPath.section;
        switch (row) {
            case 0:{
                NSInteger rowsOfTop = [_dataSource headerSheet:self numberOfRowsInHorizontalSectionType:TAXHeaderSheetHorizontalSectionTypeTop];
                if (rowsOfTop != NSNotFound) {
                    return rowsOfTop;
                } else return _numberOfRowsOfHeader;
                break;
            }
            case 1:{
                NSInteger rowsOfMiddle = [_dataSource headerSheet:self numberOfRowsInHorizontalSectionType:TAXHeaderSheetHorizontalSectionTypeMiddle];
                if (rowsOfMiddle != NSNotFound) {
                    return rowsOfMiddle;
                } else return _numberOfRowsOfBody;
                break;
            }
            case 2:{
                NSInteger rowsOfBottom = [_dataSource headerSheet:self numberOfRowsInHorizontalSectionType:TAXHeaderSheetHorizontalSectionTypeBottom];
                if (rowsOfBottom != NSNotFound) {
                    return rowsOfBottom;
                } else return _numberOfRowsOfFooter;
                break;
            }
            default:
                return 0;
                break;
        }
    }
}
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (NSUInteger)numberOfColumnsInSpreadSheet:(TAXSpreadSheet *)spreadSheet
{
    if (spreadSheet == _containerSheet) {
        return 3;
    } else {
        NSIndexPath *indexPath = [_containerSheet indexPathForCell:spreadSheet];
        NSUInteger column = indexPath.item;
        switch (column) {
            case 0:{
                NSInteger columnsOfLeft = [_dataSource headerSheet:self numberOfColumnsInVerticalSectionType:TAXHeaderSheetVerticalSectionTypeLeft];
                if (columnsOfLeft != NSNotFound) {
                    return columnsOfLeft;
                } else return _numberOfColumnsOfHeader;
                break;
            }
            case 1:{
                NSInteger columnsOfMiddle = [_dataSource headerSheet:self numberOfColumnsInVerticalSectionType:TAXHeaderSheetVerticalSectionTypeMiddle];
                if (columnsOfMiddle != NSNotFound) {
                    return columnsOfMiddle;
                } else return _numberOfColumnsOfBody;
                break;
            }
            case 2:{
                NSInteger columnsOfRight = [_dataSource headerSheet:self numberOfColumnsInVerticalSectionType:TAXHeaderSheetVerticalSectionTypeRight];
                if (columnsOfRight != NSNotFound) {
                    return columnsOfRight;
                } else return _numberOfColumnsOfFooter;
                break;
            }
            default:
                return 0;
                break;
        }
    }
}
#pragma clang diagnostic pop

- (UICollectionViewCell*)spreadSheet:(TAXSpreadSheet *)spreadSheet cellAtRow:(NSUInteger)row column:(NSUInteger)column
{
    if (spreadSheet == _containerSheet) {
        // Return spreadsheet of section
        
        TAXHeaderSheetSectionType sectionType = [self p_sectionTypeForColumn:column row:row];
        TAXSpreadSheet *spreadSheet = [_containerSheet dequeueReusableCellWithReuseIdentifier:CellIdentifier forRow:row column:column];
        
        if ([_sheetArray[sectionType] isEqual:[NSNull null]]) {
            _sheetArray[sectionType] = spreadSheet;
            
            [spreadSheet registerClass:[UICollectionReusableView class] forInterColumnViewWithReuseIdentifier:EmptyViewIdentifier];
            [spreadSheet registerClass:[UICollectionReusableView class] forInterRowViewWithReuseIdentifier:EmptyViewIdentifier];
            
            // Register class/nib by referring to array.
            for (NSDictionary *dict in _classArray[sectionType]) {
                for (NSString *identifier in [dict allKeys]) {
                    [spreadSheet registerClass:dict[identifier] forCellWithReuseIdentifier:identifier];
                }
            }

            for (NSDictionary *dict in _nibArray[sectionType]) {
                for (NSString *identifier in [dict allKeys]) {
                    [spreadSheet registerNib:dict[identifier] forCellWithReuseIdentifier:identifier];
                }
            }

            spreadSheet.dataSource = self;
            spreadSheet.delegate = self;
            if (sectionType != TAXHeaderSheetSectionTypeBody) {
                spreadSheet.showsHorizontalScrollIndicator = NO;
                spreadSheet.showsVerticalScrollIndicator = NO;
//                spreadSheet.scrollEnabled = NO;
            }
        }
        return spreadSheet;
    } else {
        TAXHeaderSheetSectionType sectionType = [self p_sectionTypeForSpreadSheet:spreadSheet];
        return [self.dataSource headerSheet:self cellAtRow:row column:column inSectionType:sectionType];
    }
}

- (UICollectionReusableView *)spreadSheet:(TAXSpreadSheet *)spreadSheet interColumnViewAfterColumn:(NSUInteger)column
{
    if ([spreadSheet isEqual:_containerSheet]) {
        if ([self.delegate respondsToSelector:@selector(headerSheet:separatorViewOfSeparatorType:)]) {
            TAXHeaderSheetSeparatorType separatorType;
            switch (column) {
                case 0:
                    separatorType = TAXHeaderSheetSeparatorTypeLeft;
                    break;
                case 1:
                default:
                    separatorType = TAXHeaderSheetSeparatorTypeRight;
                    break;
            }
            UICollectionReusableView *separatorView = [self.delegate headerSheet:self separatorViewOfSeparatorType:separatorType];
            if (separatorView) {
                _separatorArray[separatorType] = separatorView;
            }
            return separatorView;
        };
    } else {
        if ([self.dataSource respondsToSelector:@selector(headerSheet:interColumnViewInSectionType:afterColumn:)]) {
            TAXHeaderSheetSectionType sectionType = [self p_sectionTypeForSpreadSheet:spreadSheet];
            return [self.delegate headerSheet:self interColumnViewInSectionType:sectionType afterColumn:column];
        };
    }
    return [spreadSheet dequeueReusableInterColumnViewWithIdentifier:EmptyViewIdentifier afterColumn:column];
}

- (UICollectionReusableView *)spreadSheet:(TAXSpreadSheet *)spreadSheet interRowViewBelowRow:(NSUInteger)row
{
    if ([spreadSheet isEqual:_containerSheet]) {
        if ([self.delegate respondsToSelector:@selector(headerSheet:separatorViewOfSeparatorType:)]) {
            TAXHeaderSheetSeparatorType separatorType = TAXHeaderSheetSeparatorTypeTop;
            switch (row) {
                case 0:
                    separatorType = TAXHeaderSheetSeparatorTypeTop;
                    break;
                case 1:
                    separatorType = TAXHeaderSheetSeparatorTypeBottom;
                    break;
                default:
                    break;
            }
            UICollectionReusableView *separatorView = [self.delegate headerSheet:self separatorViewOfSeparatorType:separatorType];
            if (separatorView) {
                _separatorArray[separatorType] = separatorView;
            }
            return separatorView;
        };
    } else {
        if ([self.dataSource respondsToSelector:@selector(headerSheet:interRowViewInSectionType:belowRow:)]) {
            TAXHeaderSheetSectionType sectionType = [self p_sectionTypeForSpreadSheet:spreadSheet];
            return [self.delegate headerSheet:self interRowViewInSectionType:sectionType belowRow:row];
        };
    }
    return [spreadSheet dequeueReusableInterRowViewWithIdentifier:EmptyViewIdentifier belowRow:row];
}

- (CGFloat)spreadSheet:(TAXSpreadSheet *)spreadSheet bottomSpacingBelowRow:(NSUInteger)row
{
    if (spreadSheet == _containerSheet) {
        if (row == 0) {
            return _heightOfSeparatorTop;
        } else {
            return _heightOfSeparatorBottom;
        }
    } else if ([_delegate respondsToSelector:@selector(headerSheet:bottomSpacingBelowRow:inSectionType:)]) {
        TAXHeaderSheetSectionType sectionType = [self p_sectionTypeForSpreadSheet:spreadSheet];
        return [_delegate headerSheet:self bottomSpacingBelowRow:row inSectionType:sectionType];
    } else return 0.0;
}

- (CGFloat)spreadSheet:(TAXSpreadSheet *)spreadSheet trailingSpacingAfterColumn:(NSUInteger)column
{
    if (spreadSheet == _containerSheet) {
        if (column == 0) {
            return _widthOfSeparatorLeft;
        } else {
            return _widthOfSeparatorRight;
        }
    } else if ([_delegate respondsToSelector:@selector(headerSheet:trailingSpacingAfterColumn:inSectionType:)]) {
        TAXHeaderSheetSectionType sectionType = [self p_sectionTypeForSpreadSheet:spreadSheet];
        return [_delegate headerSheet:self trailingSpacingAfterColumn:column inSectionType:sectionType];
    } else return 0.0;
}

# pragma mark - SpreadSheet Delegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (CGFloat)spreadSheet:(TAXSpreadSheet *)spreadSheet widthAtColumn:(NSUInteger)column
{
    if ([spreadSheet isEqual:_containerSheet]) {
        if (column == 0) {
            return _widthOfHeader;
        } else if (column == 1) {
            return self.bounds.size.width - _widthOfHeader - _widthOfFooter - _widthOfSeparatorLeft - _widthOfSeparatorRight;
        } else {
            return _widthOfFooter;
        }
    } else {
        TAXHeaderSheetSectionType sectionType = [self p_sectionTypeForSpreadSheet:spreadSheet];
        if ([self.delegate respondsToSelector:@selector(headerSheet:widthAtColumn:ofVerticalSectionType:)] ||
            [_delegate respondsToSelector:@selector(headerSheet:widthAtColumn:ofSectionType:)]) {
            switch (sectionType) {
                    case TAXHeaderSheetSectionTypeTopLeft:
                    case TAXHeaderSheetSectionTypeMiddleLeft:
                    case TAXHeaderSheetSectionTypeBottomLeft:{
                        CGFloat leftWidth = [self.delegate headerSheet:self widthAtColumn:column ofVerticalSectionType:TAXHeaderSheetVerticalSectionTypeLeft];
                        if (leftWidth != NSNotFound) {
                            return leftWidth;
                        } else {
                            CGFloat topLeft = [_delegate headerSheet:self widthAtColumn:column ofSectionType:TAXHeaderSheetSectionTypeTopLeft];
                            CGFloat middleLeft = [_delegate headerSheet:self widthAtColumn:column ofSectionType:TAXHeaderSheetSectionTypeMiddleLeft];
                            CGFloat bottomLeft = [_delegate headerSheet:self widthAtColumn:column ofSectionType:TAXHeaderSheetSectionTypeBottomLeft];
                            if (topLeft != NSNotFound) {
                                return topLeft;
                            } else if (bottomLeft != NSNotFound) {
                                return bottomLeft;
                            } else if (middleLeft != NSNotFound) {
                                return middleLeft;
                            }
                        }
                        return _widthOfHeaderCell;
                    }
                    case TAXHeaderSheetSectionTypeTopMiddle:
                    case TAXHeaderSheetSectionTypeBody:
                    case TAXHeaderSheetSectionTypeBottomMiddle:{
                        CGFloat middleWidth = [self.delegate headerSheet:self widthAtColumn:column ofVerticalSectionType:TAXHeaderSheetVerticalSectionTypeMiddle];
                        if (middleWidth != NSNotFound) {
                            return middleWidth;
                        } else {
                            CGFloat topMiddle = [_delegate headerSheet:self widthAtColumn:column ofSectionType:TAXHeaderSheetSectionTypeTopMiddle];
                            CGFloat body = [_delegate headerSheet:self widthAtColumn:column ofSectionType:TAXHeaderSheetSectionTypeBody];
                            CGFloat bottomMiddle = [_delegate headerSheet:self widthAtColumn:column ofSectionType:TAXHeaderSheetSectionTypeBottomMiddle];
                            if (topMiddle != NSNotFound) {
                                return topMiddle;
                            } else if (bottomMiddle != NSNotFound) {
                                return bottomMiddle;
                            } else if (body != NSNotFound) {
                                return body;
                            }
                        }
                        return _sizeForCell.width;
                    }
                    case TAXHeaderSheetSectionTypeTopRight:
                    case TAXHeaderSheetSectionTypeMiddleRight:
                    case TAXHeaderSheetSectionTypeBottomRight:{
                        CGFloat rightWidth = [self.delegate headerSheet:self widthAtColumn:column ofVerticalSectionType:TAXHeaderSheetVerticalSectionTypeRight];
                        if (rightWidth != NSNotFound) {
                            return rightWidth;
                        } else {
                            CGFloat topRight = [_delegate headerSheet:self widthAtColumn:column ofSectionType:TAXHeaderSheetSectionTypeTopRight];
                            CGFloat middleRight = [_delegate headerSheet:self widthAtColumn:column ofSectionType:TAXHeaderSheetSectionTypeMiddleRight];
                            CGFloat bottomRight = [_delegate headerSheet:self widthAtColumn:column ofSectionType:TAXHeaderSheetSectionTypeBottomRight];
                            if (topRight != NSNotFound) {
                                return topRight;
                            } else if (bottomRight != NSNotFound) {
                                return bottomRight;
                            } else if (middleRight != NSNotFound) {
                                return middleRight;
                            }
                        }
                        return _widthOfFooterCell;
                    }
                default:
                    break;
            }
        } else {
            if (sectionType == TAXHeaderSheetSectionTypeTopLeft ||
                sectionType == TAXHeaderSheetSectionTypeMiddleLeft ||
                sectionType == TAXHeaderSheetSectionTypeBottomLeft) {
                return self.widthOfHeaderCell;
            } else if (sectionType == TAXHeaderSheetSectionTypeTopMiddle ||
                       sectionType == TAXHeaderSheetSectionTypeBody ||
                       sectionType == TAXHeaderSheetSectionTypeBottomMiddle) {
                return self.sizeForCell.width;
            } else {
                return self.widthOfFooterCell;
            }
        }
    }
}
#pragma clang diagnostic ppo

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (CGFloat)spreadSheet:(TAXSpreadSheet *)spreadSheet heightAtRow:(NSUInteger)row
{
    if ([spreadSheet isEqual:_containerSheet]) {
        if (row == 0) {
            return self.heightOfHeader;
        } else if (row == 1) {
            return self.bounds.size.height - self.heightOfHeader - self.heightOfFooter - self.heightOfSeparatorTop - self.heightOfSeparatorBottom;
        } else {
            return self.heightOfFooter;
        }
    } else {
        // Return height with priority (Left > Right > Middle > Property)
        TAXHeaderSheetSectionType sectionType = [self p_sectionTypeForSpreadSheet:spreadSheet];
        if ([self.delegate respondsToSelector:@selector(headerSheet:heightAtRow:ofHorizontalSectionType:)] ||
            [_delegate respondsToSelector:@selector(headerSheet:heightAtRow:ofSectionType:)]) {
            switch (sectionType) {
                    case TAXHeaderSheetSectionTypeTopLeft:
                    case TAXHeaderSheetSectionTypeTopMiddle:
                    case TAXHeaderSheetSectionTypeTopRight:{
                        CGFloat topHeight = [_delegate headerSheet:self heightAtRow:row ofHorizontalSectionType:TAXHeaderSheetHorizontalSectionTypeTop];
                        if (topHeight != NSNotFound) {
                            return topHeight;
                        } else {
                            CGFloat topLeft = [_delegate headerSheet:self heightAtRow:row ofSectionType:TAXHeaderSheetSectionTypeTopLeft];
                            CGFloat topMiddle = [_delegate headerSheet:self heightAtRow:row ofSectionType:TAXHeaderSheetSectionTypeTopMiddle];
                            CGFloat topRight = [_delegate headerSheet:self heightAtRow:row ofSectionType:TAXHeaderSheetSectionTypeTopRight];
                            if (topLeft != NSNotFound) {
                                return topLeft;
                            } else if (topMiddle != NSNotFound) {
                                return topMiddle;
                            } else if (topRight != NSNotFound) {
                                return topRight;
                            }
                        }
                        return _heightOfHeaderCell;
                    }
                    case TAXHeaderSheetSectionTypeMiddleLeft:
                    case TAXHeaderSheetSectionTypeBody:
                    case TAXHeaderSheetSectionTypeMiddleRight:{
                        CGFloat middleHeight = [_delegate headerSheet:self heightAtRow:row ofHorizontalSectionType:TAXHeaderSheetHorizontalSectionTypeMiddle];
                        if (middleHeight != NSNotFound) {
                            return middleHeight;
                        } else {
                            CGFloat middleLeft = [_delegate headerSheet:self heightAtRow:row ofSectionType:TAXHeaderSheetSectionTypeMiddleLeft];
                            CGFloat body = [_delegate headerSheet:self heightAtRow:row ofSectionType:TAXHeaderSheetSectionTypeBody];
                            CGFloat middleRight = [_delegate headerSheet:self heightAtRow:row ofSectionType:TAXHeaderSheetSectionTypeMiddleRight];
                            if (middleLeft != NSNotFound) {
                                return middleLeft;
                            } else if (body != NSNotFound) {
                                return body;
                            } else if (middleRight != NSNotFound) {
                                return middleRight;
                            }
                        }
                        return _sizeForCell.height;
                    }
                    case TAXHeaderSheetSectionTypeBottomLeft:
                    case TAXHeaderSheetSectionTypeBottomMiddle:
                    case TAXHeaderSheetSectionTypeBottomRight:{
                        CGFloat bottomHight = [_delegate headerSheet:self heightAtRow:row ofHorizontalSectionType:TAXHeaderSheetHorizontalSectionTypeBottom];
                        if (bottomHight != NSNotFound) {
                            return bottomHight;
                        } else {
                            CGFloat bottomLeft = [_delegate headerSheet:self heightAtRow:row ofSectionType:TAXHeaderSheetSectionTypeBottomLeft];
                            CGFloat bottomMiddle = [_delegate headerSheet:self heightAtRow:row ofSectionType:TAXHeaderSheetSectionTypeBottomMiddle];
                            CGFloat bottomRight = [_delegate headerSheet:self heightAtRow:row ofSectionType:TAXHeaderSheetSectionTypeBottomRight];
                            if (bottomLeft != NSNotFound) {
                                return bottomLeft;
                            } else if (bottomMiddle != NSNotFound) {
                                return bottomMiddle;
                            } else if (bottomRight != NSNotFound) {
                                return bottomRight;
                            }
                        }
                        return _heightOfFooterCell;
                    }
                default:
                    break;
            }
        } else {
            if (sectionType == TAXHeaderSheetSectionTypeTopLeft ||
                sectionType == TAXHeaderSheetSectionTypeTopMiddle ||
                sectionType == TAXHeaderSheetSectionTypeTopRight) {
                return _heightOfHeaderCell;
            } else if (sectionType == TAXHeaderSheetSectionTypeMiddleLeft ||
                       sectionType == TAXHeaderSheetSectionTypeBody ||
                       sectionType == TAXHeaderSheetSectionTypeMiddleRight) {
                return _sizeForCell.height;
            } else {
                return _heightOfFooterCell;
            }
        }
    }
}
#pragma clang diagnostic pop

# pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != _currentScrollingView) {
        return;
    }
    
    TAXHeaderSheetSectionType sectionType = [self p_sectionTypeForCollectionView:(UICollectionView *)scrollView];

    CGPoint scrollingOffset = scrollView.contentOffset;
    switch (sectionType) {
        case TAXHeaderSheetSectionTypeBody: {
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopMiddle] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomMiddle] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeMiddleLeft] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeMiddleRight] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            break;
        }
        case TAXHeaderSheetSectionTypeTopLeft: {
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeMiddleLeft] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomLeft] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopMiddle] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopRight] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            break;
        }
        case TAXHeaderSheetSectionTypeTopMiddle: {
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBody] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomMiddle] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopLeft] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopRight] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            break;
        }
        case TAXHeaderSheetSectionTypeMiddleLeft: {
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopLeft] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomLeft] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBody] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeMiddleRight] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            break;
        }
        case TAXHeaderSheetSectionTypeMiddleRight: {
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopRight] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomRight] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeMiddleLeft] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBody] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            break;
        }
        case TAXHeaderSheetSectionTypeBottomLeft: {
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopLeft] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeMiddleLeft] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomMiddle] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomRight] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            break;
        }
        case TAXHeaderSheetSectionTypeBottomMiddle: {
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopMiddle] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBody] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomLeft] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomRight] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            break;
        }
        case TAXHeaderSheetSectionTypeBottomRight: {
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopRight] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeMiddleRight] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomLeft] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomMiddle] setContentOffset:CGPointMake(0, scrollingOffset.y)];
            break;
        }
        default:
            break;
    }
    /*
    if (sectionType == TAXHeaderSheetSectionTypeBody) {
        CGPoint scrollingOffset = scrollView.contentOffset;
        [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeTopMiddle] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
        [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeBottomMiddle] setContentOffset:CGPointMake(scrollingOffset.x, 0)];
        [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeMiddleLeft] setContentOffset:CGPointMake(0, scrollingOffset.y)];
        [[self p_spreadSheetForSectionType:TAXHeaderSheetSectionTypeMiddleRight] setContentOffset:CGPointMake(0, scrollingOffset.y)];
    }
     */
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollView.exclusiveTouch = YES;
    _currentScrollingView = scrollView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _currentScrollingView) {
        scrollView.exclusiveTouch = NO;
        _currentScrollingView = nil;
    }
}

# pragma mark - Fowarding UICollectionView Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(headerSheet:shouldHighlightItemAtIndexPath:inSectionType:)]) {
        return [_delegate headerSheet:self shouldHighlightItemAtIndexPath:indexPath inSectionType:[self p_sectionTypeForCollectionView:collectionView]];
    } else return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(headerSheet:didHighlightItemAtIndexPath:inSectionType:)]) {
        [_delegate headerSheet:self didHighlightItemAtIndexPath:indexPath inSectionType:[self p_sectionTypeForCollectionView:collectionView]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(headerSheet:didUnhighlightItemAtIndexPath:inSectionType:)]) {
        [_delegate headerSheet:self didUnhighlightItemAtIndexPath:indexPath inSectionType:[self p_sectionTypeForCollectionView:collectionView]];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(headerSheet:shouldSelectItemAtIndexPath:inSectionType:)]) {
        return [_delegate headerSheet:self shouldSelectItemAtIndexPath:indexPath inSectionType:[self p_sectionTypeForCollectionView:collectionView]];
    } else return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(headerSheet:shouldDeselectItemAtIndexPath:inSectionType:)]) {
        return [_delegate headerSheet:self shouldDeselectItemAtIndexPath:indexPath inSectionType:[self p_sectionTypeForCollectionView:collectionView]];
    } else return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(headerSheet:didSelectItemAtIndexPath:inSectionType:)]) {
        [_delegate headerSheet:self didSelectItemAtIndexPath:indexPath inSectionType:[self p_sectionTypeForCollectionView:collectionView]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(headerSheet:didDeselectItemAtIndexPath:inSectionType:)]) {
        [_delegate headerSheet:self didDeselectItemAtIndexPath:indexPath inSectionType:[self p_sectionTypeForCollectionView:collectionView]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(headerSheet:didEndDisplayingCell:forItemAtIndexPath:inSectionType:)]) {
        [_delegate headerSheet:self didEndDisplayingCell:cell forItemAtIndexPath:indexPath inSectionType:[self p_sectionTypeForCollectionView:collectionView]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(headerSheet:didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:inSectionType:)]) {
        [_delegate headerSheet:self didEndDisplayingSupplementaryView:view forElementOfKind:elementKind atIndexPath:indexPath inSectionType:[self p_sectionTypeForCollectionView:collectionView]];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(headerSheet:shouldShowMenuForItemAtIndexPath:inSectionType:)]) {
        return [_delegate headerSheet:self shouldShowMenuForItemAtIndexPath:indexPath inSectionType:[self p_sectionTypeForCollectionView:collectionView]];
    } else return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([_delegate respondsToSelector:@selector(headerSheet:canPerformAction:forItemAtIndexPath:inSectionType:withSender:)]) {
        return [_delegate headerSheet:self canPerformAction:action forItemAtIndexPath:indexPath inSectionType:[self p_sectionTypeForCollectionView:collectionView] withSender:sender];
    } else return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([_delegate respondsToSelector:@selector(headerSheet:performAction:forItemAtIndexPath:inSectionType:withSender:)]) {
        [_delegate headerSheet:self performAction:action forItemAtIndexPath:indexPath inSectionType:[self p_sectionTypeForCollectionView:collectionView] withSender:sender];
    }
}

- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    if ([_delegate respondsToSelector:@selector(headerSheet:transitionLayoutForOldLayout:newLayout:inSectionType:)]) {
        return [_delegate headerSheet:self transitionLayoutForOldLayout:fromLayout newLayout:toLayout inSectionType:[self p_sectionTypeForCollectionView:collectionView]];
    } else {
        UICollectionViewTransitionLayout *transitionLayout = [[UICollectionViewTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
        return transitionLayout;
    }
}

# pragma mark - Register class for separator views of container sheet

- (void)registerClass:(Class)viewClass forSeparatorViewWithReuseIdentifier:(NSString *)identifier
{
    [_containerSheet registerClass:viewClass forInterRowViewWithReuseIdentifier:identifier];
    [_containerSheet registerClass:viewClass forInterColumnViewWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forSeparatorViewWithReuseIdentifier:(NSString *)identifier
{
    [_containerSheet registerNib:nib forInterRowViewWithReuseIdentifier:identifier];
    [_containerSheet registerNib:nib forInterColumnViewWithReuseIdentifier:identifier];
}

- (void)registerClass:(Class)viewClass forSeparatorViewOfSeparatorType:(TAXHeaderSheetSeparatorType)separatorType withReuseIdentifier:(NSString *)identifier
{
    if (separatorType == TAXHeaderSheetSeparatorTypeTop ||
        separatorType == TAXHeaderSheetSeparatorTypeBottom) {
        [_containerSheet registerClass:viewClass forInterRowViewWithReuseIdentifier:identifier];
    } else {
        [_containerSheet registerClass:viewClass forInterColumnViewWithReuseIdentifier:identifier];
    }
}

- (void)registerNib:(UINib *)nib forSeparatorViewOfSeparatorType:(TAXHeaderSheetSeparatorType)separatorType withReuseIdentifier:(NSString *)identifier
{
    if (separatorType == TAXHeaderSheetSeparatorTypeTop ||
        separatorType == TAXHeaderSheetSeparatorTypeBottom) {
        [_containerSheet registerNib:nib forInterRowViewWithReuseIdentifier:identifier];
    } else {
        [_containerSheet registerNib:nib forInterColumnViewWithReuseIdentifier:identifier];
    }
}

#pragma mark Dequeue Separator Views

- (id)dequeueReusableSeparatorViewOfSeparatorType:(TAXHeaderSheetSeparatorType)separatorType withReuseIdentifier:(NSString *)identifier
{
    switch (separatorType) {
        case TAXHeaderSheetSeparatorTypeTop:
            return [_containerSheet dequeueReusableInterRowViewWithIdentifier:identifier belowRow:0];
            break;
        case TAXHeaderSheetSeparatorTypeBottom:
            return [_containerSheet dequeueReusableInterRowViewWithIdentifier:identifier belowRow:1];
            break;
        case TAXHeaderSheetSeparatorTypeLeft:
            return [_containerSheet dequeueReusableInterColumnViewWithIdentifier:identifier afterColumn:0];
            break;
        case TAXHeaderSheetSeparatorTypeRight:
            return [_containerSheet dequeueReusableInterColumnViewWithIdentifier:identifier afterColumn:1];
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - Register Class/Nib for each sheet

// Register Class/Nib to NSDictionary whose key is identifier and value is class/nib.

#pragma mark Cell

- (void)registerClass:(Class)cellClass forCellInSectionType:(TAXHeaderSheetSectionType)sectionType withReuseIdentifier:(NSString *)identifier
{
    [_classArray[sectionType] addObject:@{identifier: cellClass}];
}

- (void)registerClass:(Class)cellClass forCellInAllSectionWithReuseIdentifier:(NSString *)identifier
{
    for (TAXHeaderSheetSectionType sectionType = TAXHeaderSheetSectionTypeBody; sectionType <= TAXHeaderSheetSectionTypeBottomRight; sectionType++) {
        [_classArray[sectionType] addObject:@{identifier: cellClass}];
    }
}

- (void)registerNib:(UINib *)nib forCellInSectionType:(TAXHeaderSheetSectionType)sectionType withReuseIdentifier:(NSString *)identifier
{
    [_nibArray[sectionType] addObject:@{identifier: nib}];
}

- (void)registerNib:(UINib *)nib forCellInAllSectionWithReuseIdentifier:(NSString *)identifier
{
    for (TAXHeaderSheetSectionType sectionType = TAXHeaderSheetSectionTypeBody; sectionType <= TAXHeaderSheetSectionTypeBottomRight; sectionType++) {
        [_nibArray[sectionType] addObject:@{identifier: nib}];
    }
}

#pragma mark Inter column view

- (void)registerClass:(Class)viewClass forInterColumnViewInSectionType:(TAXHeaderSheetSectionType)sectionType withReuseIdentifier:(NSString *)identifier
{
    [_classArray[sectionType] addObject:@{identifier: viewClass}];
}

- (void)registerNib:(UINib *)nib forInterColumnViewInSectionType:(TAXHeaderSheetSectionType)sectionType withReuseIdentifier:(NSString *)identifier
{
    [_nibArray[sectionType] addObject:@{identifier: nib}];
}

#pragma mark Inter row view

- (void)registerClass:(Class)viewClass forInterRowViewInSectionType:(TAXHeaderSheetSectionType)sectionType withReuseIdentifier:(NSString *)identifier
{
    [_classArray[sectionType] addObject:@{identifier: viewClass}];
}

- (void)registerNib:(UINib *)nib forInterRowViewInSectionType:(TAXHeaderSheetSectionType)sectionType withReuseIdentifier:(NSString *)identifier
{
    [_nibArray[sectionType] addObject:@{identifier: nib}];
}

#pragma mark - Dequeue Cells/Views from each sheet

- (id)dequeueReusableCellInSectionType:(TAXHeaderSheetSectionType)sectionType withReuseIdentifier:(NSString *)identifier forRow:(NSUInteger)row column:(NSUInteger)column
{
    TAXSpreadSheet *spreadSheet = _sheetArray[sectionType];
    UICollectionViewCell *cell = [spreadSheet dequeueReusableCellWithReuseIdentifier:identifier forRow:row column:column];
    return cell;
}

- (id)dequeueReusableInterColumnViewInSectionType:(TAXHeaderSheetSectionType)sectionType withReuseIdentifier:(NSString *)identifier afterColumn:(NSUInteger)column
{
    TAXSpreadSheet *spreadSheet = _sheetArray[sectionType];
    return [spreadSheet dequeueReusableInterColumnViewWithIdentifier:identifier afterColumn:column];
}

- (id)dequeueReusableInterRowViewInSectionType:(TAXHeaderSheetSectionType)sectionType withReuseIdentifier:(NSString *)identifier belowRow:(NSUInteger)row
{
    TAXSpreadSheet *spreadSheet = _sheetArray[sectionType];
    return [spreadSheet dequeueReusableInterRowViewWithIdentifier:identifier belowRow:row];
}

# pragma mark -

- (NSIndexPath *)indexPathForCell:(UICollectionViewCell *)cell inSectionType:(TAXHeaderSheetSectionType)sectionType
{
    TAXSpreadSheet *spreadSheet = [self p_spreadSheetForSectionType:sectionType];
    return [spreadSheet indexPathForCell:cell];
}

@end
