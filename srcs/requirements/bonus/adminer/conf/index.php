<?php
if (!count($_GET)) {
	$_GET[getenv("ADMINER_DEFAULT_DRIVER")] = getenv("ADMINER_DEFAULT_SERVER");
    $_GET["username"] = getenv("ADMINER_DEFAULT_USERNAME");
    $_GET["db"] = getenv("ADMINER_DEFAULT_DB");
}
include './adminer.php';

?>

