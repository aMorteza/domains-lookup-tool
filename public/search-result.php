<?php
include "base.php"
?>

<?php
session_start();
if (isset($_SESSION['found']) and isset($_SESSION['info'])) {
    $info = $_SESSION["info"];
   ?>

        <section id="cards">
        <div class="offset-md-3 col-md-6">
            <!-- Card 1 -->
            <div class="card">
                <div class="card-header"><?php echo $info["domain"]?></div>
                <div class="card-block">
                    <p class="card-text"></p>
                </div>
            </div>
            <!-- Card 2 -->
            <?php if (boolval(strpos($info["expiryDate"]," ")) != 0)
            { ?>
                <div class="card">
                    <div class="card-header"><?php echo $info["expiryDate"]?></div>
                    <div class="card-block">
                        <p class="card-text"></p>
                    </div>
                </div>
            <?php }
            ?>
            <!-- Card 3 -->
            <?php if (boolval(strpos($info["updatedDate"]," ")) != 0)
            { ?>
                <div class="card">
                    <div class="card-header"><?php echo $info["updatedDate"]?></div>
                    <div class="card-block">
                        <p class="card-text"></p>
                    </div>
                </div>
            <?php }
            ?>
            <!-- Card 4 -->
            <?php if (boolval(strpos($info["creationDate"]," ")) != 0)
            { ?>
                <div class="card">
                    <div class="card-header"><?php echo $info["creationDate"]?></div>
                    <div class="card-block">
                        <p class="card-text"></p>
                    </div>
                </div>
            <?php }
            ?>
            <!-- Card 5 -->
            <?php if (boolval(strpos($info["nameServer"]," ")) != 0)
            { ?>
                <div class="card">
                    <div class="card-header"><?php echo $info["nameServer"]?></div>
                    <div class="card-block">
                        <p class="card-text"></p>
                    </div>
                </div>
            <?php }
            ?>
            <!-- Card 6 -->
            <?php if (boolval(strpos($info["registrar"]," ")) != 0)
                { ?>
                <div class="card">
                    <div class="card-header"><?php echo $info["registrar"]?></div>
                    <div class="card-block">
                        <p class="card-text"></p>
                    </div>
                </div>
            <?php }
            ?>
            <!-- Card 7 -->
            <?php if (boolval(strpos($info["registrarUrl"]," ")) != 0)
            { ?>
                <div class="card">
                    <div class="card-header"><?php echo $info["registrarUrl"]?></div>
                    <div class="card-block">
                        <p class="card-text"></p>
                    </div>
                </div>
            <?php }
            ?>
            <!-- Card 8 -->
            <?php if (boolval(strpos($info["adminEmail"]," ")) != 0)
            { ?>
                <div class="card">
                    <div class="card-header"><?php echo $info["adminEmail"]?></div>
                    <div class="card-block">
                        <p class="card-text"></p>
                    </div>
                </div>
            <?php }
            ?>
        </div>
    </section>



    <?php
    unset($_SESSION["info"]);
    unset($_SESSION["found"]);

}else{
    header('Location: '.$_SERVER['HTTP_REFERER']);
}
?>
