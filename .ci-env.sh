export WPCS_STANDARD=WordPress-Core
export PHPCS_IGNORE='tests/*,includes/vendor/*'
export YUI_COMPRESSOR_CHECK=1
export LIMIT_TRAVIS_PR_CHECK_SCOPE=files
export PATH_INCLUDES='
        wp-config.php
        private/
        wp-content/themes/example-*/
        wp-content/mu-plugins/example-*
        wp-content/plugins/example-*
'
