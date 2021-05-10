platform :ios, '14'

def common_pods
    pod 'RxAlamofire'
    pod 'Anchorage'
    pod 'RxGesture'
    pod 'DropDown'
    pod 'SVProgressHUD'
    pod 'Sourcery'
end

target 'lastfm-explorer' do
    use_frameworks!

    common_pods
end

def test_pods
    use_frameworks!

    pod 'RxTest'
end

target 'lastfm-explorerTests' do
   use_frameworks!
  
   test_pods
end

target 'lastfmExplorerUITests' do
    pod 'SnapshotTesting'
end