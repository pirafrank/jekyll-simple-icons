# Jekyll AI Related

[![Gem Version](https://img.shields.io/gem/v/jekyll-simple-icons)](https://rubygems.org/gems/jekyll-simple-icons)
[![GitHub Release](https://img.shields.io/github/v/release/pirafrank/jekyll-simple-icons)](https://github.com/pirafrank/jekyll-simple-icons/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A [Jekyll](https://jekyllrb.com/) [command](https://jekyllrb.com/docs/plugins/commands/) plugin to generate list of related posts using AI.

The plugin uses uses OpenAI API to generate embeddings from posts content, and stores them on Supabase vector database. A query on Supabase provides a similarity score between the post and all other posts on the site. The plugin then selects the most similar posts to generate the list of related posts.

To avoid unnecessary API calls or slowing down the website generation, the plugin stores the list of related posts in the site's `_data` folder. This way you can `jekyll build` without calling the plugin or making API calls, while still having the list of related posts available as site data. You only need to re-run it when you add or update posts.

## Getting started

1. Setup Supabase
2. Install the plugin
3. Configure the plugin
4. Run the plugin

## Requirements

- OpenAI account and API key
- Supabase account and API key
- Supabase URL of the project where the DB is located

### Supabase setup

Use the `create.sql` script in the `sql\supabase` folder of this repo to create the required table and functions on your Supabase project. You can run the script in the SQL editor of the Supabase dashboard.

You can always revert the changes by running the `drop.sql` script.

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

## Configuration

Sample configuration to add to your `_config.yml`:

```yaml
jekyll-simple-icons:
  post_unique_field: slug
  post_updated_field: date
  output_path: related_posts
  include_drafts: false
  include_future: false
  related_posts_limit: 3
  related_posts_score_threshold: 0.5
  precision: 3
  db_table: page_embeddings
  db_function: cosine_similarity
```

Configuration is optional. The plugin will use the default values if not provided.

### Configuration options

| Option | Type | Description | Default Value |
| --- | --- | --- | --- |
| `post_unique_field` | string | A field that uniquely identifies a post | `slug` |
| `post_updated_field` | string | A field that indicates when the post was last updated | `date` |
| `output_path` | string | The subdir inside `_data` where related posts will be stored | `related_posts` |
| `include_drafts` | boolean | Whether to include drafts in the list of related posts | `false` |
| `include_future` | boolean | Whether to include future posts in the list of related posts | `false` |
| `related_posts_limit` | integer | The maximum number of related posts to extract per post | `3` |
| `related_posts_score_threshold` | float | The minimum similarity score to consider a post related | `0.5` |
| `precision` | integer | The number of decimal digits to round similarity scores to | `3` |
| `db_table` | string | The name of the table where the embeddings are stored | `page_embeddings` |
| `db_function` | string | The name of the function to calculate similarity scores | `cosine_similarity` |

> [!NOTE]
> `related_posts_limit` and `related_posts_score_threshold` are used to filter the list of related posts. The plugin will return the top `related_posts_limit` posts with a similarity score greater than `related_posts_score_threshold`. A post may have 0 or more than `related_posts_limit` related posts, but only the top `related_posts_limit` will be returned, if any.

### Advanced configuration

You can customize the unique and updated fields, for example if you have a plugin that generates a unique ID for each post, or if you have a custom field that indicates when the post was last updated.

Check the [post-metadata.rb](https://github.com/pirafrank/fpiracom/blob/8cc17a5801a73f7c8cbad4cbee099db18389b187/_plugins/post-metadata.rb) plugin of mine for an example. You can download and place it in your `_plugins` folder. It will add metadata to each `post` object and makes it accessible anywhere the `post` object is.

If you do so, you could use the following configuration:

```yaml
jekyll-simple-icons:
  post_unique_field: uid
  post_updated_field: most_recent_edit
```

## Usage

To run, the plugin needs the OpenAI and Supabase API keys, and Supabase URL. The plugin expects them as environment variables.

```sh
export OPENAI_API_KEY="your_openai_api_key"
export SUPABASE_URL="your_supabase_url"
export SUPABASE_KEY="your_supabase_api_key"
```

Never write API keys in your code or configuration files you commit.

Then you can run the plugin with:

```sh
bundle exec jekyll related
```

> [!IMPORTANT]
> Re-run the plugin whenever you add or update posts to update the list of related posts. Only posts with a `post_updated_field` date greater than the last run will be processed.

### Options

You can pass options to the plugin to change its behavior. Options are passed after the command name. Not specifying an option is the same as specifying the default value.

| Option | Description | Default |
| --- | --- | --- |
| `--debug` | Most verbose. Sets log level to Debug. | Jekyll default |
| `--quiet` | Do not print Info logs. Sets log level to Error. | Jekyll default |
| `--future` | Generate embeddings and find related posts also for those with a future date. | `false` |
| `--drafts` | Generate embeddings and find related posts also for drafts. | `false` |
| `--dry-run` | Do not update the database, do not write related posts to disk. | `false` |

Example:

```sh
bundle exec jekyll related --dry-run --future
```

### Environments

Jekyll AI Related can optionally use the `JEKYLL_ENV` environment variable to determine where is running. This allows you to have separate tables and functions for different environments, for example for development and production.

When `JEKYLL_ENV` is set, the plugin will append its value to `db_table` and `db_function` configuration options, separated by a `_` character. If it is not set, the plugin won't append anything. You must set `JEKYLL_ENV` every time you run the plugin to use environments.

> [!IMPORTANT]
> You need to make sure you have the corresponding tables and functions on your Supabase project. Edit the committed SQL script accordingly. They work with no modification when `JEKYLL_ENV` is not set.

For example, if you `export JEKYLL_ENV=production` and have the configuration below

```yaml
jekyll-simple-icons:
  db_table: cool_table_name
  db_function: cool_function_name
```

the plugin will use:

- `cool_table_name_production` as the database table name,
- `cool_function_name_production` as the database function name.

> [!TIP]
> Explicitly declare `JEKYLL_ENV=production` to avoid overwriting production data by mistake.

## Jekyll integration

The plugin generates a list of related posts for each post in the site. Yet it won't edit your posts or layouts to display the list. It's up to you to integrate it in your site.

You can access the list in the `site.data.YOUR_output_path_NAME` object. For example, with the default settings you can access it with `site.data.related_posts[post.slug]`.

Here's a snippet to add it to the bottom of your `_layouts/post.html` layout file. It works with the default configuration.

```html
{% if site.data.related_posts[page.slug] %}
<div class="related-posts">
  <h3>Related Posts</h3>
  <ul>
    {% for post in site.data.related_posts[page.slug] %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
      <br/>{{ post.date | date: "%B %d, %Y" }}
    </li>
    {% endfor %}
  </ul>
</div>
{% endif %}
```

> [!NOTE]
> The plugin writes posts in descending order of similarity score, from most similar to least similar. You can change the order by reversing the loop in the snippet above.

## Development

Clone and run `bundle install` to get started.

Code lives in `lib/jekyll` directory. `lib/jekyll/commands/generator.rb` is the entry point of the plugin, as per Jekyll documentation. More details [here](https://jekyllrb.com/docs/plugins/commands/).

## Contributing

[Bug reports](https://github.com/pirafrank/jekyll-simple-icons/issues) and [pull requests](https://github.com/pirafrank/jekyll-simple-icons/pulls) are welcome on GitHub.

## Code of Conduct

Everyone interacting in the project's codebase, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pirafrank/jekyll-simple-icons/blob/main/CODE_OF_CONDUCT.md).

## Guarantee

This plugin is provided as is, without any guarantee. Use at your own risk.

## Disclaimer

This plugin uses OpenAI API and Supabase, and you are responsible for complying with their respective terms of service. This plugin is not affiliated with OpenAI or Supabase.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
