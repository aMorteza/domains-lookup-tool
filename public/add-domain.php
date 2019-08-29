<?php
/**
 * Created by PhpStorm.
 * User: amirhosein
 * Date: 4/24/18
 * Time: 2:09 PM
 */
include "helpers.php";
session_start();
    if ($_POST['domain']) {
        $domain = $_POST['domain'];
        if (is_valid_faster($domain)) {
            if (is_found_in_domains($domain)) {
                $_SESSION['already-exist'] = 1;
            } else {
                put_domain_to_list($domain);
                $_SESSION['added'] = 1;
            }
        }else {
            $_SESSION['not-added'] = 1;
        }
    }
header('Location: ' . $_SERVER['HTTP_REFERER']);
?>