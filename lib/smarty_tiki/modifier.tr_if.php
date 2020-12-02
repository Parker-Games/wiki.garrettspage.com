<?php
// (c) Copyright by authors of the Tiki Wiki CMS Groupware Project
//
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.
// $Id$

// Translate only if feature_multilingual is on

//this script may only be included - so its better to die if called directly.
if (strpos($_SERVER["SCRIPT_NAME"], basename(__FILE__)) !== false) {
	header("location: index.php");
	exit;
}

function smarty_modifier_tr_if($source)
{
	global $prefs;
	$args = array_slice(func_get_args(), 1);

	if ($prefs['language'] != 'en') {
		include_once('lib/init/tra.php');
		return tra($source, '', false, $args);
	} else {
		$replace = array_values($args);
		$search = array_map(
			function ($arg) {
				return '%' . $arg;
			},
			array_keys($args)
		);
		return str_replace($search, $replace, $source);
	}
}
