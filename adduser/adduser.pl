#!/usr/bin/perl

$method = $ENV{'REQUEST_METHOD'};

# $exclusive_lock = 2;
# $unlock = 8;

&MIME_header ("text/html", "Formulario para la creacion de Usuarios");

if ($method eq "GET") {

	if (!$query) {
	
		print <<Fin_de_Forma;
Este formulario sirve para la creacion de Usuarios en el sistema de 
pamela.efn.uncor.edu
<P>
<HR>
<FORM METHOD="POST">
<H2>INFORMACION GENERAL DE LA CUENTA</H2>
<BR>
<PRE>
<B>Nombre Completo</B>:	<INPUT TYPE="text" NAME="nombre" SIZE=40><BR>
<B>Palabra clave</B>:	                    <INPUT TYPE="password" NAME="clave" SIZE=8>
<B>Confirmacion de la palabra clave</B>:   <INPUT TYPE="password" NAME="confirmacion" SIZE=8>
<BR><BR>
<B>Informacion del Finger: </B>
<TEXTAREA NAME="Finger" ROWS=3 COLS=58>
F.C.E.F. y N. - U.N.C.
Cordoba - Argentina
</TEXTAREA>
</PRE>
<HR>
<H2> Informacion del E-mail </H2>
<BR>
<PRE>
<B>Direccion de Internet</B>
<TEXTAREA NAME="address" ROWS=2 COLS=58>\@gtwing.efn.uncor.edu
</TEXTAREA>
<BR>
<INPUT TYPE="submit" VALUE="Agregar Usuario">
<INPUT TYPE="reset" VALUE="Limpiar Informacion">
<P>
</FORM>
<HR>

Fin_de_Forma

} else {

	&MIME_header ("text/html", "Otra Opcion");
print "Vamos a ver si anda";	

}
} elsif ($method eq "POST") {

&MIME_header ("text/html", "gracias");
# print "cacona\n"

&parse_form_data (*FORM);

if (!$FORM{'nombre'}) {
print "Falta el nombre, Cacho","\n";
exit (0);
}

if ((!$FORM{'clave'}) || (!$FORM{'confirmacion'})) {
print "falta la password o la confirmacion","\n";
exit (0);
}

if (($FORM{'clave'}) ne ($FORM{'confirmacion'})) {
print "Las palabras claves no coinciden","\n";
exit (0);
}

print "Nombre: ", $FORM{'nombre'}, "\n";
print "Clave: ", $FORM{'clave'}, "\n";
}
exit (0);

sub MIME_header
{
	local ($mime_type, $title_string, $header) = @_;

	if (!$header) {
		$header = $title_string;
	}
	
	print "Content-type: ", $mime_type, "\n\n";
	print "<HTML>", "\n";
	print "<HEAD><TITLE>", $title_string, "</TITLE></HEAD>", "\n";
	print "<BODY>", "\n";
	print "<H1>", $header, "</H1>";
	print "<HR>";
}



sub parse_form_data
{
local (*FORM_DATA) = @_;

local ( $request_method, $query_string, @key_value_pairs, $key_value, $key,
$value);

$request_method = $ENV{'REQUEST_METHOD'};

if ($request_method eq "GET") {
 	$query_string = $ENV{'QUERY_STRING'};
} elsif ($request_method eq "POST") {
 	read (STDIN, $query_string, $ENV{'CONTENT_LENGTH'});
} else {
 	&return_error (500, "Error en el Servidor", "El servidor no soporta
 el Metodo de traspaso Utilizado");
}

@key_value_pairs = split (/&/, $query_string);

foreach $key_value (@key_value_pairs) {
	($key, $value) = split (/=/, $key_value);
	$value =~ tr/+/ /;
	$value =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack ("C", hex ($1))/eg;

	if (defined($FORM_DATA{$key})) {
		$FORM_DATA{$key} = join ("\0", $FORM_DATA{$key}, $value);
	} else {
		$FORM_DATA{$key} = $value;
	}
}
}

sub return_error
{
	local ($status, $keyword, $message) = @_;

	print "Content-type: text/html", "\n";
	print "Status: ", $status, " ", $keyword, "\n\n";

	print <<Fin_Error;

<TITLE>Programa CGI - Error Inesperado</TITLE>
<H1>$keyword</H1>
<HR>$message</HR>
Contactar a <A HREF = mailto:root\@pamela.efn.uncor.edu>root\@pamela.efn.uncor.edu
</A>por informaci&oacute.

Fin_Error

	exit(1);
}