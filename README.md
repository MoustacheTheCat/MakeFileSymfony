MekeFile lancement de projet symfony




Liste des commandes :



    make init-s project_name=${projet_name} user=${db_user_name} password=${db_password, nullable} db_name={name_db}


il faut bien sur modifier -> serverVersion=10.11.2-MariaDB par serverVersion=8.0.32
    


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

       
       

    make install-dep

    
       

install-dep: ## Install dependencies
    composer require --dev symfony/var-dumper
    composer require fakerphp/faker
    composer require --dev doctrine/doctrine-fixtures-bundle
    php bin/console importmap:require bootstrap
    composer require symfony/asset-mapper symfony/asset symfony/twig-pack
    composer require symfony/ux-twig-component symfony/ux-live-component symfonycasts/sass-bundle twbs/bootstrap knplabs/knp-paginator-bundle gedmo/doctrine-extensions symfony/maker-bundle symfony/debug-bundle
    @echo "Dépendances installées avec succès !"
    @echo ""
    @cat "la suite se trouve dans README" 





Modifier le code dans les différents fichier avant de lancer la commande make start-s


Ajouter ce code dans base.html.twig :

    {# templates/base.html.twig #}
    {% block stylesheets %}
        <link rel="stylesheet" href="{{ asset('styles/app.scss') }}">
    {% endblock %}

Ajouter ce code dans stof_doctrine_extensions.yaml :

    stof_doctrine_extensions:
        default_locale: fr_FR
        orm:
            default:
                timestampable: true
                sluggable: true

Ajouter ce code dans knp_paginator.yaml :

    knp_paginator:
        template:
            pagination: '@KnpPaginator/Pagination/bootstrap_v5_pagination.html.twig'     # sliding pagination controls template
            sortable: '@KnpPaginator/Pagination/bootstrap_v5_bi_sortable_link.html.twig' # sort link template
            filtration: '@KnpPaginator/Pagination/bootstrap_v5_filtration.html.twig'  # filters template

Ajouter ce code dans twig.yaml :

    twig:
        default_path: '%kernel.project_dir%/templates'
        form_themes: ['bootstrap_5_layout.html.twig']
        when@test:
            twig:
                strict_variables: true

Ajouter ce code dans ux_live_component.yaml :

    live_component:
        resource: '@LiveComponentBundle/config/routes.php'
        #prefix: '/_components'
        # adjust prefix to add localization to your components
        prefix: '/{_locale}/_components'

Ajouter ce code dans asset_mapper.yaml :

    framework:
        asset_mapper:
            paths:
                - assets/
            excluded_patterns:
                - '*/assets/styles/_*.scss'
                - '*/assets/styles/**/_*.scss'

Modifier le fichier style.css en style .scss, puis changer le nom dans le fichier app.js et coller ce code dans style .scss :

    @import '../../vendor/twbs/bootstrap/scss/bootstrap';
    @import "vendor/tom-select";



Une fois les etpas franchis lancer 


    make start-s



start-s: ## Start Symfony server and asset compilation
    symfony server:start -d
    php bin/console asset-map:compile
    php bin/console sass:build
    php bin/console sass:build --watch


     make rebuild 
        


rebuild: ## Rebuild the database
    symfony console d:d:d -f
    symfony console d:d:c
    symfony console d:s:u -f
    symfony console d:f:l -n


    make start-s

        
  

