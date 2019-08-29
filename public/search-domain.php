<?php
/**
 * Created by PhpStorm.
 * User: amirhosein
 * Date: 4/28/18
 * Time: 10:26 AM
 */
include "helpers.php";
session_start();

if ($_GET['domain']) {
    $domain = $_GET['domain'];
    if (is_valid_faster($domain)) {
        if (is_found_in_domains($domain)) {
            if (found_info_file($domain)) {
                $_SESSION["found"] = 1;
                $info = get_domain_info_by_file($domain);
                if ($info) {
                    $_SESSION["info"] = $info;
                }else{
                    $_SESSION["info"] = "No match found, its down!";
                }
            } else {
                $_SESSION["info"] = "The domain info still is'nt available, please check later!";
            }
        } else {
            $_SESSION['not-found'] = 1;
        }
    }else {
        $_SESSION['not-valid'] = 1;
    }
}
header('Location: ' . '/search-result.php');