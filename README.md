# CookieSync

Synchronize cookie without blocking UI using transparent SFSafariViewController.

1. `sfSafariViewController.view.alpha = 0.0f;` allows us to prevent `SFSafariViewController` from showing.
2. Redirecting to custom URL schemes allows us to get callbacks from webpages in `SFSafariViewController`.

## Usage

### 0. Throwing 2 files into your code base

Put `KTRCookieSyncManager.h`, `KTRCookieSyncManager.m` into your xcodeproj.

### 1. Create sync url

Create a web page that redirects to custom URL scheme with appending their cookies.

The URL scheme format is as follows.

`any_scheme://sync?token={token}&secret={secret}`

You should get `secret` from hash(`#`) since the library appends the secret key after `#`.

```js
window.location.href = "YOUR_SCHEME://sync?token=PASS_SOME_COOKIES_YOU_WANT&secret=" + location.hash.replace("#", "");
```

### 2. Put `- handleOpenURL` to your `AppDelegate`'s `- application:openURL:options:`

```objc
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return [[KTRCookieSyncManager sharedManager] handleOpenURL:url cookieSyncBlock:^(NSString *synchronizedToken) {
        NSLog(@"%@", synchronizedToken);
    }];
}
```

### 3. Call `- startWithURL:` with the url created at step 1

```objc
[[KTRCookieSyncManager sharedManager] startWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/7817937/______Experiments/SFSafariViewControllerBridge.html"] withViewController:self];
```

### 4. When it finished, `cookieSyncBlock` seen in step 2 code is called

You can see `token` from your web page in step 1.
