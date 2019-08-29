<?php
include "base.php";
?>
<div class="ui-widget center-container">
    <form action="delete-domain.php" method="post" enctype="multipart/form-data">
        <div class="form-row">
            <div class="col-auto" id="inlineFormInput">
                <input name="domain" id="tags" class="form-control" placeholder="Enter domain to delete">
                <?php
                session_start();
                if (isset($_SESSION['deleted'])) {
                    ?>
                    <p> The domain deleted!</p>
                    <?php
                    unset($_SESSION['deleted']);
                }else{
                    if (isset($_SESSION['not-deleted'])) {
                        ?>
                        <p>Not found!</p>
                        <?php
                        unset($_SESSION['not-deleted']);
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



