# https://github.com/elastic/logstash-docker
FROM docker.elastic.co/logstash/logstash-oss:6.3.1

# Add your logstash plugins setup here
# Example: RUN logstash-plugin install logstash-filter-json

RUN logstash-plugin install \
	# Input
	logstash-input-beats \
	logstash-input-jdbc \
	# Output
	logstash-output-gelf \
	# Filter
	logstash-filter-json \
	logstash-filter-date \
	logstash-filter-grok \
	logstash-filter-xml \
	logstash-filter-multiline
