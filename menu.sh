#!/bin/bash

# Ensure we are running under bash
if [ "$BASH_SOURCE" = "" ]; then
    /bin/bash "$0"
    exit 0
fi

# Load Bash menu file
. "bash-menu.sh"


################################
## Action menus
##
## Start/Stop/Restart services/features.
################################
action1() {
    echo "Starting installation of Magento 2.3.5 version"
    chmod a+rwx m2-install.sh && ./m2-install.sh;

    echo -n "Installation completed! Press enter to continue ... "
    read response

    return 1
}

action2() {
    echo "Starting installation of Magento 2.4.0 version"
    chmod a+rwx m2-install-solo.sh && ./m2-install-solo.sh;
    echo -n "Installation completed! Press enter to continue ... "
    read response

    return 1
}

action3() {
    echo "Starting Redis service"
    redis-server &
    echo -n "Redis service started! Press enter to continue ... "
    read response

    return 1
}

action4() {
    echo "Stopping Redis service"
    ps aux | grep redis | awk {'print $2'} | xargs kill -s 9;
    echo -n "Redis service stopped! Press enter to continue ... "
    read response

    return 1
}

action5() {
    echo "Starting ElasticSearch service"
    $ES_HOME/bin/elasticsearch -d -p $ES_HOME/pid -Ediscovery.type=single-node &
    echo -n "ElasticSearch service started! Press enter to continue ... "
    read response

    return 1
}

action6() {
    echo "Stopping ElasticSearch service"
    ps aux | grep elastic | awk {'print $2'} | xargs kill -s 9;
    echo -n "ElasticSearch service stopped! Press enter to continue ... "
    read response

    return 1
}

action7() {
    echo "Starting Blackfire service"
    chmod a+rwx ./blackfire-run.sh && ./blackfire-run.sh && service php7.2-fpm reload;
    echo -n "Blackfire service started! Press enter to continue ... "
    read response

    return 1
}

action8() {
    echo "Stopping Blackfire service"
    ps aux | grep blackfire | awk {'print $2'} | xargs kill -s 9;
    echo -n "Blackfire service stopped! Press enter to continue ... "
    read response

    return 1
}

action9() {
    echo "Starting Newrelic service, Please update .gitpod.Dockerfile (https://github.com/nemke82/magento2gitpod/blob/master/.gitpod.Dockerfile) with license key."
    newrelic-daemon -c /etc/newrelic/newrelic.cfg &
    echo -n "Newrelic service started! Press enter to continue ... "
    read response

    return 1
}

action10() {
    echo "Stopping Newrelic service"
    ps aux | grep newrelic | awk {'print $2'} | xargs kill -s 9;
    echo -n "Newrelic service stopped! Press enter to continue ... "
    read response

    return 1
}

action11() {
    echo "Starting Tideways service, Please update .env-file located in repo with TIDEWAYS_APIKEY"
    /usr/bin/tideways-daemon --address 0.0.0.0:9135 &
    echo -n "Tideways service started! Press enter to continue ... "
    read response

    return 1
}

action12() {
    echo "Stopping Tideways service"
    ps aux | grep tideways | awk {'print $2'} | xargs kill -s 9;
    echo -n "Tideways service stopped! Press enter to continue ... "
    read response

    return 1
}

action13() {
    echo "Configuring xDebug PHP settings"
    echo "xdebug.remote_autostart=on" >> /etc/php/7.2/mods-available/xdebug.ini;
    echo "xdebug.profiler_enable=On" >> /etc/php/7.2/mods-available/xdebug.ini;
    echo "xdebug.profiler_enable=On" >> /etc/php/7.2/mods-available/xdebug.ini;
    echo "xdebug.profiler_output_name = nemanja.log" >> /etc/php/7.2/mods-available/xdebug.ini;
    echo "xdebug.show_error_trace=On" >> /etc/php/7.2/mods-available/xdebug.ini;
    echo "xdebug.show_exception_trace=On" >> /etc/php/7.2/mods-available/xdebug.ini;
    service php7.2-fpm reload;
    echo -n "Services successfully configured and php-fpm restarted! Press enter to continue ... "
    read response

    return 1
}

action14() {
    echo "Disabling xDebug PHP settings"
    ps aux | grep tideways | awk {'print $2'} | xargs kill -s 9;
    echo -n "xDebug stopped! Press enter to continue ... "
    read response

    return 1
}

actionX() {
    return 0
}


################################
## Setup Example Menu
################################

## Menu Item Text
##
## It makes sense to have "Exit" as the last item,
## as pressing Esc will jump to last item (and
## pressing Esc while on last item will perform the
## associated action).
##
## NOTE: If these are not all the same width
##       the menu highlight will look wonky
menuItems=(
    " 1. Install Magento 2.3.5 latest"
    " 2. Install Magento 2.4.0 (dev)"
    " 3. Start Redis service"
    " 4. Stop Redis service"
    " 5. Start ElasticSearch service"
    " 6. Stop ElasticSearch service"
    " 7. Start Blackfire service"
    " 8. Stop Blackfire service"
    " 9. Start Newrelic service"
    "10. Stop Newrelic service"
    "11. Start Tideways service"
    "12. Stop Tideways service"
    "13. Start xDebug service"
    "14. Stop xDebug service"
    "Q. Exit  "
)

## Menu Item Actions
menuActions=(
    action1
    action2
    action3
    action4
    action5
    action6
    action7
    action8
    action9
    action10
    action11
    action12
    action13
    action14
    actionX
)

## Override some menu defaults
menuTitle=" Controller room"
menuFooter=" Enter=Select, Navigate via Up/Down/First number/letter"
menuWidth=60
menuLeft=25
menuHighlight=$DRAW_COL_YELLOW


################################
## Run Menu
################################
menuInit
menuLoop


exit 0