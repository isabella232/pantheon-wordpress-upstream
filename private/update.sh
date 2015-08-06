#!/bin/bash

cd "$(dirname "$0")/.."
set -e

plugins=(
	jetpack

)
for plugin in "${plugins[@]}"; do
	git reset "wp-content/plugins/$plugin"
	git checkout "wp-content/plugins/$plugin"
	old_version=$(wp plugin get "$plugin" --field=version)
	wp --allow-root plugin update "$plugin"
	new_version=$(wp plugin get "$plugin" --field=version)
	if [ "$old_version" != "$new_version" ]; then
		git add -A "wp-content/plugins/$plugin"
		git commit -m "Update $plugin to $new_version from $old_version"
	else
		echo "Already up to date"
	fi
done
