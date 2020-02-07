//
//  UIImageView+Extenstion.swift
//  VComicApp
//
//  Created by 陈建立 on 2017/9/9.
//  Copyright © 2017年 Gookee. All rights reserved.
//

/*
import Foundation
import Kingfisher
import YYImage

// MARK: - 全局常量
// 图片默认的渐变动画时间
let kDefaultKingfisherFadeTransitionDuration: TimeInterval = 0.36

// Associated Object Key
// 绑定KingfisherOption的Key
private var kingfihserOptionsAssociatedObjectKey: Void?
// 绑定图片原始数据的Key
private var imageDataAssociatedObjectKey: Void?

// MARK: - PlaceholderType 自定义的占位图枚举
enum PlaceholderType {
    
    case userHead               // 头像
    case bookCover              // 书籍封面
    case homeRectangle
    case recommendBanner        // 推荐位轮播图
    case homeCard
    case comicRoleHead          // 漫画相关人物
    case opusClass
    case comicLandscape       // 漫画-封面(漫画详情页)
    case custom(UIImage?)       // 自定义
    case none                   // 无
    
    var placeholderImage: UIImage? {
        switch self {
        case .userHead: return UIImage.placeholderUserHead
        case .bookCover: return UIImage.placeholderBookCover
        case .opusClass: return UIImage.placeholderOpusClass
        case .homeCard: return UIImage.placeholderHomeCard
        case .homeRectangle: return UIImage.placeholderHomeRectangle
        case .recommendBanner: return UIImage.placeholderRecommendBanner
        case .comicRoleHead: return UIImage.placeholderCat
        case .comicLandscape: return UIImage.placeholderComicLandscape
        case .custom(let image): return image
        case .none: return nil
        }
    }
    
    var options: KingfisherOptionsInfo? {
        switch self {
        case .none:
            return nil
        default:
            return [.onlyLoadFirstFrame]
        }
    }
}

// MARK: - Extension UIImageView to Load Image
extension UIImageView {
    /// 清除内存缓存
    func clearMemory(url cacheKey: String) {
        KingfisherManager.shared.cache.removeImage(forKey: cacheKey, processorIdentifier: kingfisherOptions?.processor.identifier ?? "", fromMemory: true, fromDisk: false) {}
        KingfisherManager.shared.cache.removeImage(forKey: cacheKey, fromMemory: true, fromDisk: false) {}
    }
    
    // MAKR: - 常规头像
    ///
    /// - Parameters:
    ///   - resource: 资源
    ///   - options: 配置参数
    ///   - completionHandler: 完成回调
    func setUserAvatarImage(with resource: String?, options: KingfisherOptionsInfo? = nil, placeholder: UIImage? = UIImage.placeholderUserHead, completionHandler: CompletionHandler? = nil) {
        //        kf.setImage(with: URL(string: resource ?? "http://tva1.sinaimg.cn/default/images/default_avatar_male_50.gif"),
        kf.setImage(with: URL(string: resource ?? ""),
                    placeholder: placeholder,
                    options: (options ?? []) +
                        [
                            .onlyLoadFirstFrame,
                            .downloadPriority(0.6),
                            .transition(ImageTransition.fade(kDefaultKingfisherFadeTransitionDuration))
            ],
                    progressBlock: nil,
                    completionHandler: completionHandler)
    }
    
    // MAKR: - 墨水头像
    func setAuthorAvatarImage(with resource: String?, options: KingfisherOptionsInfo? = nil, completionHandler: CompletionHandler? = nil) {
        kf.setImage(with: URL(string: resource ?? ""),
                    placeholder: UIImage.placeholderAuthor,
                    options: (options ?? []) +
                        [
                            .onlyLoadFirstFrame,
                            .downloadPriority(0.6),
                            .transition(ImageTransition.fade(kDefaultKingfisherFadeTransitionDuration))
            ],
                    progressBlock: nil,
                    completionHandler: completionHandler)
    }
    
    // MARK: - 加载图片通用方法
    ///
    /// - Parameters:
    ///   - resource: 资源
    ///   - type: 类型，定义在PlaceholderType中
    ///   - options: 配置参数
    ///   - completionHandler: 完成回调
    @discardableResult
    func setImage(with resource: Resource?,
                  placeholder type: PlaceholderType? = .bookCover,
                  options: KingfisherOptionsInfo? = nil,
                  fadeTransition: Bool = true,
                  progressBlock: DownloadProgressBlock? = nil,
                  completionHandler: CompletionHandler? = nil) -> RetrieveImageTask {
        return setImage(with: resource,
                        placeholder: type,
                        options: options,
                        transition: fadeTransition ? ImageTransition.fade(kDefaultKingfisherFadeTransitionDuration) : nil,
                        progressBlock: progressBlock,
                        completionHandler: completionHandler)
    }
    
    @discardableResult
    func setImage(with resource: Resource?,
                  placeholder type: PlaceholderType? = .bookCover,
                  options: KingfisherOptionsInfo? = nil,
                  transition: ImageTransition?,
                  progressBlock: DownloadProgressBlock? = nil,
                  completionHandler: CompletionHandler? = nil) -> RetrieveImageTask {
        kingfisherOptions =
            (options ?? []) +
            [
                .downloadPriority(1.0),
                .downloader(VCImageManager.shared.downloader)
            ]
            + (transition != nil ? [.transition(transition!)] : [])
        let task = kf.setImage(with: resource,
                               placeholder: type?.placeholderImage,
                               options: kingfisherOptions,
                               progressBlock: progressBlock) { (image, error, cacheType, imageUrl) in
                                image?.originalData = nil
                                completionHandler?(image, error, cacheType, imageUrl)}
        
        if let controller = self.viewController {
            let weakImage = VCWeakImageTask(task: task, cacheKey: resource?.cacheKey, identifier: kingfisherOptions?.processor.identifier)
            weakImage.bindDeinit(obj: controller)
            //            weakImage.bindDeinit(obj: self)
        }
        
        return task
    }
    
    // MARK: - 配置了内存优化功能的加载方法
    @discardableResult
    func setOptimizedImage(with resource: Resource?,
                           desitinationSize size: CGSize? = nil,
                           placeholder type: PlaceholderType? = .bookCover,
                           options: KingfisherOptionsInfo? = [.cacheOriginalImage],
                           fadeTransition: Bool = true,
                           compressedEnabled: Bool = true,
                           progressBlock: DownloadProgressBlock? = nil,
                           completionHandler: CompletionHandler? = nil) -> RetrieveImageTask {
        return setOptimizedImage(with: resource,
                                 desitinationSize: size,
                                 placeholder: type,
                                 options: options,
                                 transition: fadeTransition ? ImageTransition.fade(kDefaultKingfisherFadeTransitionDuration) : nil,
                                 compressedEnabled: compressedEnabled,
                                 progressBlock: progressBlock,
                                 completionHandler: completionHandler)
    }
    
    @discardableResult
    func setOptimizedImage(with resource: Resource?,
                           desitinationSize size: CGSize? = nil,
                           placeholder type: PlaceholderType? = .bookCover,
                           options: KingfisherOptionsInfo? = [.cacheOriginalImage],
                           transition: ImageTransition?,
                           compressedEnabled: Bool = true,
                           progressBlock: DownloadProgressBlock? = nil,
                           completionHandler: CompletionHandler? = nil) -> RetrieveImageTask {
        let processor = VCImageProcessor(destinationSize: size, viewSize: safetySize, isCompressedEnabled: compressedEnabled)
        return setImage(with: resource,
                        placeholder: type,
                        options: (options ?? []) +
                            [
                                .callbackDispatchQueue(dequeueBaseImageRequestPool()),
                                .processor(processor),
                                .cacheSerializer(VCImageManager.shared.cacheSerializer)
                            ],
                        transition: transition,
                        progressBlock: progressBlock,
                        completionHandler: completionHandler)
    }
    
    // MARK: - 优先从缓存中读取无则下载
    func retrieveImageFromCacheOrRefresh(with resource: Resource?,
                                         desitinationSize size: CGSize? = nil,
                                         placeholder type: PlaceholderType? = .bookCover,
                                         options: KingfisherOptionsInfo? = nil,
                                         transition: ImageTransition? = nil,
                                         progressBlock: DownloadProgressBlock? = nil,
                                         completionHandler: CompletionHandler? = nil) {
        if let url = resource {
            let processor = VCImageProcessor(destinationSize: size, viewSize: safetySize)
            if let cachedImage = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: url.cacheKey,
                                                                                           options: [.processor(processor)]) {
                kf.cancelDownloadTask()
                kf.setImage(with: nil, placeholder: cachedImage, progressBlock: progressBlock, completionHandler: completionHandler)
            } else {
                setOptimizedImage(with: url, desitinationSize: size, placeholder: type, options: options,
                                  transition: transition, progressBlock: progressBlock, completionHandler: completionHandler)
            }
        } else {
            kf.cancelDownloadTask()
            kf.setImage(with: nil, placeholder: type?.placeholderImage)
        }
    }
    
    
}

// MARK: - Extension UIButton to Load Image（同UIImageView的拓展）
extension UIButton {
    
    func setUserAvatarImage(with resource: String?, options: KingfisherOptionsInfo? = nil, completionHandler: CompletionHandler? = nil) {
        kf.setImage(with: URL(string: resource ?? ""), for: .normal,
                    placeholder: UIImage.placeholderUserHead,
                    options: (options ?? []) +
                        [
                            .backgroundDecode,
                            .onlyLoadFirstFrame,
                            .downloader(VCImageManager.shared.downloader),
                            .transition(ImageTransition.fade(kDefaultKingfisherFadeTransitionDuration))
            ],
                    progressBlock: nil,
                    completionHandler: completionHandler)
    }
    
    func setAuthorAvatarImage(with resource: String?, options: KingfisherOptionsInfo? = nil, completionHandler: CompletionHandler? = nil) {
        kf.setImage(with: URL(string: resource ?? ""), for: .normal,
                    placeholder: UIImage.placeholderAuthor,
                    options: (options ?? []) +
                        [
                            .backgroundDecode,
                            .onlyLoadFirstFrame,
                            .downloader(VCImageManager.shared.downloader),
                            .transition(ImageTransition.fade(kDefaultKingfisherFadeTransitionDuration))
            ],
                    progressBlock: nil,
                    completionHandler: completionHandler)
    }
    
    func setImage(with resource: Resource?,
                  placeholder type: PlaceholderType? = .bookCover,
                  options: KingfisherOptionsInfo? = nil,
                  fadeTransition: Bool = true,
                  progressBlock: DownloadProgressBlock? = nil,
                  completionHandler: CompletionHandler? = nil) {
        kingfisherOptions =
            (options ?? []) +
            [
                .downloadPriority(1.0),
                .downloader(VCImageManager.shared.downloader)
            ]
            + (fadeTransition ? [.transition(ImageTransition.fade(kDefaultKingfisherFadeTransitionDuration))] : [])
        kf.setImage(with: resource, for: .normal,
                    placeholder: type?.placeholderImage,
                    options: kingfisherOptions,
                    progressBlock: progressBlock) { (image, error, cacheType, imageUrl) in
                        image?.originalData = nil
                        completionHandler?(image, error, cacheType, imageUrl)
        }
    }
    
    func setOptimizedImage(with resource: Resource?,
                           desitinationSize size: CGSize? = nil,
                           placeholder type: PlaceholderType? = .bookCover,
                           options: KingfisherOptionsInfo? = [.cacheOriginalImage],
                           fadeTransition: Bool = true,
                           progressBlock: DownloadProgressBlock? = nil,
                           completionHandler: CompletionHandler? = nil) {
        let processor = VCImageProcessor(destinationSize: size, viewSize: safetySize)
        setImage(with: resource,
                 placeholder: type,
                 options: (options ?? []) +
                    [
                        .callbackDispatchQueue(dequeueBaseImageRequestPool()),
                        .processor(processor),
                        .cacheSerializer(VCImageManager.shared.cacheSerializer)
            ],
                 fadeTransition: fadeTransition,
                 progressBlock: progressBlock,
                 completionHandler: completionHandler)
    }
    
    func retrieveImageFromCacheOrRefresh(with resource: Resource?,
                                         desitinationSize size: CGSize? = nil,
                                         placeholder type: PlaceholderType? = .bookCover,
                                         options: KingfisherOptionsInfo? = nil,
                                         progressBlock: DownloadProgressBlock? = nil,
                                         completionHandler: CompletionHandler? = nil) {
        if let url = resource {
            let processor = VCImageProcessor(destinationSize: size, viewSize: safetySize)
            if let cachedImage = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: url.cacheKey,
                                                                                           options: [.processor(processor)]) {
                kf.cancelImageDownloadTask()
                kf.setImage(with: nil, for: .normal, placeholder: cachedImage)
            } else {
                setOptimizedImage(with: url, desitinationSize: size, placeholder: type,
                                  options: options, progressBlock: progressBlock, completionHandler: completionHandler)
            }
        } else {
            kf.cancelImageDownloadTask()
            kf.setImage(with: nil, for: .normal, placeholder: type?.placeholderImage)
        }
    }
}

// MARK: - AssociatedObject(kingfisherOptions/originalData)
extension UIImageView {
    
    public var kingfisherOptions: KingfisherOptionsInfo? {
        get {
            return objc_getAssociatedObject(self, &kingfihserOptionsAssociatedObjectKey) as? KingfisherOptionsInfo
        }
        set {
            objc_setAssociatedObject(self, &kingfihserOptionsAssociatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

extension UIButton {
    
    public var kingfisherOptions: KingfisherOptionsInfo? {
        get {
            return objc_getAssociatedObject(self, &kingfihserOptionsAssociatedObjectKey) as? KingfisherOptionsInfo
        }
        set {
            objc_setAssociatedObject(self, &kingfihserOptionsAssociatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

extension Image {
    
    public var originalData: Data? {
        get {
            return objc_getAssociatedObject(self, &imageDataAssociatedObjectKey) as? Data
        }
        set {
            objc_setAssociatedObject(self, &imageDataAssociatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

// MARK: - VCImageProcessor 图片处理器，主要是对图片做压缩处理

/* 实现Kingfisher提供的ImageProcessor协议，ImageProcessor协议有一个计算型属性和一个方法需要实现，
 实现协议的注意事项：
 1. 计算型属性 identifier 的实现请确保不为空，因为默认的DefaultImageProcessor已经将其实现为空，建议使用APP的Bundle Identifier
 作为其值，但是在我们的项目中应用时，在实际实现的过程中，我们发现，应该Bundle Identifier之外，再添加一个destinationSize作为参数，
 因为我们的APP有这样一种场景，同一图片资源，可分别在destinationSize为 90 x 90 的九宫格ImageView组件上显示，
 也会在点击该九宫格组件之后，在图片查看器上查看，此时的destinationSize可能为 375 x 675（程序实现上destinationSize还要乘以scale的），
 因此，如果之前加载到 90 x 90 的组件上显示的图片资源，由于被严重压缩了，此时如果直接从内存中取出并展示在 375 x 675 的组件上，那么势必很模糊，
 因此，需要各个组件需要传入正确的、合适的destinationSize参数，获得到最佳的、正确的展示。
 2. 方法 process(item: ImageProcessItem, options: KingfisherOptionsInfo) -> Image?
 实现的原则就是，根据传入的item和options决定，要怎么处理item，如果ImageProcessItem是image(Image)类型的，处理失败时，应该返回image
 有三种情况会调用本方法：
 2.1 获取图片时，内存和磁盘都取不到数据，接着从磁盘中取出原始Data，经VCImageCacheSerializer转化成Image后，调用本方法
 ( <-- Kingfisher 4.10.1 -->
 在KingfihserManager.swift，第266、267行
 ...
 processQueue.async {
 guard let processedImage = processor.process(item: .image(image), options: options) else {
 ...
 )
 
 2.2 网络请求回来，带过来原始图片数据data
 ( <-- Kingfisher 4.10.1 -->
 在ImageDownloader.swift，第640行
 ...
 processor.process(item: .data(data), options: options)
 ...
 )
 在这里进一步处理。（⚠️ gif格式不做压缩处理）
 */
struct VCImageProcessor: ImageProcessor {
    
    /// 目标大小
    private let destinationSize: CGSize?
    
    /// 视图大小
    private let viewSize: CGSize
    
    /// 限制图片的最大内存(1M)
    private let limitBytes: Int
    
    /// 是否启用压缩(原生默认启用，RN默认禁用)
    private let isCompressedEnabled: Bool
    
    init(destinationSize: CGSize? = nil, viewSize: CGSize, limitBytes: Int = 1 * 1024 * 1024, isCompressedEnabled: Bool = true) {
        self.destinationSize = destinationSize
        self.viewSize = viewSize
        self.limitBytes = limitBytes
        self.isCompressedEnabled = isCompressedEnabled
    }
    
    var identifier: String {
        let size = destinationSize ?? viewSize
        return Bundle.main.bundleIdentifier! + "_ResizeImageView_\(Int(size.width))x\(Int(size.height))"
    }
    
    /// 处理传入的ImageProcessItem为Image
    ///
    /// - Parameters:
    ///   - item: ImageProcessItem
    ///   - options: KingfisherOptionsInfo
    /// - Returns: Image，主要是对图片做压缩处理
    func process(item: ImageProcessItem, options: KingfisherOptionsInfo) -> Image? {
        
        let nativeScale = UIScreen.main.nativeScale
        // 限制图片的最大宽高
        let limitWidth: CGFloat = min((destinationSize?.width ?? viewSize.width * nativeScale), kLimitMaxImageSize.width)
        let limitHeight: CGFloat = min((destinationSize?.height ?? viewSize.height * nativeScale), kLimitMaxImageSize.height)
        let limitSize = CGSize(width: limitWidth, height: limitHeight)
        
        switch item {
            
            /* 上面 2.1 描述 */
        // ⚠️ 根据2.1的描述，此处传入的image必然是原始图片数据生成的Image对象
        case .image(let image):
            let originalData = image.originalData
            image.originalData = nil
            
            // 在VCImageCacheSerializer从磁盘中读取出Image时（image(with:, options:)方法），
            // 给Image赋值了imageFormatType，因此这里可以直接获取到图片格式。
            let imageFormat = image.imageFormatType
            switch imageFormat {
            case .gif:
                let gifImage = DefaultImageProcessor.default.process(item: item, options: options)
                // 这里再次对处理后的gifImage赋值originalData和imageFormatType，
                // 是因为可能会把gifImage存储起来，调用到VCImageCacheSerializer的data(with:, :)方法，该方法内需要用到这两个值
                gifImage?.originalData = originalData
                gifImage?.imageFormatType = .gif
                return gifImage
                
            case .webP:
                let webPImage = image
                guard let data = autoreleasepool(invoking: { () -> Data? in
                    if image.hasAlphaChannel() || !isCompressedEnabled {
                        return nil
                    }
                    // ⚠️ 压缩webp资源，压缩大小限制为 limitBytes / 4 = 256kb
                    let compressedData = UIImage.compress(webPImage, limitBytes: limitBytes / imageFormat.compressRatio, maxSize: limitSize, isDiscardMinLimitImage: true)
                    return compressedData
                }) else {
                    // 压缩失败或者不压缩时，仍然返回webp格式
                    webPImage.originalData = originalData
                    webPImage.imageFormatType = .webP
                    return webPImage
                }
                // 压缩成功，已转成jpg
                // ⚠️ optimizedImage的originalData、imageFormatType需要分别设置成nil和unknown
                //    这样VCImageCacheSerializer缓存optimizedImage时就不使用originalData来判断图片格式了
                let optimizedImage = UIImage(data: data)
                optimizedImage?.originalData = nil
                optimizedImage?.imageFormatType = .unknown
                return optimizedImage
                
            default:
                guard let data = autoreleasepool(invoking: { () -> Data? in
                    if image.hasAlphaChannel() || !isCompressedEnabled {
                        return nil
                    }
                    return UIImage.compress(image, limitBytes: limitBytes / imageFormat.compressRatio, maxSize: limitSize, isDiscardMinLimitImage: true)
                }) else {
                    // 压缩失败或者不压缩时，返回图片原始数据和对应的图片格式
                    image.originalData = originalData
                    image.imageFormatType = originalData?.imageFormatType ?? .unknown
                    return image
                }
                // 压缩成功，已转成jpg
                let optimizedImage = UIImage(data: data)
                optimizedImage?.originalData = originalData
                optimizedImage?.imageFormatType = .jpg
                return optimizedImage
            }
            
            /* 上面 2.2 描述 */
        case .data(let data):
            
            // 根据图片格式处理生成Image
            let imageFormat = data.imageFormatType
            switch imageFormat {
                
            // 1. gif格式目前不做压缩处理，交由DefaultImageProcessor处理，否则将只能取出第一帧，丢失动图特性
            case .gif:
                return DefaultImageProcessor.default.process(item: item, options: options)
                
            // 2. webp格式，目前后台仅支持单张非动态图，因此，可用YYImage解码，然后再压缩成JPEG格式，进而节省内存
            case .webP:
                // 需要注意的是，这里返回的Image会在存储到磁盘时，在VCImageCacheSerializer的data(with:, original:)中被调用，
                // 这里可能返回YYImage，也可能返回UIImage，data(with:, original:)方法处理时，要判断处理。
                return autoreleasepool { () -> UIImage? in
                    if let yyImage = YYImage(data: data) {
                        if yyImage.hasAlphaChannel() || !isCompressedEnabled {
                            return yyImage
                        }
                        
                        // webp资源不做data.count > limitBytes判断，因为本身webp资源就很小，但是可能图片像素很大，
                        // 还是会占用很多内存，因此，这里解除对data.count > limitBytes的判断限制。
                        /* guard data.count > limitBytes else { return image } */
                        
                        // ⚠️ 压缩webp资源，压缩大小限制为 limitBytes / 4 = 256kb
                        guard let data = UIImage.compress(yyImage, limitBytes: limitBytes / imageFormat.compressRatio, maxSize: limitSize, isDiscardMinLimitImage: true) else {
                            // 如果压缩失败，依然返回yyImage（返回① YYImage类型）
                            return yyImage
                        }
                        // 返回压缩后的Image（返回② UIImage类型）
                        return UIImage(data: data)
                    }
                    return nil
                }
                
            case .jpg:
                return autoreleasepool { () -> UIImage? in
                    if let image = UIImage(data: data) {
                        // 禁用压缩时直接返回
                        guard isCompressedEnabled else { return image }
                        
                        // JPG格式的图片
                        // 1. 文件一般比较小，data.count 限制在 256kb
                        // 2. 像素超过 limitPiexles
                        
                        let imageSize = image.size
                        let piexles = imageSize.width * imageSize.height
                        let limitPiexles = limitSize.width * limitSize.height
                        guard data.count > limitBytes / imageFormat.compressRatio || piexles >= limitPiexles else { return image }
                        
                        // 超过限制条件，一律压缩
                        guard let data = UIImage.compress(image, limitBytes: limitBytes / imageFormat.compressRatio, maxSize: limitSize, isDiscardMinLimitImage: true) else {
                            return image
                        }
                        return UIImage(data: data)
                    }
                    return nil
                }
                
            // 3. 其他格式，如png，一律做压缩处理
            default:
                return autoreleasepool { () -> UIImage? in
                    if let image = UIImage(data: data) {
                        if image.hasAlphaChannel() || !isCompressedEnabled {
                            return image
                        }
                        // png格式的图片，一般小于1M时，像素应该在可接受范围内了，可直接返回
                        guard data.count > limitBytes else { return image }
                        // 超过1M时，才压缩处理
                        guard let data = UIImage.compress(image, limitBytes: limitBytes, maxSize: limitSize, isDiscardMinLimitImage: true) else {
                            return image
                        }
                        return UIImage(data: data)
                    }
                    return nil
                }
            }
        }
    }
    
}

// MARK: - VCImageManager 图片管理支持器，主要提供下载器，解析器等
class VCImageManager {
    
    // 单例
    static let shared = VCImageManager()
    
    // 私有构造函数
    private init() {}
    
    // 私有变量
    private var _isCleanPerforming = false
    private var _isCleanExpiredDiskCacheDone = false
    private var _isClearDiskCacheDone = false
    
    // 下载器
    lazy var downloader: ImageDownloader = {
        let downloader = ImageDownloader(name: "UIImageView+Extenstion")
        downloader.requestsUsePipelining = true
        return downloader
    }()
    
    // 解析器
    lazy var cacheSerializer: VCImageCacheSerializer = {
        let cacheSerializer = VCImageCacheSerializer()
        return cacheSerializer
    }()
    
    // 收到内存警告时清理图片资源
    func cleanImageResourceOnReceiveMemoryWarning() {
        if !_isCleanPerforming {
            _isCleanPerforming = true
            let cache = KingfisherManager.shared.cache
            /* Kingfisher 默认实现了监听内存警告清除MemoryCache的功能
             ...
             NotificationCenter.default.addObserver(self, selector: #selector(clearMemoryCache), name: memoryNotification, object: nil)
             ...
             // 清理网络缓存
             cache.clearMemoryCache()
             */
            
            _isCleanExpiredDiskCacheDone = false
            _isClearDiskCacheDone = false
            
            // 清理过期的，或者超过硬盘限制大小的
            cache.cleanExpiredDiskCache { [weak self] in
                guard let SELF = self else { return }
                SELF._isCleanExpiredDiskCacheDone = true
                if SELF._isClearDiskCacheDone {
                    SELF._isCleanPerforming = false
                }
            }
            
            // 一般的 收到内存警告不会清理磁盘缓存，但是在极限状态下，清理磁盘内存最高达到600M，不清理磁盘高达到1G多
            cache.clearDiskCache { [weak self] in
                guard let SELF = self else { return }
                SELF._isClearDiskCacheDone = true
                if SELF._isCleanExpiredDiskCacheDone {
                    SELF._isCleanPerforming = false
                }
            }
        }
    }
}

// MARK: - VCImageCacheSerializer 图片的序列化和反序列化
class VCImageCacheSerializer: CacheSerializer {
    
    // 存储到磁盘时调用
    public func data(with image: Image, original: Data?) -> Data? {
        // 图片原始数据
        let _originalData = original ?? image.originalData
        // 想尽一切办法获取到imageFormatType信息😀
        var imageFormatType: VCImageFormatType = .unknown
        if image.imageFormatType != .unknown {
            imageFormatType = image.imageFormatType
        } else {
            imageFormatType = _originalData?.imageFormatType ?? .unknown
            image.imageFormatType = imageFormatType
        }
        
        image.originalData = nil
        
        // 根据图片格式，encode成Data，用来存储到本地磁盘
        switch imageFormatType {
        case .webP:
            return autoreleasepool { () -> Data? in
                // 搜索“返回① YYImage类型”查看具体逻辑
                if let yyImage = image as? YYImage {
                    if let data = yyImage.animatedImageData {
                        return data
                    }
                    let encoder = YYImageEncoder(type: YYImageType.webP)
                    encoder?.quality = 0.9
                    encoder?.add(yyImage, duration: 0)
                    let data = encoder?.encode()
                    return data
                } else {
                    // 搜索“返回② UIImage类型”查看具体逻辑
                    return DefaultCacheSerializer.default.data(with: image, original: _originalData)
                }
            }
        case .gif:
            return autoreleasepool { () -> Data? in
                // 搜索“返回① YYImage类型”查看具体逻辑
                if let yyImage = image as? YYImage {
                    if let data = yyImage.animatedImageData {
                        return data
                    }
                    let encoder = YYImageEncoder(type: YYImageType.GIF)
                    encoder?.quality = 0.9
                    encoder?.add(yyImage, duration: 0)
                    let data = encoder?.encode()
                    return data
                } else {
                    let data = image.kf.gifRepresentation()
                    return data
                }
            }
        default:
            return autoreleasepool { () -> Data? in
                return DefaultCacheSerializer.default.data(with: image, original: _originalData)
            }
        }
    }
    
    // 从磁盘读取之前存储的图片数据时调用
    public func image(with data: Data, options: KingfisherOptionsInfo?) -> Image? {
        // 根据图片格式，进行对应的处理生成Image
        let imageFormatType = data.imageFormatType
        let image: Image?
        switch imageFormatType {
        case .webP: image = YYImage(data: data)
        case .gif:
            image = DefaultCacheSerializer.default.image(with: data, options: [.preloadAllAnimationData])
        default:
            image = DefaultCacheSerializer.default.image(with: data, options: options)
        }
        // 临时存储一下两个数据，稍后在VCImageProcessor中用到（上面 2.1 描述）：
        // 1. originalData 图片原始数据
        // 2. imageFormatType 图片格式
        image?.originalData = data
        image?.imageFormatType = imageFormatType
        return image
    }
}
*/
