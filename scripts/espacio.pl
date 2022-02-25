#!/usr/bin/perl

$gnuplot = "/usr/bin/gnuplot";
$ppmtogif = "/usr/local/netpbm/ppmtogif";

$process_id = $$;
$output_ppm =join ("", "/tmp/", $process_id, ".ppm");
$datafile = join ("", "/tmp/", $process_id, ".txt");

$x = 1.2;
$y = 0.6;
$color = 1;

$contador = 0;

open (DU, "/bin/du -s /home/* |sort -nr |");
while (<DU>){
if (($contador <10) && (!/cosas/) && (!/ftp/) && (!/mail/) && (!/rjrpaz/) &&(!/ddujovne/)) {
($cadena[$contador]) = ($_ =~ /([^\s]*)/);
($cadena[$contador]) = ($cadena[$contador]) /1024;
($nombres[$contador]) = ($_ =~ /\d+\s+\/home\/(.*)/);
$contador++;
}
}

&create_output_file();

exit (0);

sub create_output_file
{
	local ($loop);
	if ( (open (FILE, ">" . $datafile)) ) {
		for ($loop=0; $loop <10; $loop++) {
		print FILE $loop, " ", $cadena[$loop], "\n";
		}
		close (FILE);

		&send_data_to_gnuplot();
}
}

sub send_data_to_gnuplot
{
	open (GNUPLOT, "|$gnuplot");
	print GNUPLOT <<gnuplot_final;
set term pbm color small
set output "$output_ppm"
set size $x, $y
set title "Uso del disco duro"
set xlabel "Usuarios"
set ylabel "Espacio Ocupado en Megabytes"
set xrange [-1:10]
set xtics ("$nombres[0]" 0, "$nombres[1]" 1, "$nombres[2]" 2, "$nombres[3]" 3, "$nombres[4]" 4, "$nombres[5]" 5, "$nombres[6]" 6, "$nombres[7]" 7, "$nombres[8]" 8, "$nombres[9]" 9)
set noxzeroaxis
set noyzeroaxis
set border
set nogrid
set nokey
plot "$datafile" w boxes $color

gnuplot_final

close (GNUPLOT);

&print_gif_file_and_cleanup();
}

sub print_gif_file_and_cleanup
{
$| = 1;
print "Content-type: image/gif" , "\n\n";
system ("$ppmtogif $output_ppm 2> /dev/null");

unlink $output_ppm, $datafile;
}
