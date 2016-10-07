# Requirements
## Environment variables
- `MAINTAINER`, `EMAIL`: the name and e-mail address to sign the source package with
- `PPA`: the Launchpad PPA to which the source package will be uploaded
- `VERSION_SUFFIX`: a string to append to the latest Ubuntu kernel release, e.g., `+debug1`

## Launchpad access
- a GPG key with the name `${MAINTAINER} <${EMAIL}>`, with no passphrase
- the GPG key added to your Launchpad profile
- a Launchpad PPA you have access to under `${PPA}`

# Notes on this example
This patchset enables the [KASan](https://www.kernel.org/doc/Documentation/kasan.txt) and [kmemleak](https://www.kernel.org/doc/Documentation/kmemleak.txt) kernel configurations on a kernel built for Trusty.
Since KASan requires gcc-5, which is not present in Trusty, you have to add the [Toolchain test builds](https://launchpad.net/~ubuntu-toolchain-r/+archive/ubuntu/test) PPA as a PPA dependency for your own PPA.

Additionally, an upstream patch from 4.7 has been applied to prevent out of bounds accesses in bonding.
