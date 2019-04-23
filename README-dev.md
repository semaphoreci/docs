# Managing pages

Docs are hosted on Help Scout. Changes are continuously deployed via
Semaphore to the live website.

The following instructions apply for Semaphore team members with access
to Help Scout:

## Creating new file

- Create a file in HelpScout docs
  - HelpScout will assign a new URL for the page which we'll use for next step, for example `https://docs.semaphoreci.com/article/33-example?preview=5b4699632c7d3a099f2e742a`. You can use that URL, sans the `?preview=...` part, to create links to the new page.
- Create file in repository `just-example_5b4699632c7d3a099f2e742a.md`
  - `5b4699632c7d3a099f2e742a` is `id` of specific article
  - `just-example` is article's `slug`

## Updating existing files

When [HelpScout Docs token] is in place, executing `deploy_docs.rb` script will
[update] every article which meets the following:

- It is in the project root directory
- It is a markdown file associated with an article in HelpScout Docs
- It is named in the following form `article-name_21323321.md`.
  - `21323321` in this example represents `id` of article in HelpScout Docs
  - `id` is included in the article's URL (`https://secure.helpscout.net/docs/xxxxxxx/article/21323321/`)

## Development

### Managing assets

Semaphore team is using a private repository [public-assets]
to store CSS, JS and image files.

### Install dependencies

Currently, script depends on [redcarpet] gem.
It can be installed with the following command

``` bash
gem install redcarpet
```

### Set up secret

- `cp docs_secrets.yml.example docs_secrets.yml`
- update this file with your HelpScout Docs API Key

### Set up project on Semaphore

- add project to an org with `sem`
- propagate secret to Semaphore with `sem`

[HelpScout Docs token]: https://developer.helpscout.com/docs-api/
[redcarpet]: https://github.com/vmg/redcarpet
[update]: https://developer.helpscout.com/docs-api/articles/update/
[public-assets]: https://github.com/renderedtext/public-assets
