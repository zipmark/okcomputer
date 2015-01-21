#### v1.1.0

* Added two new checks:
    * GenericCacheCheck, which tests that `Rails.cache` is able to read and write.
    * MongoidReplicaSetCheck, which tests that all of your configured Mongoid replica sets can be reached.
* Modified CacheCheck to accept an optional Memcached host to test. The default behavior of testing Memcached on the local machine remains unchanged.

#### v1.0.0

* Version bump
* For prior breaking changes from initial development, see [the Deprecations and Breaking Changes section][breaking-changes] of the pre 1.0 README.

[breaking-changes]:https://github.com/sportngin/okcomputer/blob/3f6708b333ddaf7ecc14d8c2b163335d46343f66/README.markdown#deprecations-and-breaking-changes
