#### v1.6.3
  * Added support for Sidekiq 4

#### v1.6.2

  * Fix exception when requiring `okcomputer` without the use of Bundler.

#### v1.6.1

  * Add built in redis health check

#### v1.6.0

* Added a configuration option to run checks in parallel.

#### v1.5.1
#### v1.5.0

* Added new options to DelayedJobBackedUpCheck: which queue to check, whether to include running jobs in the count, whether to include failed jobs in the count, and a minimum priority of jobs to count.
* Updated MongoidCheck for compatibility with Mongoid 5.

#### v1.4.0

* Added two new checks:
    * SolrCheck, which tests connection to a Solr instance
    * HttpCheck, which tests connection to an arbitrary HTTP endpoint
* ElasticsearchCheck has been modified to be a child of HttpCheck, with no change in external behavior.

#### v1.3.0

* MongoidCheck now accepts an optional `session` argument to check the given session.

#### v1.2.0

* Added two new checks:
    * ElasticsearchCheck, which tests the health of your Elasticsearch cluster
    * AppVersionCheck, which reports the version (as a SHA) of your app is running

#### v1.1.0

* Added two new checks:
    * GenericCacheCheck, which tests that `Rails.cache` is able to read and write.
    * MongoidReplicaSetCheck, which tests that all of your configured Mongoid replica sets can be reached.
* Modified CacheCheck to accept an optional Memcached host to test. The default behavior of testing Memcached on the local machine remains unchanged.

#### v1.0.0

* Version bump
* For prior breaking changes from initial development, see [the Deprecations and Breaking Changes section][breaking-changes] of the pre 1.0 README.

[breaking-changes]:https://github.com/sportngin/okcomputer/blob/3f6708b333ddaf7ecc14d8c2b163335d46343f66/README.markdown#deprecations-and-breaking-changes
