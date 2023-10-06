---
Description: If you want a commit or series of commits that you're pushing to not trigger a build, write [ci skip] or [skip ci] somewhere in your commit's message.
---

# Skip Building Some Commits with [ci skip]

If you'd like a commit or series of commits that you're pushing to not
trigger a build, just write `[ci skip]` or `[skip ci]` somewhere in your 
commit's message.

!!! info "Usage with squashed commits"
	When squashing commits before merging in another branch, all commit messages will be merged as well. If a previous commit in the current branch contains `[ci skip]` or `[skip ci]`, it will be propagated and the merged commit will not build.

!!! info "Usage with Tag builds"
	The `[skip ci]` or `[ci skip]` keywords in commit messages are not consistently respected during tag builds. This means that even when `[skip ci]` or `[ci skip]` is included in the commit message, CI/CD builds are still triggered for tag builds.
