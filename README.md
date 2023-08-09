# OpenGraphIo Swift Client (v1.0.0)


This is the official [OpenGraph.io](https://www.opengraph.io/) client library for Swift. Provide a URL, and this client will send an HTTP request to the OpenGraph.io API to scrape a site for OpenGraph tags. If any tags are discovered, they'll be sent back to you.

When certain tags are absent, the client tries to deduce them from the website's content. These inferred tags are part of the `hybridGraph`. 

The `hybridGraph` always defaults to the OpenGraph tags found on the site. If only some or no tags are detected, missing tags will be deduced from the website's content.

Sign up at [OpenGraph.io](https://www.opengraph.io/) for a free key. Most projects will be covered by our affordable plans. Customized plans can be provided upon request.

## Installation

To integrate the OpenGraph.io Swift client:

1. Add the following dependency in your `Podfile`:

   ```bash
   pod 'OpenGraphIoSwiftClient', '~> 1.0.0'
   ```

## Usage

This library offers an OpenGraphIO class. You can instantiate it using the necessary options. Here's how you can use it:

```swift
import OpenGraphIoSwiftClient

let options = OpenGraphIO.Options(
  appId: "YOUR_APP_ID",  // Get your free OpenGraph.io App ID at https://www.opengraph.io/
  service: "site", // Choose from: site, extract, scrape. Default Value is 'site'
  cacheOk: true, // Default Value if you do not provide one
  useProxy: false, // Default Value if you do not provide one
  maxCacheAge: 432000000, // Default Value if you do not provide one
  acceptLang: "en-US", // Default Value if you do not provide one
  fullRender: false, // Default Value if you do not provide one
  htmlElements: "h1,h2,h3,p", // Default Value if you do not provide one
)

let ogClient = OpenGraphIO(options: options)


```
The options shown above are the default options.  To understand more about these parameters, please view our documentation at: https://www.opengraph.io/documentation/ 

You can override the options provided during initialization by specifying parameters when invoking the ``getSiteInfo`` function.
        
### Retrieving Open Graph Data
To retrieve Open Graph data for a specific URL, you can use the ``getSiteInfo`` method.

```swift
import OpenGraphIoSwiftClient

let options = OpenGraphIO.Options(
  appId: "YOUR_APP_ID",  // Get your free OpenGraph.io App ID at https://www.opengraph.io/
)

let ogClient = OpenGraphIO(options: options)

ogClient.getSiteInfo(for: "https://www.example.com") { result in
    switch result {
    case .success(let siteResponse):
        print("Title:", siteResponse.hybridGraph.title ?? "N/A")
        print("Description:", siteResponse.hybridGraph.description ?? "N/A")
        print("Image URL:", siteResponse.hybridGraph.image?.absoluteString ?? "N/A")
    case .failure(let error):
        print("Error fetching site info:", error)
    }
}
```


### OpenGraphIO Services
Service Options: `site`, `extract`, `scrape`

#### Site Service
Unleash the power of our Unfurling API to effortlessly extract Open Graph tags from any URL.

```swift
import OpenGraphIoSwiftClient

let options = OpenGraphIO.Options(
  appId: "YOUR_APP_ID",  // Get your free OpenGraph.io App ID at https://www.opengraph.io/
)

let ogClient = OpenGraphIO(options: options)

ogClient.getSiteInfo(for: "https://www.example.com") { result in
    switch result {
    case .success(let siteResponse):
        print("Title:", siteResponse.hybridGraph.title ?? "N/A")
        print("Description:", siteResponse.hybridGraph.description ?? "N/A")
        print("Image URL:", siteResponse.hybridGraph.image?.absoluteString ?? "N/A")
    case .failure(let error):
        print("Error fetching site info:", error)
    }
}
```

##### Options

| Parameter   | Required | Example | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
|-------------|----------|---------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| appId       | yes      | -       | The API key for registered users. Create an account (no cc ever required) to receive your `app_id`.                                                                                                                                                                                                                                                                                                                                                                                    |
| cacheOk     | no       | false   | This will force our servers to pull a fresh version of the site being requested. By default, this value is true.                                                                                                                                                                                                                                                                                                                                                                       |
| fullRender  | no       | false   | This will fully render the site using a chrome browser before parsing its contents. This is especially helpful for single page applications and JS redirects. This will slow down the time it takes to get a response by around 1.5 seconds.                                                                                                                                                                                                                                           |
| useProxy    | no       | false   | Route your request through residential and mobile proxies to avoid bot detection. This will slow down requests 3-10 seconds and can cause requests to time out. NOTE: Proxies are a limited resource and expensive for our team maintain. Free accounts share a small pool of proxies. If you plan on using proxies often, paid accounts provide dedicated concurrent proxies for your account.                                                                                        |
| maxCacheAge | no       | 432000000 | This specifies the maximum age in milliseconds that a cached response should be. If not specified, the value is set to 5 days. (5 days * 24 hours * 60 minutes * 60 seconds * 1000ms = 432,000,000 ms)                                                                                                                                                                                                                                                                                 |
| acceptLang  | no       | en-US,en;q=0.9 auto | This specifies the request language sent when requesting the URL. This is useful if you want to get the site for languages other than English. The default setting for this will return an English version of a page if it exists. Note: if you specify the value auto, the API will use the same language settings as your current request. For more information on what to supply for this field, please see: [Accept-Language - MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept-Language) |

#### Extract Service
Unleash the power of our Extract API to effortlessly extract HTML tags from any URL.

```swift
import OpenGraphIoSwiftClient

let extractOptions = OpenGraphIO.Options(
  appId: "YOUR_APP_ID",  // Get your free OpenGraph.io App ID at https://www.opengraph.io/
  service: "extract",
  htmlElements: "h1,h2,p"
)
let extractClient = OpenGraphIO(options: extractOptions)

extractClient.getSiteInfo(for: "https://www.example.com") { result in
    switch result {
    case .success(let serviceResponse):
        switch serviceResponse {
        case .extract(let extractResponse):
            for tag in extractResponse.tags {
                print("\(tag.tag): \(tag.innerText) at position \(tag.position)")
            }
        default:
            break
        }
    case .failure(let error):
        print("Error extracting tags:", error)
    }
}

```

##### Options

| Parameter    | Required | Example             | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
|--------------|----------|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| appId        | yes      | -                   | The API key for registered users. Create an account (no cc ever required) to receive your `app_id`.                                                                                                                                                                                                                                                                                                                                                                                    |
| htmlElements | no       | h1,h2,p             | This is an optional parameter and specifies the HTML elements you want to extract from the website. The value should be a comma-separated list of HTML element names. If this parameter is not supplied, the default elements that will be extracted are h1, h2, h3, h4, h5, p, and title.                                                                                                                                                                                                                                                                                                                                                                                  |
| cacheOk      | no       | false               | This will force our servers to pull a fresh version of the site being requested. By default, this value is true.                                                                                                                                                                                                                                                                                                                                                                       |
| fullRender   | no       | false               | This will fully render the site using a chrome browser before parsing its contents. This is especially helpful for single page applications and JS redirects. This will slow down the time it takes to get a response by around 1.5 seconds.                                                                                                                                                                                                                                           |
| useProxy     | no       | false               | Route your request through residential and mobile proxies to avoid bot detection. This will slow down requests 3-10 seconds and can cause requests to time out. NOTE: Proxies are a limited resource and expensive for our team maintain. Free accounts share a small pool of proxies. If you plan on using proxies often, paid accounts provide dedicated concurrent proxies for your account.                                                                                        |
| maxCacheAge  | no       | 432000000           | This specifies the maximum age in milliseconds that a cached response should be. If not specified, the value is set to 5 days. (5 days * 24 hours * 60 minutes * 60 seconds * 1000ms = 432,000,000 ms)                                                                                                                                                                                                                                                                                 |
| acceptLang   | no       | en-US,en;q=0.9 auto | This specifies the request language sent when requesting the URL. This is useful if you want to get the site for languages other than English. The default setting for this will return an English version of a page if it exists. Note: if you specify the value auto, the API will use the same language settings as your current request. For more information on what to supply for this field, please see: [Accept-Language - MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept-Language) |

#### Scraper Service
Unleash the power of our Scrape API to effortlessly extract just the raw HTML from any URL.


```swift
let scrapeOptions = OpenGraphIO.Options(appId: "YOUR_APP_ID_HERE", service: "scrape")
let scrapeClient = OpenGraphIO(options: scrapeOptions)

scrapeClient.getSiteInfo(for: "https://www.example.com") { result in
    switch result {
    case .success(let serviceResponse):
        switch serviceResponse {
        case .scrape(let scrapeResponse):
            print("Scraped content:", scrapeResponse ?? "N/A")
        default:
            break
        }
    case .failure(let error):
        print("Error scraping content:", error)
    }
}
```

##### Options

| Parameter    | Required | Example             | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
|--------------|----------|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| appId        | yes      | -                   | The API key for registered users. Create an account (no cc ever required) to receive your `app_id`.                                                                                                                                                                                                                                                                                                                                                                                    |
| cacheOk      | no       | false               | This will force our servers to pull a fresh version of the site being requested. By default, this value is true.                                                                                                                                                                                                                                                                                                                                                                       |
| fullRender   | no       | false               | This will fully render the site using a chrome browser before parsing its contents. This is especially helpful for single page applications and JS redirects. This will slow down the time it takes to get a response by around 1.5 seconds.                                                                                                                                                                                                                                           |
| useProxy     | no       | false               | Route your request through residential and mobile proxies to avoid bot detection. This will slow down requests 3-10 seconds and can cause requests to time out. NOTE: Proxies are a limited resource and expensive for our team maintain. Free accounts share a small pool of proxies. If you plan on using proxies often, paid accounts provide dedicated concurrent proxies for your account.                                                                                        |
| maxCacheAge  | no       | 432000000           | This specifies the maximum age in milliseconds that a cached response should be. If not specified, the value is set to 5 days. (5 days * 24 hours * 60 minutes * 60 seconds * 1000ms = 432,000,000 ms)                                                                                                                                                                                                                                                                                 |
| acceptLang   | no       | en-US,en;q=0.9 auto | This specifies the request language sent when requesting the URL. This is useful if you want to get the site for languages other than English. The default setting for this will return an English version of a page if it exists. Note: if you specify the value auto, the API will use the same language settings as your current request. For more information on what to supply for this field, please see: [Accept-Language - MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept-Language) |


## Support

Feel free to reach out at any time with questions or suggestions by adding to the issues for this repo or if you'd 
prefer, head over to [https://www.opengraph.io/support/](https://www.opengraph.io/support/) and drop us a line!

## License

MIT License

Copyright (c)  Opengraph.io

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
