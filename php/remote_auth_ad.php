<?php
// There are 2 login screens, if set to 1, remote authentication will never be applied 
// on Admin Area login screen (admin/login.php)
// 1 - Enabled for Public area only
// 2 - Enabled for Public and Admin areas 
define('KB_AUTH_AREA', 2);


// 0 - never trying to authenticate by KBPublisher's built in authentication
// 1 - Trying to authenticate by KBPublisher's built in authentication before Remote Authentication
// 2 - Trying to authenticate by KBPublisher's built in authentication after Remote Authentication, if it failed
define('KB_AUTH_LOCAL', 2);


// If you have a lot of user and allow KBPublisher's built in authentication it could happen 
// that username and password can match with one of admin users and user will have access to Admin Area
// to avoid this you can set IP range, only users with these IP will trying to be authenticated
// by KBPublisher's built in authentication, it only does matter when KB_AUTH_LOCAL = 1 or 2
// you can set concrete IP or range of IP devided by "-", all IP(s) should be devided by ";"
// example: 127.0.0.1;210.234.12.15;192.168.1.1-192.168.255.255
define('KB_AUTH_LOCAL_IP', '127.0.0.1;142.134.1.1-142.134.255.255');


// remote auth type
// 1 - on success remoteDoAuth should return associative array with keys
//     (first_name, last_name, email, username, password, remote_user_id)
//     where "remote_user_id" is an unique id for user in your system (integer)
//     for example: array('first_name'=>'John', 'last_name'=>'Doe', ....);
//     
// 2 - on success remoteDoAuth should return user_id  that presents as id field in kb user table or 
//     associative array with keys (user_id, username)
//     for example: array('user_id'=>7, 'username'=>'Test');
//     On failure it should return false.
define('KB_AUTH_TYPE', 2);


// time in seconds to rewrite user data, (3600*24*30 = 30 days), works if KB_AUTH_TYPE = 1
// 0 - never, it means once user created, data in kb table never updated by script
// 1 - on every authentication request user data in kb will be synchronized with data provided by script
define('KB_AUTH_REFRESH_TIME', 1); //3600*24*30


// here you may provide a link where your remote user can restore password
// it will be used on login screen
// set to false not to display restore password link at all
// KBPublisher will determine to set your link or built-in one
define('KB_AUTH_RESTORE_PASSWORD_LINK', 'false');

function remoteDoAuth($username, $password) {
	
	$user = false;
	if(empty($username) || empty($password)) {
		return $user;
	}

	if(doAuthAD($username, $password) == false) {
		return $user;
	}
	
	$conf = array();
	$conf['db_host']    = "localhost";
	$conf['db_base']    = "kb";
	$conf['db_user']    = "kbuser";
	$conf['db_pass']    = "smg499kbuser";
	$conf['db_driver']  = "mysql";
	
	$db = &DBUtil::connect($conf);
	
	// request for user
	$username = addslashes($username);
	
	$sql = "
	SELECT 
		id AS 'id'
	FROM kbp_user 
	WHERE username = '%s' AND password != 'disabled'";
	$sql = sprintf($sql, $username);
	$result = &$db->Execute($sql) or die(db_error($sql, false, $db));
	
	// if found
	if($result->RecordCount() != 1) { 
	        return 0;
	}
	
	$user = $result->FetchRow();
        $userdata = array('user_id'=>$user['id'], 'username'=>$username);
	return $userdata;
}

function doAuthAD($username, $password) {
    require_once 'custom/adLDAP.php';

    if(empty($username) || empty($password)) {
        return false;
    }

    //create the AD LDAP connection
    $adldap = new adLDAP();

    // if found
    if($adldap->authenticate($username, $password)) {
        return true;
    }

    return false;
}

?>

