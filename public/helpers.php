<?php
/**
 * Class whois
 *
 */

class whois
{
    var $cmd;

    function __construct()
    {
        $this->set_whois_cmd();
        return;
    }

    function set_whois_cmd()
    {
        if (file_exists('/usr/local/bin/whois'))
        {
            $this->cmd = '/usr/local/bin/whois';
        }
        elseif (file_exists('/usr/bin/whois'))
        {
            $this->cmd = '/usr/bin/whois';
        }
        elseif (file_exists('/bin/whois'))
        {
            $this->cmd = '/bin/whois';
        }
        else
        {
            die("<h1>Error:</h1>\n<p>Couldn't locate the 'whois' program.</p>");
        }
    }

    function query($domain)
    {
        /**
         * return the whois results with text linebreaks converted into html linebreaks
         */
        return shell_exec($this->cmd ." ". $domain);
    }
}



function get_domains($myFile = 'bash/domains-list.txt')
{
    if (!file_exists($myFile)) {
        print 'File not found';
    }
    else if(!$fh = fopen($myFile, 'r')) {
        print 'Can\'t open file'."<br>";
    }
    else {
        return file($myFile);
    }
}

/**
 * @param $url
 * @return mixed
 */
function curl_get_contents($url)
{
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_URL, $url);

    $data = curl_exec($ch);
    curl_close($ch);

    return $data;
}

/**
 * @param $url
 * @return bool
 */
function is_valid_domain($url)
{
    $validation = FALSE;
    $urlParts = parse_url(filter_var($url, FILTER_SANITIZE_URL));   //Parse URL

    if(!isset($urlParts['host']))                                           //Check host exist else path assign to host
        $urlParts['host'] = $urlParts['path'];

    if($urlParts['host']!=''){
        if (!isset($urlParts['scheme']))  //Add scheme if not found
            $urlParts['scheme'] = 'http';
        if(checkdnsrr($urlParts['host'], 'A') && in_array($urlParts['scheme'], array('http','https')) && ip2long($urlParts['host']) == FALSE){  //Validation
            $urlParts['host'] = preg_replace('/^www\./', '', $urlParts['host']);
            $url = $urlParts['scheme'].'://'.$urlParts['host']. "/";
            if (filter_var($url, FILTER_VALIDATE_URL) !== false && @get_headers($url))
                $validation = TRUE;

        }
    }
  return $validation;
}

function is_valid_faster($url)
{
    $old_path = getcwd();
    chdir('../scripts/bash');
    $output = shell_exec("./validate_domain.sh $url");
    chdir($old_path);
    return $output != null;
}

/**
 * @param $url
 * @return bool
 */
function is_found_in_domains($url)
{
    $old_path = getcwd();
    chdir('../scripts/bash');
    $output = shell_exec("cat domains-list.txt | grep -o $url");
    chdir($old_path);
    return boolval(strcmp(trim($output),$url) == 0);
}

/**
 * @param $url
 * @return bool
 */
function is_found_in_info_files($url)
{
    $old_path = getcwd();
    chdir('../scripts/bash');
    $output = shell_exec("cd info; ls | grep $url");
    chdir($old_path);
    return $output != null;
}

/**
 * @param $url
 * @return array
 */
function get_domain_info_by_file($url)
{
    return [
        'domain' => $url,
        'expiryDate' => get_domain_expiry_date_by_file($url),
        'updatedDate' => get_domain_updated_date_by_file($url),
        'creationDate' => get_domain_creation_date_by_file($url),
        'nameServer' => get_domain_name_server_by_file($url),
        'registrarUrl' => get_domain_registrar_url_by_file($url),
        'registrar' => get_domain_registrar_by_file($url),
        'adminEmail' => get_domain_admin_email_by_file($url),
        ];
}

/**
 * @param $url
 * @return string
 */
function get_domain_expiry_date_by_file($url)
{
    $old_path = getcwd();
    chdir('../scripts/bash');
    $expr_date = shell_exec("./get_expiry_date.sh $url");
    chdir($old_path);
    return $expr_date;
}

/**
 * @param $url
 * @return string
 */
function get_domain_updated_date_by_file($url)
{
    $old_path = getcwd();
    chdir('../scripts/bash');
    $updated_date = shell_exec("./get_updated_date.sh $url");
    chdir($old_path);
    return $updated_date;
}

/**
 * @param $url
 * @return string
 */
function get_domain_creation_date_by_file($url)
{
    $old_path = getcwd();
    chdir('../scripts/bash');
    $creation_date = shell_exec("./get_creation_date.sh $url");
    chdir($old_path);
    return $creation_date;
}



/**
 * @param $url
 * @return string
 */
function get_domain_name_server_by_file($url)
{
    $old_path = getcwd();
    chdir('../scripts/bash');
    $name_server = shell_exec("./get_name_server.sh $url");
    chdir($old_path);
    return $name_server;
}

/**
 * @param $url
 * @return string
 */
function get_domain_registrar_url_by_file($url)
{
    $old_path = getcwd();
    chdir('../scripts/bash');
    $registrar_url = shell_exec("./get_registrar_url.sh $url");
    chdir($old_path);
    return $registrar_url;
}

/**
 * @param $url
 * @return string
 */
function get_domain_registrar_by_file($url)
{
    $old_path = getcwd();
    chdir('../scripts/bash');
    $registrar = shell_exec("./get_registrar.sh $url");
    chdir($old_path);
    return $registrar;
}

/**
 * @param $url
 * @return string
 */
function get_domain_admin_email_by_file($url)
{
    $old_path = getcwd();
    chdir('../scripts/bash');
    $admin_email = shell_exec("./get_admin_email.sh $url");
    chdir($old_path);
    return $admin_email;
}

/**
 * @param $url
 * @return bool
 */
function found_info_file($url)
{
    $old_path = getcwd();
    chdir('../scripts/bash/info');
    $found = file_exists($url.".txt");
    chdir($old_path);
    return $found;
}

/**
 * @return array|false|string[]
 */
function cat_domains()
{
    $old_path = getcwd();
    chdir('../scripts/bash');
    $output = shell_exec('cat domains-list.txt | awk \'{print $1}\'');
    chdir($old_path);
    return preg_split('/\s+/', trim($output));
}

/**
 * @param $fileName
 * @param $info
 */
function put_domain_info_to_file($fileName, $info)
{
    $old_path = getcwd();
    chdir('../scripts/bash/info');
    $file = $fileName.".txt";
    if(file_exists($file)) {
        $current = file_get_contents($file);
        file_put_contents($file, "");
    }
    else {
        $current = '';
    }
    $counter = 0;
    foreach ($info as $line)
    {
        if($counter  >= 4 and $counter <= 64 and $line !=null) {
            $current .= "$line\n";
            file_put_contents($file, $current);
        }
        $counter++;
    }
    chdir($old_path);
}

/**
 * @param $domain
 */
function put_domain_to_list($domain)
{
    $old_path = getcwd();
    chdir('../scripts/bash');
    file_put_contents('domains-list.txt',
    $domain . PHP_EOL, FILE_APPEND | LOCK_EX);
    chdir($old_path);
}

/**
 * @param $domain
 */
function put_domain_to_list_faster($domain)
{
    $old_path = getcwd();
    chdir('../scripts/bash');
    shell_exec("echo $domain >> domains-list.txt");
    chdir($old_path);
}

function get_domain_expiry_date($domain)
{
    $expiryDate = get_domain_expiry_date_by_file($domain);
    return $expiryDate ? explode(":",$expiryDate)[1] : null;
}


function map_domains_to_other_info($domains)
{
    $info = array();
    foreach ($domains as $domain)
    {
//        $registrar = get_domain_registrar_by_file($domain);
        $tmp = [
            'domain' => $domain,
            'expiry_date' => get_domain_expiry_date($domain),
//            'registrar' => boolval(strpos($registrar," ")) != 0 ? str_replace("Registrar:", "", $registrar) : "unknown",
            ];
       array_push($info, $tmp);
    }
    return $info;
}

function get_domains_ordered_by_date()
{
    $old_path = getcwd();
    chdir('../scripts/bash');
    $output = shell_exec('cat domains-list.txt | awk \'{print $1}\'');
    chdir($old_path);
    $domains = preg_split('/\s+/', trim($output));
    $info = map_domains_to_other_info($domains);
    usort($info, 'sortByDate');
    return $info;
}

function sortByDate($a, $b)
{
    $a = strtotime($a['expiry_date']);
    $b = strtotime($b['expiry_date']);
    if ($a == $b) return 0;
    return ($a < $b) ? -1 : 1;

}

//TODO : please fix, this not work (want to use on web page)
function get_domain_notification_level($domain, $level = null)
{
    $level++;
    echo "<br>"."$$level";
    $old_path = getcwd();
    chdir('../scripts/bash');
    $output = $level == null ?  shell_exec("cat domains-list.txt | awk '$1==\"'$domain'\" {print $2; print $3; print $4}'") : shell_exec("cat domains-list.txt | awk '$1==\"'$domain'\" {print $\"'$level'\";}'");
    chdir($old_path);
    var_dump($output);
}

