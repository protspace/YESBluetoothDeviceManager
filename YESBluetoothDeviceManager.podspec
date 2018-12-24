Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '12.0'
s.name = 'YESBluetoothDeviceManager'
s.summary = 'YESBluetoothDeviceManager helps to interact with BLE devices'
s.requires_arc = true
s.version = '0.2.2'
s.license = { :type => 'MIT', :file => 'LICENSE' }
s.author = { 'Yevgen Sagidulin' => 'protspace@gmail.com' }
s.homepage = 'https://github.com/protspace/YESBluetoothDeviceManager'
s.source = { :git => 'https://github.com/protspace/YESBluetoothDeviceManager.git', :tag => '0.2.2' }
#s.framework = 'Foundation'
#s.framework = 'CoreBluetooth'
#s.ios.framework = 'UIKit'
s.source_files = 'YESBluetoothDeviceManager/*.swift', 'YESBluetoothDeviceManager', 'YESBluetoothDeviceManager/*.{swift}', 'YESBluetoothDeviceManager/YESBluetoothDeviceManager/*.swift'
#s.resources = 'YESBluetoothDeviceManager/*.{xcassets}'
s.swift_version = '4.2'

end
