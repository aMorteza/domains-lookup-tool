<?php
include "base.php";
session_start();
if ($_POST['domain']) {
    $domain = $_POST['domain'];
    $ip = shell_exec("nslookup $domain | grep -o -P \"Address.{0,30}\" | cut -f2- -d:");

    if ($ip != null) {
     $_SESSION['ip'] = $ip;
    }else{
        $_SESSION['not-found'] = 1;
    }
}
?>
<div class="ui-widget center-container">
    <form action="get-domain-ip.php" method="post" enctype="multipart/form-data">
        <div class="form-row">
            <div class="col-auto" id="inlineFormInput">
                <input name="domain" id="tags" class="form-control" placeholder="Enter your domain">
                <?php
                session_start();
                if (isset($_SESSION['ip']))
                {
                    ?>
                    <div>
                        <?php
                        echo "<br>"."<br>".$_SESSION['ip'];
                        ?>
                    </div>
                    <?php
                    unset($_SESSION['ip']);
                }else if(isset($_SESSION['not-found'])){
                    ?>
                    <div>Not found </div>
                    <?php
                    unset($_SESSION['not-found']);
                }
                ?>
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary" >Submit</button>
            </div>
        </div>
    </form>
</div>



