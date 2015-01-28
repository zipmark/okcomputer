module OkComputer
  # This class performs a health check on an elasticsearch cluster using the
  # {cluster health API}[http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cluster-health.html].
  # 
  # It reports the cluster's name, number of nodes, and status (green, yellow,
  # or red). A cluster status of red is reported as a failure, since this means
  # one or more primary shards are unavailable. Note that the app may still
  # be able to perform some queries on the available indices/shards.
  class ElasticsearchCheck < Check
    attr_accessor :host
    attr_accessor :request_timeout

    # Public: Initialize a new elasticsearch check.
    #
    # host - The hostname of elasticsearch
    # request_timeout - How long to wait to connect before timing out. Defaults to 5 seconds.
    def initialize(host, request_timeout = 5)
      self.host = host
      self.request_timeout = request_timeout.to_i
    end

    # Public: Return the status of the elasticsearch cluster
    def check
      cluster_health = self.cluster_health

      if cluster_health[:status] == 'red'
        mark_failure
      end

      mark_message "Connected to elasticseach cluster '#{cluster_health[:cluster_name]}', #{cluster_health[:number_of_nodes]} nodes, status '#{cluster_health[:status]}'"
    rescue ConnectionFailed => e
      mark_failure
      mark_message "Error: '#{e}'"
    end

    # Returns a hash from elasticsearch's cluster health API
    def cluster_health
      response = timeout(request_timeout) { health_url.read(read_timeout: request_timeout) }
      JSON.parse(response, symbolize_names: true)
    rescue => e
      raise ConnectionFailed, e
    end

    def health_url
      @health_url ||= URI.join(host, '_cluster/health')
    end

    ConnectionFailed = Class.new(StandardError)
  end
end
