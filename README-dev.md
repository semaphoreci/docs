# Managing pages

Docs are self hosted. The following instructions apply for Semaphore team members:

## Creating new file

- Create file in repository `article-name`, example: `getting-started.md` 
- In [mkdocs.yml](https://github.com/semaphoreci/docs/blob/master/mkdocs.yml), add the new article to the right category, e.g: `Getting started: guided-tour/getting-started.md`
- Every docs article must have an H1 which should correspond to its name in the mkdocs.yml file.
  

## Updating existing files

Updating existing files is done by entering a given file and modifying it.


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
