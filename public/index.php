<body>
    <div class="menu">
        <?php include 'base.php'?>
    </div>
<div class="content">
    <div class="title m-b-md">
        <div class="offset-md-2 col-md-8 main-list">
            <?php
                foreach (get_domains_ordered_by_date() as $info)
                {
                    if ($info['expiry_date'] != null) {

                        if ((strtotime($info['expiry_date']) - time()) > (60 * 60 * 24 * 30)) {
                            $class = 'bg-info text-white';

                        } else if ((strtotime($info['expiry_date']) - time()) <= (60 * 60 * 24)) {
                            $class = 'bg-danger text-white';
                        }
                        else {
                            $class = 'bg-warning text-dark';
                        }
                        $line = $info['domain']." - ".$info['expiry_date'];
                    }else{
                        $line = $info['domain']." - "."info still, is n't available";
                        $class = 'bg-secondary text-white';
                    }
                ?>
                    <a href="/search-domain.php?domain=<?php echo $info['domain'];?>">
                        <span class="domain-card <?php echo $class;?> ">
                            <span>
                                <?php echo $line; ?>
                            </span>
                        </span>
                    </a>
                    <?php
                }
            ?>
        </div>
    </div>
</div>

<style>
    html, body {
        background-color: #fff;
        color: #636b6f;
        font-family: 'Raleway', sans-serif;
        font-weight: 100;
        height: 100vh;
        margin: 0;
    }
</style>

</body>
</html>