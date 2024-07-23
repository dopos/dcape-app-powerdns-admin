# dcape-app-powerdns Makefile

SHELL               = /bin/bash
CFG                ?= .env
CFG_BAK            ?= $(CFG).bak

# PowerDNS Admin site address
APP_SITE           ?= pdns-admin.$(DCAPE_DOMAIN)

#- App name
APP_NAME           ?= pdns-admin

# Owerwrite default and use dcape database
USE_DB = yes

# Database host
PGHOST             ?= $(DCAPE_TAG)-db-1

# Database name
PGDATABASE         ?= $(PDNS_DB_TAG)

# Database user name
PGUSER             ?= $(PDNS_DB_TAG)

# Database user password
PGPASSWORD         ?= $(PDNS_DB_PASS)

#- Docker image name
IMAGE              ?= powerdnsadmin/pda-legacy

#- Docker image tag
IMAGE_VER          ?= v0.4.2
# ------------------------------------------------------------------------------
-include $(CFG_BAK)
export

-include $(CFG)
export
# ------------------------------------------------------------------------------
# Find and include DCAPE_ROOT/Makefile
DCAPE_COMPOSE   ?= dcape-compose
DCAPE_ROOT      ?= $(shell docker inspect -f "{{.Config.Labels.dcape_root}}" $(DCAPE_COMPOSE))

ifeq ($(shell test -e $(DCAPE_ROOT)/Makefile.app && echo -n yes),yes)
  include $(DCAPE_ROOT)/Makefile.app
else
  include /opt/dcape/Makefile.app
endif

# ------------------------------------------------------------------------------
## Test PowerDNS API key
test:
	curl -s -H 'X-API-Key: $(API_KEY)' $(HTTP_PROTO)://$(APP_SITE)/api/v1/servers/localhost/zones | jq '.'
