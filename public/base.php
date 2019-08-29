<?php
include "helpers.php";
?>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">

        <title>Domain Expiration</title>
        <link rel="stylesheet" href="/css/bootstrap.min.css">
        <link rel="stylesheet" href="/css/style.css">

        <link rel="stylesheet" href="/css/jquery-ui.css">
        <script src="/js/jquery-3.3.1.min.js"></script>
        <script src="/js/popper.min.js"></script>
        <script src="/js/bootstrap.min.js"></script>
        <script src="/js/jquery-ui.js"></script>
        <script>
            jQuery( function() {
                var availableTags = [
                    <?php echo '"'.implode('","', cat_domains()).'"' ?>
                ];
                jQuery( "#tags" ).autocomplete({
                    source: availableTags
                });
            } );
        </script>
    </head>
    <body>

    <nav class="navbar navbar-expand-lg navbar-light bg-light custom-nav">
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo03" aria-controls="navbarTogglerDemo03" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <a class="navbar-brand my-2 my-lg-0" href="#"><?php echo date("Y-m-d");?></a>

        <div class="collapse navbar-collapse" id="navbarTogglerDemo03">
            <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
                <li class="nav-item active">
                    <a class="nav-link disabled" href="index.php">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link disabled" href="adding-domain.php">Add Domain</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link disabled" href="deleting-domain.php">Delete Domain</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link disabled" href="get-domain-ip.php">Get Domain IP</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link disabled" href="https://github.com/Amorteza1376/domains-lookup-tool" target="_blank">GitHub</a>
                </li>
            </ul>
        </div>
    </nav>
