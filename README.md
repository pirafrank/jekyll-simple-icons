# Jekyll Simple Icons

[![Gem Version](https://img.shields.io/gem/v/jekyll-simple-icons)](https://rubygems.org/gems/jekyll-simple-icons)
[![GitHub Release](https://img.shields.io/github/v/release/pirafrank/jekyll-simple-icons)](https://github.com/pirafrank/jekyll-simple-icons/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A plugin that makes it easy to incorporate [Simple Icons](https://github.com/simple-icons/simple-icons) into your [Jekyll](https://jekyllrb.com/) website, providing access to a vast collection of popular brands icons.

## Features

- easy to use: just add `{% simpleicons ICON_NAME %}` to your Jekyll page
- natively supports any icon from Simple Icons
- it fetchs icons from the Simple Icons CDN at Jekyll build time for faster page loading of rendered website
- supports all Simple Icons features, like color, height and width
- dark mode support to enable automatic color switching when the browser is set so
- creates an `img` tag with per-icon `alt` attribute for accessibility

## Installation

1. Add the plugin to you Jekyll site's `Gemfile` in the `:jekyll_plugins` group:

```Gemfile
group :jekyll_plugins do
  gem 'jekyll-simple-icons'
end
```

2. Run `bundle install`

### Install from git

Alternatively, you can get code straight from this repository. Code from `main` branch should be stable enough but may contain unreleased software with bugs or breaking changes. Unreleased software should be considered of beta quality.

```Gemfile
group :jekyll_plugins do
  gem 'jekyll-simple-icons', git: 'https://github.com/pirafrank/jekyll-simple-icons', branch: 'main'
end
```

## Update

```sh
bundle update jekyll-simple-icons
```

## Usage

Use the tag as follows:

```liquid
{% simpleicons ICON_NAME %}
```

where `ICON_NAME` is the name of the icon you want to use.

### Options and Defaults

You can optionally specify the `color`, `dark`, `h` (or `height`) and `w` (or `width`) attributes.

Defaults to `color:black h:32 w:32` and `dark` not set.

When the `dark` attribute is specified, the SVG will include a `@media (prefers-color-scheme:dark)` query with the specified color. This enables automatic color switching when the browser is in dark mode.

### Examples

```liquid
{% simpleicons github %}
```

```liquid
{% simpleicons github color:purple dark:cyan %}
```

```liquid
{% simpleicons github color:green h:24 w:24 %}
```

```liquid
{% simpleicons github color:gray dark:purple height:48 width:48 %}
```

## Development

Clone and run `bundle install` to get started.

Code lives in `lib/jekyll` directory. `lib/jekyll-simple-icons/simple_icons.rb` is the entry point of the plugin at Jekyll runtime, as per Jekyll documentation. More details [here](https://jekyllrb.com/docs/plugins/tags/).

## Contributing

[Bug reports](https://github.com/pirafrank/jekyll-simple-icons/issues) and [pull requests](https://github.com/pirafrank/jekyll-simple-icons/pulls) are welcome on GitHub.

## Code of Conduct

Everyone interacting in the project's codebase, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pirafrank/jekyll-simple-icons/blob/main/CODE_OF_CONDUCT.md).

## Guarantee

This plugin is provided as is, without any guarantee.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT). Any contribution intentionally submitted for inclusion in the work by you, as defined in the MIT license, shall be licensed as above, without any additional terms or conditions.

Simple Icons keeps its own license as it is not part of this codebase.
