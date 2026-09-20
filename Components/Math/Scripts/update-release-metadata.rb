#!/usr/bin/env ruby

require 'open3'

root = File.expand_path('..', __dir__)
version = File.read(File.join(root, 'VERSION')).strip
zip_path = File.join(root, '.build', 'release', 'iosMath.xcframework.zip')
abort "Missing #{zip_path}" unless File.file?(zip_path)

checksum, error, status = Open3.capture3('swift', 'package', 'compute-checksum', zip_path)
abort "Failed to compute SwiftPM checksum: #{error}" unless status.success?

package_path = File.join(root, 'Package.swift')
package = File.read(package_path)
package.sub!(/let version = "[^"]+"/, "let version = \"iosMath-#{version}\"") or abort 'Package version not updated'
package.sub!(/checksum: "[0-9a-f]{64}"/, "checksum: \"#{checksum.strip}\"") or abort 'Checksum not updated'
File.write(package_path, package)
