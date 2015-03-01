<?php
$output = shell_exec('/usr/bin/ruby /var/www/JohnDeere.rb 2>&1');
print "$output";
?>