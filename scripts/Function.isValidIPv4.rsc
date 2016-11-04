/system script environment remove [ find where name="isValidIPv4" ];
:global isValidIPv4 do={
## returns true if $value is a valid quad-dotted IPv4 address without taking into account:
## - subnetting issues like https://en.wikipedia.org/wiki/IPv4#Addresses_ending_in_0_or_255
## - non-decimal parts in the quads (so a leading zero in a quad is allowed but does not mean an octal)
## - non-quad-dotted representations (like a full decimal or full octal representation)
## - other varieties that https://linux.die.net/man/3/inet_addr accepts.

## TODO: consider using the `:toip` function mentioned but not documented at http://wiki.mikrotik.com/wiki/Manual:Scripting
## as IPv4 isn't always quad-dotted decimal: http://forum.mikrotik.com/viewtopic.php?f=9&t=114099
## `:toip` example usage at:
## - http://wiki.mikrotik.com/wiki/Converting_network_and_gateway_from_routing_table_to_hexadecimal_string
## - http://wiki.mikrotik.com/wiki/Sync_Address_List_with_DNS_Cache
## - http://forum.mikrotik.com/viewtopic.php?t=85205
## Maybe do a parse as well to distinguish between `ip` and `ip-prefix`
## - http://forum.mikrotik.com/viewtopic.php?t=70574

#:global varDump;

#$varDump value=$value name="value";

  :local IPv4 ("$value");
# via https://stackoverflow.com/questions/106179/regular-expression-to-match-dns-hostname-or-ip-address/106223#106223
# note the backslash escapes so \\. escapes into \. which matches the . literal and \$ expands into $
  :local validIPv4RegularExpression "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\$";
## if you forget the \$ escape, then you get strange errors like on the below line "expected end of command (line 19 column 28)"

#$varDump value=$IPv4 name="IPv4";
#$varDump value=$validIPv4RegularExpression name="validIPv4RegularExpression";

  :local result ($IPv4 ~ $validIPv4RegularExpression);

#$varDump value=$result name="result";
  :return $result;
}

## Examples:
## /import scripts/Function.isValidIPv4.rsc
## :put [$isValidIPv4 value=1.2.3.4]
## true
## :put [$isValidIPv4 value="1.2.3.4"]
## true
## :put [$isValidIPv4 value="0"]
## :put [$isValidIPv4 value="0.0"]
## :put [$isValidIPv4 value="0.0.0"]
## :put [$isValidIPv4 value="0.0.0.0"]
## true
## :put [$isValidIPv4 value="1111"]
## :put [$isValidIPv4 value="1111.1111"]
## :put [$isValidIPv4 value="1111.1111.1111"]
## :put [$isValidIPv4 value="1111.1111.1111.1111"]
## :put [$isValidIPv4 value="255"]
## :put [$isValidIPv4 value="255.255"]
## :put [$isValidIPv4 value="255.255.255"]
## :put [$isValidIPv4 value="255.255.255.255"]
## true
## :put [$isValidIPv4 value="0255"]
## :put [$isValidIPv4 value="0255.0255"]
## :put [$isValidIPv4 value="0255.0255.0255"]
## :put [$isValidIPv4 value="0255.0255.0255.0255"]
