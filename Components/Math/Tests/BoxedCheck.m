#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <iosMath/iosMath.h>
#import <iosMath/MTTypesetter.h>
#include <assert.h>

static MTMathListDisplay *Layout(NSString *latex, MTFont *font) {
    NSError *error = nil;
    MTMathList *list = [MTMathListBuilder buildFromString:latex error:&error];
    assert(list && !error);
    NSString *serialized = [MTMathListBuilder mathListToString:list];
    assert([MTMathListBuilder buildFromString:serialized error:&error]);
    return [MTTypesetter createLineForMathList:list font:font style:kMTLineStyleDisplay];
}

int main(void) { @autoreleasepool {
    MTFont *font = [[MTFontManager fontManager] fontWithName:MTFontNameLatinModern size:20];
    assert(font);
    MTMathListDisplay *plain = Layout(@"x", font);
    MTMathListDisplay *boxed = Layout(@"\\boxed{x}", font);
    assert(boxed.width > plain.width + 12);
    assert(boxed.ascent > plain.ascent + 6 && boxed.descent > plain.descent + 6);
    assert(Layout(@"a+\\boxed{\\frac{1}{2}}", font).width > boxed.width);
    assert(Layout(@"\\boxed{\\boxed{x}}", font).width > boxed.width);
    assert(Layout(@"\\boxed{x}_i^2", font).width > boxed.width);
    assert(Layout(@"\\boxed{\\text{无法确定（可能收敛也可能发散）}}", font).width > 0);
    for (NSString *invalid in @[@"\\boxed", @"\\boxed{", @"\\boxed{\\frac{1}"]) {
        NSError *error = nil;
        assert(![MTMathListBuilder buildFromString:invalid error:&error] && error);
    }
    // Check real pixels: both horizontal borders must span almost the entire box.
    size_t width = (size_t)ceil(boxed.width + 20), height = (size_t)ceil(boxed.ascent + boxed.descent + 20);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, width * 4, space, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    assert(context);
    boxed.position = CGPointMake(10, 10 + boxed.descent);
    boxed.textColor = UIColor.blackColor;
    [boxed draw:context];
    unsigned char *pixels = CGBitmapContextGetData(context);
    int borderRows = 0;
    for (size_t y = 0; y < height; y++) {
        int count = 0;
        for (size_t x = 0; x < width; x++) { if (pixels[(y * width + x) * 4 + 3]) count++; }
        if (count >= floor(boxed.width) - 2) borderRows++;
    }
    assert(borderRows >= 2);
    CGContextRelease(context);
    CGColorSpaceRelease(space);
    puts("boxed: parsing, round-trip, nested layout, scripts, CJK, incomplete input and border pixels passed");
} return 0; }
