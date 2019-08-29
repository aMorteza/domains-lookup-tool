<html>
<body>
    <?php
    $old_path = getcwd();
    chdir('../scripts/bash');
    $output = shell_exec("export DOMAINS_PROJECT_PATH=\"".__DIR__."/../\";./check.sh");
    chdir($old_path);
    echo "<pre>$output</pre>";
    ?>
</body>
</html>