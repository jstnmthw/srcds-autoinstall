# How to contribute

Support and contributions from the open source community are essential for keeping
`srcds-autoinstall` up to date and always improving! There are a few guidelines that we need
contributors to follow to keep the project consistent, as well as allow us to keep
maintaining `srcds-autoinstall` in a reasonable amount of time.

Please note that this project is released with a [Contributor Code of Conduct][coc].
By participating in this project you agree to abide by its terms.

[coc]: ./CODE_OF_CONDUCT.md

## Creating an Issue

Before you create a new Issue:

1. Please make sure there is no [open issue](https://github.com/jstnmthw/srcds-autoinstall/issues?utf8=%E2%9C%93&q=is%3Aissue) yet.
2. If it is a bug report, include the steps to reproduce the issue and please create a reproducible test case.
3. If it is a feature request, please share the motivation for the new feature and how you would implement it.
4. Please include links to the corresponding documentation.

## Tests

If you want to submit a bug fix or new feature, make sure that all tests are passing.

Before running any tests you have to [build the binary](https://github.com/jstnmthw/srcds-autoinstall/README.md#build).

```
$ ./scripts/build.sh
```

## Making Changes

- Create a topic branch from the main branch.
- Check for unnecessary whitespace / changes with `git diff --check` before committing.
- Keep git commit messages clear and appropriate. Ideally follow commit conventions described below.

## Submitting the Pull Request

- Push your changes to your topic branch on your fork of the repo.
- Submit a pull request from your topic branch to the main branch on the `srcds-autoinstall` repository.
- Be sure to tag any issues your pull request is taking care of / contributing to. \* Adding "Closes #123" to a pull request description will auto close the issue once the pull request is merged in.

## Merging the Pull Request & releasing a new version

Releases are automated using [semantic-release](https://github.com/semantic-release/semantic-release).
The following commit message conventions determine which version is released:

1. `fix: ...` or `fix(scope name): ...` prefix in subject: bumps fix version, e.g. `1.2.3` → `1.2.4`
2. `feat: ...` or `feat(scope name): ...` prefix in subject: bumps feature version, e.g. `1.2.3` → `1.3.0`
3. `BREAKING CHANGE:` in body: bumps breaking version, e.g. `1.2.3` → `2.0.0`

Only one version number is bumped at a time, the highest version change trumps the others.
Besides publishing a new version creates a git tag and release on GitHub, generates changelogs 
from the commit messages and puts them into the release notes.

If the pull request looks good but does not follow the commit conventions, use the "Squash & merge" button.
