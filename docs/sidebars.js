/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */

const sidebars = {
  // By default, Docusaurus generates a sidebar from the docs folder structure
  // tutorialSidebar: [{type: 'autogenerated', dirName: '.'}],

  startSidebar: [
    {
      type: 'category',
      label: 'Getting Started',
      link: {
        type: 'generated-index',
        title: 'Get Started',
        description: 'Learn Semaphore in 5 minutes!',
        // slug: '/getting-started',
        keywords: ['getting started'],
        // image: '/img/docusaurus.png',
      },
      items: [
          'getting-started/guided-tour',
          // 'getting-started/concepts',
          'getting-started/continuous-integration',
          'getting-started/continuous-deployment',
          'getting-started/platform-engineering',
        ],
    },
  ],
  coreSidebar: [
    {
      type: 'category',
      label: 'Using Semaphore',
      link: {
        type: 'generated-index',
        title: 'How to use Semaphore',
        description: 'Key concepts and features',
        // slug: '/using-semaphore',
        keywords: ['using semaphore'],
        // image: '/img/docusaurus.png',
      },
      items: [
        'using-semaphore/jobs',
        'using-semaphore/pipelines',
        'using-semaphore/environments',
        'using-semaphore/tasks',
        'using-semaphore/test-reports',
        'using-semaphore/flaky-tests',
        'using-semaphore/observability',
        'using-semaphore/optimization',
        'using-semaphore/account-and-security',
      ],
    },
  ],

};

export default sidebars;
