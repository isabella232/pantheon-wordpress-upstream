#!/bin/bash

cd "$(dirname "$0")/.."
set -e

if [ -e private/wordpress-org-plugins.txt ]; then
	IFS=$'\r\n' GLOBIGNORE='*' :; plugins=($(cat private/wordpress-org-plugins.txt | sed 's/#.*//'))
else
	plugins=(
		wp-redis
	)
fi

for plugin in "${plugins[@]}"; do
	echo "## $plugin"

	if ! wp plugin is-installed "$plugin"; then
		wp plugin install --activate "$plugin"
		version=$(wp plugin get "$plugin" --field=version)
		git add -A "wp-content/plugins/$plugin"
		git commit -m "Add $plugin $version"
		continue
	fi

	git reset -q "wp-content/plugins/$plugin"
	git checkout "wp-content/plugins/$plugin"
	old_version=$(wp plugin get "$plugin" --field=version)
	wp plugin update "$plugin"
	new_version=$(wp plugin get "$plugin" --field=version)
	if [ "$old_version" != "$new_version" ]; then
		git add -A "wp-content/plugins/$plugin"
		git commit -m "Update $plugin to $new_version from $old_version" || echo "Can't commit. Please commit update to $new_version from $old_version"
	else
		echo "Already up to date"
	fi
	echo
done

if [ -e private/update-custom.sh ]; then
	bash private/update-custom.sh
fi
