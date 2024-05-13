# Semaphore Docs

This website is built using [Docusaurus](https://docusaurus.io/), a modern static website generator.

## Installation

```shell
npm install
```

## Local Development

```shell
npm start
```

This command starts a local development server and opens up a browser window. Most changes are reflected live without having to restart the server.

## How to add a category

To add new category in the top navbar:
1. Open `docusaurus.config.js`
2. Go to `config.themeConfig.navbar.items`. Add your category.
    ```js
            {
                type: 'docSidebar',
                sidebarId: 'yourSidebarId',
                position: 'left',
                label: 'The top navbar label',
            },
    ```

## How to add a item on the sidebar

To add a item in the sidebar:
1. Writer your document (eg `folder/item2.md` )
2. Open `sidebars.js` 
3. Go to `sidebars.yourSidebarId` 
4. To add an item, add it to `items`. Remove the `.md` from the filename
    ```js
    items: [ 'folder/item1', 'folder/item2' ]
    ```

## How to add a new sidebar 

To add a new sidebar (because you added a category):
1. Write your documents (eg `folder/item1.md` and `folder/item2.md`)
2. Open `sidebars.js` 
3. Go to `sidebars.yourSidebarId` 
4. To add an sidebar your the items.
    ```js
    yourSidebarId: [
        {
        type: 'category',
        label: 'Your Category Label',
        link: {
            type: 'generated-index',
            title: 'Your title for the category page',
            description: 'Your description to the category page',
            keywords: ['your', 'keywords'],
        },
        items: ['folder/item1', 'folder/item2' ],
        },
    ],
    ```

## Lint

We use [markdownlint](https://github.com/DavidAnson/markdownlint-cli2) to check Markdown files for style errors.

Run the linter before commiting:
```shell
npm run lint
```

## Build

```shell
npm run build
npn run serve
```

This command generates static content into the `build` directory and can be served using any static contents hosting service.

## Deployment

Using SSH:

```shell
USE_SSH=true npm run deploy
```

Not using SSH:

```shell
GIT_USER=<Your GitHub username> npm run deploy
```

If you are using GitHub pages for hosting, this command is a convenient way to build the website and push to the `gh-pages` branch.


## Plugins

Extra Plugins/Packages needed:
- [@easyops-cn/docusaurus-search-local](https://github.com/easyops-cn/docusaurus-search-local)
