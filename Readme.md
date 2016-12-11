Protobuf Playground
===

Notes
---

### rebuilding protobuf modules/classes

```sh
bundle exec rake protobuf
```

### jruby

Right now this only works on MRI because there is no proper jruby version released as of right now.
See issue https://github.com/google/protobuf/issues/1594

When using the prerelease version `v3.1.0.0.pre` it still won't work as this is using refinements which
won't work correctly using jruby https://github.com/jruby/jruby/issues?utf8=%E2%9C%93&q=is%3Aissue%20is%3Aopen%20refinement

Although I imagine this would indeed work when changing the code to not rely on refinements.
