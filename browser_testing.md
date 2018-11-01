Semaphore includes Chrome, Firefox, and an xvfb out of the box. Chrome
and Firefox both support headless mode. You shouldn't need to do more
than install the relevant selenium library and configure it.

## Node

Install the
[selenium-webdriver-](https://www.npmjs.com/package/selenium-webdriver)
library and it should work out of the box, same goes for higher level
libraries that leverage selenium. See the official [Node
exmaples](https://github.com/SeleniumHQ/selenium/tree/master/javascript/node/selenium-webdriver/example).

## Ruby

[Capybara](http://teamcapybara.github.io/capybara) is the best
solution for browser tests in Ruby. The Firefox, Chrome, and Chrome
Headless drivers work out of the box.

## Other Languages

Official selenium libraries are available for Java, C#, and Python.
Refer to those docs and associated libraries to configure your poject.
