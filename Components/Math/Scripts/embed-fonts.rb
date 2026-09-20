#!/usr/bin/env ruby

require 'fileutils'

source = ARGV.fetch(0)
fonts = ARGV.fetch(1)
build = ARGV.fetch(2)
files = Dir[File.join(fonts, '*.{otf,plist}')].sort
abort 'No iosMath fonts found' if files.empty?

FileUtils.mkdir_p(build)
blob = File.join(build, 'iosMath-fonts.bin')
File.binwrite(blob, '')
offset = 0
entries = files.map do |path|
  data = File.binread(path)
  entry = [File.basename(path), offset, data.bytesize]
  File.open(blob, 'ab') { |file| file.write(data) }
  offset += data.bytesize
  entry
end

render = File.join(source, 'iosMath', 'render')
branches = entries.map do |name, start, length|
  %(    if ([filename isEqualToString:@"#{name}"]) return [NSData dataWithBytesNoCopy:(void *)(MTEmbeddedFontsStart + #{start}) length:#{length} freeWhenDone:NO];)
end.join("\n")

File.write(File.join(render, 'MTEmbeddedFontData.m'), <<~OBJC)
  #import <Foundation/Foundation.h>

  extern const unsigned char MTEmbeddedFontsStart[];

  NSData *MTEmbeddedFontData(NSString *filename)
  {
  #{branches}
      return nil;
  }
OBJC

File.write(File.join(render, 'MTEmbeddedFonts.S'), <<~ASM)
  .section __DATA,__const
  .p2align 4
  .globl _MTEmbeddedFontsStart
  _MTEmbeddedFontsStart:
  .incbin "#{blob}"
ASM
