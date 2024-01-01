.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init-s: ## Init projet
	symfony new $(project_name) --webapp
	cd $(project_name) && \
	sed -i '/^# DATABASE_URL=/d' .env && \
	sed -i '/^DATABASE_URL=/d' .env && \
	if [ -z "$(password)" ]; then \
		echo 'DATABASE_URL="mysql://$(user):@127.0.0.1:3306/$(db_name)?serverVersion=10.11.2-MariaDB&charset=utf8mb4"' >> .env; \
	else \
		echo 'DATABASE_URL="mysql://$(user):$(password)@127.0.0.1:3306/$(db_name)?serverVersion=10.11.2-MariaDB&charset=utf8mb4"' >> .env; \
	fi && \
	symfony console d:d:c





install-dep: ## Install dependencies
	composer require --dev symfony/var-dumper
	composer require fakerphp/faker
	composer require --dev doctrine/doctrine-fixtures-bundle
	php bin/console importmap:require bootstrap
	composer require symfony/asset-mapper symfony/asset symfony/twig-pack
	composer require symfony/ux-twig-component symfony/ux-live-component symfonycasts/sass-bundle twbs/bootstrap knplabs/knp-paginator-bundle gedmo/doctrine-extensions symfony/maker-bundle symfony/debug-bundle
	@echo "Dépendances installées avec succès !"
	@echo ""
	@cat code_blocks.txt

rebuild: ## Rebuild the database
	symfony console d:d:d -f
	symfony console d:d:c
	symfony console d:s:u -f
	symfony console d:f:l -n

start-s: ## Start Symfony server and asset compilation
	symfony server:start -d
	php bin/console asset-map:compile
	php bin/console sass:build
	php bin/console sass:build --watch
