#!/usr/bin/perl
print "Content-type: text/html","\n\n";

print <<Final_de_cabecera;
<HTML>
<HEAD><TITLE>Usuarios con mayor cantidad de mails sin leer</TITLE></HEAD>
<BODY BACKGROUND="http://pamela.efn.uncor.edu/images/C5.gif"><H2>Usuarios con mayor cantidad de mails
sin leer</H2>

<TABLE BORDER=1 BORDERCOLOR=#FF0000>
<TR>
<TH>Tama&ntilde;o en Bytes</TH>
<TH>Usuario</TH>
<TH>Nombre Real</TH>
</TR>
Final_de_cabecera

open (DU, "/bin/du -bs /var/spool/mail/* |sort -nr |");
while (<DU>) {
 	($tamano) = ($_ =~ /([^\s]*)/);
 	($nombre) = ($_ =~ /mail\/(.*)/);	 	
	$comando = `/usr/bin/finger $nombre`;	
	($usuario) = ($comando =~ /Name: (.*)/);
 	print "<TR ALIGN=CENTER>";
	print "<TD>",$tamano,"</TD>";
	print "<TD>",$nombre,"</TD>";
	print "<TD>",$usuario,"</TD>","\n";
	print "</TR>";
}
close (DU);
print" </TABLE>","\n"; 

print "</BODY></HTML>", "\n";
exit (0);
