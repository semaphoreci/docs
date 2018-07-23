## Introduction

The purpose of this document is to help understand how you can manage
Semaphore 2.0 projects with the  `sem` command line utility.

## Using sem for working with projects

The `sem` command can help you manage Semaphore 2.0 projects, which
among other things includes creating a new Semaphore 2.0 project without
having to visit the web interface of Semaphore 2.0. However, you still
need to visit the web interface of Semaphore 2.0 in order to see the
results of a project!

###  Using sem init to create a new Semaphore 2.0 project

Although you can use the technique described in the next section for
creating a new project,  `sem` can automate things for you with the help
of the `sem init` command. The steps for using the `sem init` command
are the following:

    $ git clone git@github.com:mactsouk/S2.git
    Cloning into 'S2'...
    remote: Counting objects: 76, done.
    remote: Compressing objects: 100% (55/55), done.
    remote: Total 76 (delta 28), reused 56 (delta 14), pack-reused 0
    Receiving objects: 100% (76/76), 9.24 KiB | 4.62 MiB/s, done.
    Resolving deltas: 100% (28/28), done.
    $ cd S2
    $ ls -al
    total 24
    drwxr-xr-x   6 mtsouk  staff   192 Jul  2 16:01 .
    drwxr-xr-x@ 12 mtsouk  staff   384 Jul  2 16:01 ..
    drwxr-xr-x  13 mtsouk  staff   416 Jul  2 16:01 .git
    -rw-r--r--   1 mtsouk  staff  1089 Jul  2 16:01 .semaphore.yml
    -rw-r--r--   1 mtsouk  staff    34 Jul  2 16:01 README.md
    -rw-r--r--   1 mtsouk  staff   161 Jul  2 16:01 hw.go
    $ mv .semaphore/semaphore.yml semaphore.yml
    $ sem init
    Project is created. You can find it at https://tsoukalos.semaphoreci.com/projects/S2.
    
    To run your first pipeline execute:
    
      git add .semaphore.yml && git commit -m "First pipeline" && git push
    
    $ sem get projects S2
    NAME
    anotherSecret
    secrets
    S2
    S1

So, you first have to execute `git clone` in order to get a local copy
of the project that interests you.

The  `mv` command is needed at this point because `sem init` will not
work if a `.semaphore/semaphore.yml` file already exists in directory of
the project you are trying to add to Semaphore 2.0.

Then, you need to execute the `sem init` command without any other
parameters and the `sem init` command will do the rest! Also, note that
`sem init` creates a sample `.semaphore/semaphore.yml` file for you.

The output of `sem get projects` verifies that the S2 project was
successfully created.

Please notice that creating a new Semaphore 2.0 project will not
automatically begin a pipeline run for you. This will happen after your
first commit to the relevant GitHub repository.

### Creating a new Semaphore 2.0 project with a YAML file

The `sem` command also allows you to specify the parameters of a
Semaphore 2.0 project using a YAML file.

The contents of the `S2.yml` file used in this section are as follows:

    $ cat S2.yml
    apiVersion: v1alpha
    kind: Project
    metadata:
      name: S2
    spec:
      repository:
        url: "git@github.com:mactsouk/S2.git"

So, you need to define the name of the new Semaphore 2.0 project as well
as the URL of the git repository you want to use on your project. The
others contents of the file will not need to change.

The `sem` command for creating a new project is the following:

    $ sem create -f S2.yml

If the Semaphore 2.0 project is new and is successfully created, the
output you will get will be similar to the following:

    $ sem create -f S2.yml
    metadata:
      id: d1f19c13-cd3a-43fe-a61e-0ce19842d15a
      name: S2
    spec:
      repository:
        url: git@github.com:mactsouk/S2.git
    
    $ sem get projects
    NAME
    anotherSecret
    secrets
    S2
    S1

If you Semaphore 2.0 project you are trying to create already exists,
you will get an output from the `sem` command that looks like the
following:

    $ sem create -f S2.yml
    message: 'project S2 not created: #<ActiveModel::Errors:0x0000564b06f6dbd0 @base=#<Project
      id: nil, name: "S2", created_at: nil, updated_at: nil, slug: nil, creator_id: "2624740c-36fc-461e-b3ff-90d937958f0f",
      cache_version: nil, organization_id: "60885122-9306-418f-81da-932a1415d1e6", cache_id:
      nil>, @messages={:name=>["has already been taken"]}>'
    
    $ sem -v create -f S2.yml
    2018/06/26 18:13:48 https://tsoukalos.semaphoreci.com/api/v1alpha/projects
    2018/06/26 18:13:49 response Status: 422 Unprocessable Entity
    2018/06/26 18:13:49 response Headers: map[Cache-Control:[max-age=0, private, must-revalidate] Content-Length:[360] Date:[Tue, 26 Jun 2018 15:13:48 GMT] Server:[envoy] X-Envoy-Upstream-Service-Time:[506] Via:[1.1 google] Alt-Svc:[clear]]
    2018/06/26 18:13:49 {"message":"project S2 not created: #<ActiveModel::Errors:0x0000564b06d67c00 @base=#<Project id: nil, name: \"S2\", created_at: nil, updated_at: nil, slug: nil, creator_id: \"2624740c-36fc-461e-b3ff-90d937958f0f\", cache_version: nil, organization_id: \"60885122-9306-418f-81da-932a1415d1e6\", cache_id: nil>, @messages={:name=>[\"has already been taken\"]}>"}
    message: 'project S2 not created: #<ActiveModel::Errors:0x0000564b06d67c00 @base=#<Project
      id: nil, name: "S2", created_at: nil, updated_at: nil, slug: nil, creator_id: "2624740c-36fc-461e-b3ff-90d937958f0f",
      cache_version: nil, organization_id: "60885122-9306-418f-81da-932a1415d1e6", cache_id:
      nil>, @messages={:name=>["has already been taken"]}>'

The point of the output from the previous two commands is that the
project name you are trying to create `has already been taken`.

### Listing existing Semaphore 2.0 projects with sem

The `sem` command can also help you list the projects of the
organization that is currently active:

    $ sem get projects
    NAME
    S2
    anotherSecret
    secrets
    S1

The previous output shows that you currently have four projects under
the active Semaphore 2.0 organization that is defined in the `.sem.yaml`
file.

If your organization contains no projects, the output you will get will
look like the following:

    $ sem get projects
    NAME

### Deleting an existing Semaphore 2.0 project with sem

The  `sem` command can also be used for deleting a Semaphore 2.0
project. You should execute the `sem delete project` command followed by
the name of the project:

    $ sem get projects
    NAME
    S2
    anotherSecret
    secrets
    S1
    $ sem delete project S2
    project "S2" deleted
    $ sem get projects
    NAME
    anotherSecret
    secrets
    S1

Notice that deleting a project from Semaphore 2.0 will not delete the
files of the relevant GitHub repository.

If the project you are trying to delete does not exist, you will get the
following kind of output:

    $ sem delete project S2
    failed to delete secret "S2"

### Getting information about existing Semaphore 2.0 projects

The   `sem` utility can give you information about existing Semaphore
2.0 projects as follows:

    $ sem describe projects S2
    metadata:
      id: be0ce5eb-ddd4-4756-93f5-9c1dbd73dccd
      name: S2
    spec:
      repository:
        url: git@github.com:mactsouk/S2.git

Please note that the  `sem describe projects S2` command can be also
executed as `sem describe project S2` – these two command are completely
equivalent.

The following command can help you get information about all the
projects of the current organization as defined in the `.sem.yaml` file:

    $ sem get projects | grep -v NAME | xargs -n1 sem describe projects

In the case of tsoukalos.semaphoreci.com, its output will be as follows:

    $ sem get projects | grep -v NAME | xargs -n1 sem describe projects
    metadata:
      id: db771414-92e4-4048-a8be-4b8c1bb33204
      name: anotherSecret
    spec:
      repository:
        url: git@github.com:mactsouk/anotherSecret.git
    
    
    metadata:
      id: 9008e872-5a96-4a58-a194-4f5e65a80e89
      name: secrets
    spec:
      repository:
        url: git@github.com:mactsouk/secrets.git
    
    
    metadata:
      id: 0ad6987e-a785-4cab-9bde-0734a2ce2c4f
      name: S1
    spec:
      repository:
        url: git@github.com:mactsouk/S1.git

Another variation of the script will be displaying the GitHub
repositories only, which can happen with the help of the `grep` command:

    $ sem get projects | grep -v NAME | xargs -n1 sem describe projects | grep url:    
        url: git@github.com:mactsouk/anotherSecret.git
        url: git@github.com:mactsouk/secrets.git
        url: git@github.com:mactsouk/S1.git

If you want both the name of the project and the name of the GitHub
repository, you can execute the following command from a bash shell:

    $ sem get projects | grep -v NAME | xargs -n1 sem describe projects | grep 'name\|url'
      name: anotherSecret
        url: git@github.com:mactsouk/anotherSecret.git
      name: secrets
        url: git@github.com:mactsouk/secrets.git
      name: S1
        url: git@github.com:mactsouk/S1.git

If the project you are trying to learn more about does not exist, you
will get the following kind of output from the `sem` utility:

    $ sem describe projects S21
    error: http status 404 with message "{"message":"Not found"}" received from upstream

## Using sem for working with secrets

The `sem` command can also help you work with `secrets`. You can learn
more information about `sem` and working with `secrets` by visiting the
documentation page that talks about [secrets][1].

### What if there is a server error?

In that rare case, you will see an error message similar to the
following:

    $ sem get projects
    error: http status 502 with message "
    <html><head>
    <meta http-equiv="content-type" content="text/html;charset=utf-8">
    <title>502 Server Error</title>
    </head>
    <body text=#000000 bgcolor=#ffffff>
    <h1>Error: Server Error</h1>
    <h2>The server encountered a temporary error and could not complete your request.<p>Please try again in 30 seconds.</h2>
    <h2></h2>
    </body></html>
    " received from upstream



[1]: https://docs.semaphoreci.com/article/15-secrets
