#!/usr/bin/perl

use GD;

$df = `/bin/df /dev/hda3`;

($porcentaje) = ($df =~ /\d+\s+\d+\s+\d+\s+\d+\s+([^%]*)/);

$porcentaje = $porcentaje / 100;
@slices = ($porcentaje, 1 - $porcentaje);

@slices_message = ("Ocupado", "Desocupado");

$no_slices = 1;

$legend_rect_size = 10;
$legend_rect = $legend_rect_size * 2;

$max_length = 450;
$max_height = 200;

$pie_indent = 10;
$pie_length = $pie_height = 200;
$radius = $pie_height / 2;

@origin = ($radius + $pie_indent, $max_height /2);
$legend_indent = $pie_length + 40;
$legend_rect_to_text = 25;
$deg_to_rad = (atan2 (1, 1) * 4) / 180;

$image = new GD::Image ($max_length, $max_height);

$white = $image->colorAllocate (255, 255, 255);
$red = $image->colorAllocate (255, 0, 0);
$green = $image->colorAllocate (0, 255, 0);
$black = $image->colorAllocate (0, 0, 0);

@slices_color = ($red , $green);

$image->arc (@origin, $pie_length, $pie_height, 0, 360, $black);

$percent = 0;
for ($loop=0; $loop <= $no_slices; $loop++) {
	$percent += $slices[$loop];
	$degrees = int ($percent * 360) * $deg_to_rad;
	$image->line ( $origin[0], $origin[1], $origin[0] + ($radius * cos ($degrees)), $origin[1] + ($radius * sin ($degrees)), $slices_color[$loop]);
}

$percent = 0;
for ($loop=0; $loop <= $no_slices; $loop++) {
	$percent += $slices[$loop];
	$degrees = int (($percent * 360) - 1) * $deg_to_rad;

	$x = $origin[0] + ( ($radius - 10) * cos ($degrees) );
	$y = $origin[1] + ( ($radius - 10) * sin ($degrees) );

	$image->fill ($x, $y, $slices_color[$loop]);
}

$legend_x =$legend_indent;
$legend_y = ( $max_height - ($no_slices * $legend_rect) - ($legend_rect *
0.75) ) /2;

for ($loop=0; $loop <= $no_slices; $loop++) {
	$legend_rect_y = $legend_y + ($loop * $legend_rect);
	$text = pack ("A18", $slices_message[$loop]);

	$message = sprintf ("%s (%4.2f%%)", $text, $slices[$loop] * 100);

	$image->filledRectangle ( $legend_x, $legend_rect_y, $legend_x +
$legend_rect_size, $legend_rect_y + $legend_rect_size,
$slices_color[$loop]);

	$image->string (gdSmallFont, $legend_x + $legend_rect_to_text, $legend_rect_y, $message, $black );
	}

$image->string (gdLargeFont, 270, 50, "Espacio en Disco", $black);

$image->transparent($white);

$| = 1;
print "Content-type: image/gif", "\n\n";
print $image->gif;

exit (0);