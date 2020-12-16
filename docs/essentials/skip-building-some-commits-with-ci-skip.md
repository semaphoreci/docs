---
description: If you'd like your commit, or a series of commits that you're pushing, to not trigger a build, write [ci skip] or [skip ci] somewhere in your commit's message.
---

# Skip Building Some Commits with [ci skip]

If you'd like your commit, or a series of commits that you're pushing, to not
trigger a build, just write `[ci skip]` or `[skip ci]` somewhere in your 
commit's message.

!!! info "Usage with squashed commits"
	When squashing commits before merging in another branch all commit messages will be merged as well. If a previous commit in the current branch contains `[ci skip]` or `[skip ci]` it will be propagated and the merged commit will not build.
