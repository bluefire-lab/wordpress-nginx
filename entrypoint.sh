#!/bin/sh

# Set default values for environment variables
if [ -z "$NGINX_PORT" ]; then
    NGINX_PORT=8080
fi

if [ -n "$HOST" ]; then
    HOST_CONFIG=$HOST
else
    HOST_CONFIG='$host'
fi

if [ -z "$REDIS_READ_ENDPOINT" ]; then
    REDIS_READ_ENDPOINT='redis-endpoint'
fi

if [ -z "$REDIS_WRITE_ENDPOINT" ]; then
    REDIS_WRITE_ENDPOINT='redis-endpoint'
fi

# Print all the environment variables
echo "**********************************************"
echo "NGINX_PORT: $NGINX_PORT"
echo "HOST_CONFIG: $HOST_CONFIG"
echo "REDIS_READ_ENDPOINT: $REDIS_READ_ENDPOINT"
echo "REDIS_WRITE_ENDPOINT: $REDIS_WRITE_ENDPOINT"
echo "PHP_ENDPOINT: $PHP_ENDPOINT"
echo "**********************************************"

# If PHP_ENDPOINT_CONFIG is not set, throw an error
if [ -z "$PHP_ENDPOINT" ]; then
    echo "PHP_ENDPOINT is not set. Please set it to the PHP endpoint."
    exit 1
fi


# Replace all the occurecies of #*NGINX_PORT*#
echo "Settiging nginx port to: $NGINX_PORT"
sed -i "s/\#\*NGINX_PORT\*\#/$NGINX_PORT/g" /usr/local/openresty/nginx/conf/default.conf
            
# Replace all the occurecies of #*WORDPRESS_HOST*#
echo "Settiging host to: $HOST_CONFIG"
if [ -f /usr/local/openresty/nginx/conf/common/php-config.conf ]; then
    sed -i "s/\#\*WORDPRESS_HOST\*\#/$HOST_CONFIG/g" /usr/local/openresty/nginx/conf/common/php-config.conf
fi
sed -i "s/\#\*HOST_CONFIG\*\#/$HOST_CONFIG/g" /usr/local/openresty/nginx/conf/default.conf

# Replace all the occurecies of #*REDIS_READ_ENDPOINT*# and #*REDIS_WRITE_ENDPOINT*#
if [ -f /usr/local/openresty/nginx/conf/common/redis-upstream.conf ]; then
    echo "Settiging redis write upstream to: $REDIS_READ_ENDPOINT"
    sed -i "s/\#\*REDIS_READ_ENDPOINT\*\#/$REDIS_READ_ENDPOINT/g" /usr/local/openresty/nginx/conf/common/redis-upstream.conf

    echo "Settiging redis redis upstream to: $REDIS_READ_ENDPOINT"
    sed -i "s/\#\*REDIS_WRITE_ENDPOINT\*\#/$REDIS_WRITE_ENDPOINT/g" /usr/local/openresty/nginx/conf/common/redis-upstream.conf
fi

# Replace all the occurecies of #*PHP_ENDPOINT*#
if [ -f /usr/local/openresty/nginx/conf/common/php-upstream.conf ]; then
    echo "Settiging php upstream to: $PHP_ENDPOINT"
    sed -i "s/\#\*PHP_ENDPOINT\*\#/$PHP_ENDPOINT/g" /usr/local/openresty/nginx/conf/common/php-upstream.conf
fi

exec "$@"
