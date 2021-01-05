FROM amazeeio/solr:7.7-drupal-latest

COPY ./lagoon/solr/7/solr-conf /solr-conf/conf/

# We need to remove the core that was created by amazeeio in the drupal image above as it uses
# default configurations which we need to update using this Dockerfile.
RUN rm -rf /opt/solr/server/solr/mycores/drupal

RUN precreate-core drupal /solr-conf

CMD ["solr-foreground"]