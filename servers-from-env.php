<?php

$servers = array();

echo 'Exposing the following linked server instances:' . PHP_EOL;

foreach ($_SERVER as $key => $value) {
    // ends with vboxwebsrv default port
    if (substr($key, -15) === '_PORT_18083_TCP') {
        // get prefix of key
        $prefix = substr($key, 0, -15);

        // actual readable name is stored as "/thiscontainer/givencontainer"
        $name = getenv($prefix . '_NAME');
        $pos = strrpos($name, '/');
        if ($pos !== false) {
            $name = substr($name, $pos + 1);
        }

        if (!$name) {
            $name = ucfirst(strtolower($prefix));
        }

        $location = 'http://' . str_replace('tcp://', '', $value) . '/';
        
        echo '- ' . $name . ' (' . $location .')' . PHP_EOL;

        $servers []= array(
            'name' => $name,
            'username' => 'vbox',
            'password' => 'pass',
            'authMaster' => true,
            'location' => $location
        );
    }
}

if (!$servers) {
    echo 'Warn: No vboxwebsrv instance linked? Use "--link containername:myname", falling back to dockerhost.' . PHP_EOL;
    $servers []= array(
        'name' => 'dockerhost',
        'username' => 'vbox',
        'password' => 'pass',
        'authMaster' => true,
        'location' => 'http://' . trim( shell_exec( "netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}'" ) ) . ':18083/'
    );
}

$config = '<?php return ' . var_export($servers, true) . '; ?>';
file_put_contents('/var/www/config-servers.php', $config);

