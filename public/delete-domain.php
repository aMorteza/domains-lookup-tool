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

    if(is_found_in_info_files($domain))
        unlink("../scripts/bash/info/$domain.txt");

    if (is_found_in_domains($domain))
    {
        $domainsList = cat_domains();
        $newDomainsList = array();
        foreach ($domainsList as $url)
        {
            if (!boolval(strcmp(trim($domain),$url) == 0))
            {
                array_push($newDomainsList, $url);
            }
        }
        $old_path = getcwd();
        chdir("../scripts/bash");
        file_put_contents("domains-list.txt", "");
        $current = '';
        foreach ($newDomainsList as $domain)
        {
            $current .= "$domain\n";
            file_put_contents("domains-list.txt", $current);
        }

        chdir($old_path);
        $_SESSION['deleted'] = 1;
    }
    else
    {
        $_SESSION['not-deleted'] = 1;
    }
}
header('Location: ' . $_SERVER['HTTP_REFERER']);
?>