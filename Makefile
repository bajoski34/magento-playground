MAGENTO_SRC := magento
MAGENTO_BIN := ${MAGENTO_SRC}/bin/magento
MAGENTO_VERSION := 2.4.7-p4
MAGENTO_PORT := $(gp url 8080)
ENVIRONMENT := development
MAGE_ACCESS_TOKEN := SOMETHING
GITHUB_ZIP := https://github.com/BudPay-Org/budpay-magento/archive/refs/heads/main.zip

# https://github.com/magento/magento2/archive/refs/heads/2.4-develop.zip 
# https://github.com/magento/magento2/archive/refs/tags/2.4.7-p4.zip <-current->
# wget https://MAG006028228:<ACCCESSCODE>@www.magentocommerce.com/products/downloads/file/Magento-CE-2.4.4_sample_data.zip
# composer create-project --repository=https://repo.magento.com/ magento/project-community-edition="2.4.7-p4" magento

copy_module_zip_github:
	@wget ${GITHUB_ZIP}
	mkdir -p app/code/
	unzip main.zip -d ./app/code
	mv app/code/budpay-magento-main/ app/code/Budpay

deps:
	sudo update-alternatives --set php /usr/bin/php8.2
	sudo apt update
	sudo apt install -y php8.2-bcmath php8.2-curl php8.2-gd php8.2-intl php8.2-pdo php8.2-mysql php8.2-zip php8.2-soap unzip

prep:
	@if [ ! -d "${MAGENTO_SRC}" ]; then \
		composer create-project --repository=https://repo.magento.com/ magento/project-community-edition="${MAGENTO_VERSION}" ${MAGENTO_SRC}; \
	fi
	mkdir -p ${MAGENTO_SRC}/app/code/
	@cp -r app/code/* ${MAGENTO_SRC}/app/code/ || true

setup:
	${MAGENTO_BIN} setup:install \
	--base-url=https://8080-bajoski34-m245-as7ubgw7b01.ws-eu118.gitpod.io \
	--db-host=127.0.0.1 \
	--db-name=magento \
	--db-user=root \
	--db-password="rootpassword" \
	--admin-firstname=admin \
	--admin-lastname=admin \
	--admin-email=admin@admin.com \
	--admin-user=admin \
	--admin-password=admin123 \
	--language=en_US \
	--currency=USD \
	--timezone=America/Chicago \
	--use-rewrites=1 \
	--search-engine=opensearch \
	--opensearch-host=http://localhost \
	--opensearch-index-prefix=magento \
	--opensearch-port=9200

sample-data:
	cd ${MAGENTO_SRC} && \
		bin/magento sampledata:deploy && \
		bin/magento setup:upgrade

deploy:
	php ${MAGENTO_BIN} module:enable Budpay_Payment
	php ${MAGENTO_BIN} setup:upgrade
	php ${MAGENTO_BIN} cache:flush

opensearch:
	docker run -d --name opensearch   -p 9200:9200 -p 9600:9600   -e "discovery.type=single-node"  -e "plugins.security.disabled=true"   -e "OPENSEARCH_INITIAL_ADMIN_PASSWORD=Ex@mpl3Str0ngP@ssw0rd!" -e "network.host=0.0.0.0"   opensearchproject/opensearch:latest

db:
	docker run -d \
  --name mariadb-magento \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=magento \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=rootpassword \
  -p 3306:3306 \
  --restart unless-stopped \
  mariadb:10.6

serve:
	php -S 127.0.0.1:8080 -t ${MAGENTO_SRC}/pub ${MAGENTO_SRC}/phpserver/router.php

release:
	zip -r Budpay_Payment ${MAGENTO_SRC}/app/code/Budpay/Payment

clean:
	rm -rf magento

.PHONY: prep db opensearch setup sample-data deploy