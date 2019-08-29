<?php
require '../vendor/autoload.php';
use App\SQLiteConnection;

$connection = new SQLiteConnection();
$pdo = ($connection)->connect();
//if ($pdo != null)
//    echo 'Connected to the SQLite database successfully!';
//else
//    echo 'Whoops, could not connect to the SQLite database!';
?>