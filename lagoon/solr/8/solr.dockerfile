FROM solr:8.7.0

COPY ./lagoon/solr/8/solr-conf /solr-conf/conf/

RUN precreate-core drupal /solr-conf

CMD ["solr-foreground"]