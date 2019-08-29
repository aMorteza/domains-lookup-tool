<?php
include "base.php";
?>
<div class="ui-widget center-container">
    <form action="add-domain.php" method="post" enctype="multipart/form-data">
        <div class="form-row">
            <div class="col-auto" id="inlineFormInput">
                <input name="domain" class="form-control" placeholder="Enter domain to add">
                <?php
                session_start();
                if (isset($_SESSION['already-exist']))
                {
                    ?>
                    <div> Already exists!</div>
                    <?php
                    unset($_SESSION['already-exist']);
                }
                else if (isset($_SESSION['added']))
                {
                    ?>
                    <div> New domain registered!</div>
                    <?php
                    unset($_SESSION['added']);
                } else
                    {
                    if (isset($_SESSION['not-added']))
                    {
                        ?>
                        <p>The domain is't a valid! or connection failed</p>
                        <?php
                        unset($_SESSION['not-added']);
                    }
                }
                ?>
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary" >Submit</button>
            </div>
        </div>
    </form>
</div>

