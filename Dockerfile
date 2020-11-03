# Apache2 image
FROM httpd:2.4

# Copy our apache2 config file to configuration folder
COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
# Copy static folder content to htdocs folder
COPY ./static/ /usr/local/apache2/htdocs/
