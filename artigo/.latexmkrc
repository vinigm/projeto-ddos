# Executar a partir de artigo/ (pasta deste arquivo)
$ENV{'TEXINPUTS'} = './tex/sbc//:' . ( $ENV{'TEXINPUTS'} // '' );
$ENV{'BIBINPUTS'}  = './tex/sbc//:' . ( $ENV{'BIBINPUTS'}  // '' );
$ENV{'BSTINPUTS'}  = './tex/sbc//:' . ( $ENV{'BSTINPUTS'}  // '' );

$pdf_mode = 1;
$bibtex_use = 2;
