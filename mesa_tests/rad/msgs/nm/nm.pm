#!/usr/local/bin/perl -w

# Package for routines that create NM objects

use Env;

package nm;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(make_dcm_object);
$patternDir = "$main::MESA_STORAGE/modality/NM/patterns/";

sub generate_pattern{
  my ($patternNo, $pixels) = @_;

  $x = "$main::MESA_TARGET/bin/mesa_image_pattern $patternNo $pixels";
  print "$x \n";
  print `$x`;

  return $?;
}

sub make_dcm_object {
  my ($cfindTextFile, $pixels) = @_;

  $x = "$main::MESA_TARGET/bin/dcm_create_object -p $pixels -i $cfindTextFile.txt $patternDir/$cfindTextFile.dcm";
  print "$x \n";
  print `$x`;

  return $?;
}

sub extract_nm_frames {
  my ($params, $dcmFile) = @_;

  $x = "$main::MESA_TARGET/bin/mesa_extract_nm_frames $params $patternDir/$dcmFile pixels";
  print "$x \n";
  print `$x`;

  if ($?) {
    print "Could not extract NM frames \n";
    exit 1;
  }
}

sub animate_frames {
  my ($paramsFileName, $inputFileName, $outputFileName) = @_;
  use Fcntl qw(:seek);
  use Image::Magick;

  open PARAMS, "+<$paramsFileName"
    or die "Could not open file - $paramsFileName: $!\n";
  my @fileHandle = <PARAMS>;
  foreach my $line (@fileHandle) {
    ($rowCount, $colCount, $imgHighBit, $imgPixRep, $imgBitAlloc, $imgBitStored, $frameSize, $frameCount, $matchingFrameCount) = split(" ",$line);
  }
  close(PARAMS); 

  open F, "+<$inputFileName"
    or die "Could not open file - $inputFileName: $!\n";

  my @fileStat = stat($inputFileName);

  my $count = 0;
  my @image;
  my $image;

  #for (my $frameCount = $fileStat[7]/$frameSize; $frameCount > 0; $frameCount--) {
  for (my $frame = $matchingFrameCount; $frame > 0; $frame--) {
    $count++;
    my $pos = tell(F);
    foreach (1 .. $count) { print "." }
    # Read bytes 131072 into $rawData
    seek(F, $pos, SEEK_SET);

    my $rawData;
    read(F,$rawData,$frameSize);

    #my $imgSize = $rowCount."x".$colCount;
    my $imgSize = $colCount."x".$rowCount;
    $image = Image::Magick->new(magick=>'gray', size=>$imgSize, depth=>$imgBitAlloc);
    #$image = Image::Magick->new(magick=>'gray', size=>'64x64', depth=>'16');

    $image->BlobToImage($rawData);
    $image->Write("test".$count. ".gif");
    push(@image, "test".$count.".gif");
    print "\n";
  }
  close(F);

  my $x = Image::Magick->new;
  $x = $image->Read(@image);
  warn "$x" if "$x";

  $x = $image->Write("$patternDir/$outputFileName");
  unlink (@image);
}
