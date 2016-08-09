# Requirements
## Environment variables
- `RELEASE`: an ubuntu release, e.g., trusty
- `KERNEL`: a kernel release that is supported on `${RELEASE}`, e.g., xenial
- `MAINTAINER`, `EMAIL`: the name and e-mail address to sign the source package with
- `PPA`: the Launchpad PPA to which the source package will be uploaded
- `VERSION_SUFFIX`: a string to append to the latest Ubuntu kernel release, e.g., `+debug1`

## Launchpad access
- a GPG key with the name `${MAINTAINER} <${EMAIL}>`, with no passphrase
- the GPG key added to your Launchpad profile
- a Launchpad PPA you have access to under `${PPA}`
