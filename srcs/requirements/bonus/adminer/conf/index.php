<?php
if (!count($_GET)) {
	$_POST["auth"] = [
		"driver" => getenv("ADMINER_DEFAULT_DRIVER"),
		"server" => getenv("ADMINER_DEFAULT_SERVER"),
		"username" => getenv("ADMINER_DEFAULT_USERNAME"),
		"password" => getenv("ADMINER_DEFAULT_SERVER"),
		"db" => getenv("ADMINER_DEFAULT_DB"),
	];
}
include './adminer.php';

?>

