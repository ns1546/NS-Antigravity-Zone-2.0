After completing Dart/Flutter code changes, always execute a hot reload or
hot restart. If you are not connected yet to an app, use the
`dtd` tool to proactively discover and
connect to apps.

Whenever attempting to investigate a package dependency, use the
`read_package_uris` and `rip_grep_packages` tools to explore their files.

In addition to `package:` URIs, the server also supports `package-root:` URIs,
which resolve to the root of the package instead of the `lib/` directory. These
can be useful for exporing examples or tests when trying to learn how to use a
package.
