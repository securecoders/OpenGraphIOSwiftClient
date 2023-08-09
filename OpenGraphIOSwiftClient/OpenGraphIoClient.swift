import Foundation

struct OpenGraphIO {
    
    struct Options {
        var cacheOk: Bool
        var service: String
        var version: String
        var appId: String
        var useProxy: Bool
        var fullRender: Bool
        var maxCacheAge: Int?
        var acceptLang: String?
        
        private var _htmlElements: String?

            var htmlElements: String? {
                get {
                    return _htmlElements
                }
                set {
                    if let elements = newValue {
                        _htmlElements = elements.replacingOccurrences(of: " ", with: "")
                    } else {
                        _htmlElements = nil
                    }
                }
            }

        init(appId: String, cacheOk: Bool = true, service: String = "site", version: String = "1.1", useProxy: Bool = false, fullRender: Bool = false, maxCacheAge: Int? = nil, acceptLang: String? = nil, htmlElements: String? = nil) {
            self.appId = appId
            self.cacheOk = cacheOk
            self.service = service
            self.version = version
            self.useProxy = useProxy
            self.fullRender = fullRender
            self.maxCacheAge = maxCacheAge
            self.acceptLang = acceptLang
            self.htmlElements = htmlElements

            if appId.isEmpty {
                fatalError("appId must be supplied when making requests to the API. Get a free appId by signing up here: https://www.opengraph.io/")
            }
        }
    }

    struct SiteResponse: Decodable {
        let hybridGraph: Graph
        let openGraph: OpenGraph
        let htmlInferred: HtmlInferred
        let requestInfo: RequestInfo
        let acceptLang: String
        let isCache: Bool
        let url: URL
        
        enum CodingKeys: String, CodingKey {
            case hybridGraph, openGraph, htmlInferred, requestInfo
            case acceptLang = "accept_lang"
            case isCache = "is_cache"
            case url
        }

        struct Graph: Decodable {
            let title: String?
            let description: String?
            let type: String?
            let image: URL?
            let url: URL?
            let favicon: URL?
            let siteName: String?
            let articlePublishedTime: String?
            let articleAuthor: URL?

            enum CodingKeys: String, CodingKey {
                case title, description, type, image, url, favicon
                case siteName = "site_name"
                case articlePublishedTime
                case articleAuthor
            }
        }

        struct OpenGraph: Decodable {
            let title: String?
            let description: String?
            let type: String?
            let image: Image?
            let url: URL?
            let siteName: String?
            let articlePublishedTime: String?
            let articleAuthor: URL?

            struct Image: Decodable {
                let url: URL?
            }

            enum CodingKeys: String, CodingKey {
                case title, description, type, image, url
                case siteName = "site_name"
                case articlePublishedTime
                case articleAuthor
            }
        }

        struct HtmlInferred: Decodable {
            let title: String?
            let description: String?
            let type: String?
            let image: URL?
            let url: URL?
            let favicon: URL?
            let siteName: String?
            let images: [URL?]?

            enum CodingKeys: String, CodingKey {
                case title, description, type, image, url, favicon, images
                case siteName = "site_name"
            }
        }

        struct RequestInfo: Decodable {
            let redirects: Int?
            let host: URL?
            let responseCode: Int?
            let cacheOk: Bool?
            let maxCacheAge: Int?
            let acceptLang: String?
            let url: URL?
            let fullRender: Bool?
            let useProxy: Bool?
            let useSuperior: Bool?
            let responseContentType: String?

            enum CodingKeys: String, CodingKey {
                case redirects, host, url, fullRender, useProxy, useSuperior, responseContentType
                case responseCode = "responseCode"
                case cacheOk = "cache_ok"
                case maxCacheAge = "max_cache_age"
                case acceptLang = "accept_lang"
            }
        }
    }
    
    struct ExtractResponse: Decodable {
        let tags: [Tag]
        let concatenatedText: String
        
        struct Tag: Decodable {
            let tag: String
            let innerText: String
            let position: Int
        }
    }
    
    typealias ScrapeResponse = String?
    
    enum ServiceResponse: Decodable {
        case site(SiteResponse)
        case extract(ExtractResponse)
        case scrape(ScrapeResponse)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            // Try to decode SiteResponse
            if let siteResponse = try? container.decode(SiteResponse.self) {
                self = .site(siteResponse)
                return
            }
            
            // Try to decode ExtractResponse
            if let extractResponse = try? container.decode(ExtractResponse.self) {
                self = .extract(extractResponse)
                return
            }

            // If above cases fail, try to decode as plain text (ScrapeResponse)
            if let scrapeResponse = try? container.decode(String.self) {
                self = .scrape(scrapeResponse)
                return
            }

            // If all decoding attempts fail, throw an error
            throw DecodingError.typeMismatch(ServiceResponse.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Mismatched Types"))
        }
    }




    private let options: Options

    init(options: Options) {
        self.options = options
    }
    
    private func encodeUrl(for siteUrl: String) -> String {
        // Define the character set of characters to be allowed in the URI
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        // Ensure that siteUrl is correctly percent-encoded
        let encodedString = siteUrl.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        
        return encodedString ?? ""
    }

    private func getSiteInfoUrl(for url: String) -> URL {
        let encodedUrl = encodeUrl(for: url);
        
        let proto = self.options.appId.isEmpty ? "http" : "https"
        return URL(string: "\(proto)://opengraph.io/api/\(self.options.version)/\(self.options.service)/\(encodedUrl)")!
    }

    private func getSiteInfoQueryParams() -> [String: Any] {
        var queryStringValues: [String: Any] = [
            "app_id": self.options.appId,
            "cache_ok": self.options.cacheOk ? "true" : "false"
        ]
        
        if self.options.useProxy {
            queryStringValues["use_proxy"] = "true"
        }
        
        if self.options.fullRender {
            queryStringValues["full_render"] = "true"
        }

        if let maxCacheAge = self.options.maxCacheAge {
            queryStringValues["max_cache_age"] = "\(maxCacheAge)"
        }

        if let acceptLang = self.options.acceptLang {
            queryStringValues["accept_lang"] = acceptLang
        }

        if let htmlElements = self.options.htmlElements {
            queryStringValues["html_elements"] = htmlElements
        }

        return queryStringValues
    }

    func getSiteInfo(for url: String, completion: @escaping (Result<ServiceResponse, Error>) -> Void) {
        let siteInfoUrl = getSiteInfoUrl(for: url)
        var urlComponents = URLComponents(url: siteInfoUrl, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = getSiteInfoQueryParams().map { URLQueryItem(name: $0.key, value: "\($0.value)") }

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        

        URLSession.shared.dataTask(with: request) { data, response, error in
            // Log error
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            if let data = data {
                // Check if the content type is text/plain
                if let mimeType = response?.mimeType, mimeType == "text/plain" {
                    if let textData = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            completion(.success(.scrape(textData)))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Failed to decode plain text"])))
                        }
                    }
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(ServiceResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"])))
                }
            }
        }.resume()
    }

}

