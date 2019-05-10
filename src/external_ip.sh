#!/bin/bash
sed -i -e "s/ip_of_external_machine/$(curl 2ip.ru)/g" /home/appuser/.env
