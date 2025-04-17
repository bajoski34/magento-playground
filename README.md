# magento-playground
setup a magento instance on your sandbox environment easily.

# Gitpod Setup Quick and Easy.
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/bajoski34/m245)

# Simple Magento Development Environment Using Gitpod.

## Requirements
[Make](https://www.gnu.org/software/make/) – a build automation tool used to run tasks via the Makefile.

[PHP 8.2+](https://www.php.net/downloads.php) – the minimum supported PHP version.

Docker and Docker Compose – used for containerizing and orchestrating the application.

## Setup your Website.
To setup the Project run the command below

```shell
make prep db opensearch setup sample-data deploy
```

## Adobe Commerce Version Release.
https://experienceleague.adobe.com/en/docs/commerce-operations/release/versions

## Admin Access
To get the admin login path.
```shell
php bin/magento info:adminuri
```

## Credentials
username: admin
password: admin123

To download sample data use:
```shell
php bin/magento sampledata:deploy
```

```shell
cd magento && \
composer require --dev markshust/magento2-module-disabletwofactorauth && \
bin/magento module:enable MarkShust_DisableTwoFactorAuth && \
bin/magento setup:upgrade
```

## Show Mode
```shell
bin/magento deploy:mode:show # returns `default` by default
```
## Developer Mode
```shell
bin/magento deploy:mode:set developer
```

## Clear cache automatically with watch.

```shell
cd magento && composer require --dev mage2tv/magento-cache-clean && vendor/bin/cache-clean.js --watch
```

## Products Not showing. Run the code below.
```shell
php bin/magento indexer:reindex
```
