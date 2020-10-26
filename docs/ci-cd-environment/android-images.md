Semaphore provides public [docker images for android developement](/ci-cd-environment/semaphore-registry-images/#android) that can be used inside Semaphore enviroment.

Images come in three forms:
- Android:[sdk version]
- Android:[sdk version]-node
- Android:[sdk version]-flutter<br/>
where `sdk-version` can be 25, 26, 27, 28, 29.

For images using stable sdk versions (28,29 for now), we provide cached access.<br/>
The images are updated on a biweekly basis.

As an example using the flutter image, please consult our [flutter example](flutter.md)
