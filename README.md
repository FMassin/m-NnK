# Introduction #

[NaiNo-Kami](http://eos.kokugakuin.ac.jp/modules/xwords/entry.php?entryID=109) (NNK) is a tool to extract and make use of coherent waveforms of impulsive signals. Such cluster of events are named [multiplets](http://www.gps.caltech.edu/uploads/File/People/kanamori/HKpepi86.pdf) when using earthquake signals in [seismology](http://books.google.com/books?id=sRhawFG5_EcC&hl=fr).


NNK is a suite of  [Matlab](http://www.mathworks.com/) and [Perl](http://www.perl.org/) scripts for earthquake waveform [clustering](http://books.google.com/books?id=htZzDGlCnQYC&printsec=frontcover&hl=fr&source=gbs_ge_summary_r&cad=0#v=onepage&q=clustering&f=false) from [cross-correlation](http://books.google.com/books?id=Dtza-BqVL0gC&pg=PA45&lpg=PA45&dq=maximum+cross+correlation+serie+seismology&source=bl&ots=LzUyb0BBqV&sig=AloS9zIDrAy7GBUegzYYQvRCKbE&hl=fr&ei=cb6ETtfNCfKrsALb0-ySDw&sa=X&oi=book_result&ct=result&resnum=1&ved=0CCQQ6AEwAA#v=onepage&q=cross%20correlation&f=false).
Seismological exploitations modules are included for [1D](http://jclahr.com/science/software/hypo71/) and [3D](http://alomax.free.fr/nlloc/soft6.00/index.html) location, [1D](http://www.ldeo.columbia.edu/~felixw/hypoDD.html) and [3D](http://www.geology.wisc.edu/~hjzhang/download.htm) double difference relocation, [focal mechanism determination](http://www.google.com/url?url=http://earthquake.usgs.gov/research/software/%23FPFIT,%2520FPPLOT%2520and%2520FPPAGE&rct=j&q=fpfit&usg=AFQjCNGBvItwUask1deqbZgmMHl0bjdV1w&sa=X&ei=Gb-ETqb3J4-BsgLykPTTDw&ved=0CCoQygQwAA), [coda wave interferometry](http://inside.mines.edu/~rsnieder/Coda_Yearbook04.pdf) and more to come.

NNK read an write [SAC files](http://www.iris.edu/KB/questions/13/SAC+file+format) (see the [SAC program](http://www.iris.edu/software/sac/)). Sac format is designed for signal processing. It is a versatile, [widely](http://www.iris.edu/software/sac/) used format which could content any 1d time serie with a lot of [metadata](http://www.iris.edu/software/sac/manual/file_format.html). [Please](http://www.guzer.com/pictures/pretty_please_cat.jpg) consider using it.

[Ad Hoc (AH)](http://www.orfeus-eu.org/Software/softwarelib.html#processing) files reading capabilities can be used when the [CORAL](http://www.orfeus-eu.org/Software/softwarelib.html#matlab) toolbox (by [Ken Creager](http://earthweb.ess.washington.edu/creager/coral_doc.html)) is installed on your machine.

# Readings #
  * [Yellowstone volcano-tectonic microseismic cycles constrain models of migrating volcanic fluids](https://7061844195658084343-a-1802744773732722657-s-sites.googlegroups.com/site/fredmassin/download/Fred_Massin_AGU-2011_toprint.jpg?attachauth=ANoY7cpg80sg4-TL53bFL-FX7PmbRNyJR2erKYfJSyF5OsjLOoEuBoE6-809YBZSnoBovjjwW_Eym16ccM1pwf9QGX2rSrY1vMmNXu6_MhNwL5L-1JnwO7GEGAoV88HzAM3SC5a4n8_lGME-DYyD2aqKtqgZwMplKg5x3bmrF5JUoqmbGemdteSSLV_ga8Fvl6mNegn5IXpeYkevcwsz5Rpewd92OH8oMc_dPfJmBcp34OUcD-wXo8k%3D&attredirects=0). Massin, F.; Farrell, J.; Smith, R.B.. American Geophysical Union, Fall Meeting 2011, [#S31B-2242](http://eposters.agu.org/abstracts/yellowstone-volcano-tectonic-microseismic-cycles-constrain-models-of-migrating-volcanic-fluids/?from_search=true).

  * [Structures and evolution of the plumbing system of Piton de la Fournaise volcano inferred from clustering of 2007 eruptive cycle seismicity](http://www.sciencedirect.com/science/article/pii/S0377027311000333). F. Massin, V. Ferrazzini, P. Bachèlery, A. Nercessian, Z. Duputel, T. Staudacher. Journal of Volcanology and Geothermal Research, Volume 202, Issues 1-2, 30 April 2011, Pages 96-106

  * [A real time process for detection, clustering, and relocation of volcano-tectonic events at Piton de La Fournaise volcano](https://7061844195658084343-a-1802744773732722657-s-sites.googlegroups.com/site/fredmassin/download/2009_PosterAGU.jpg?attachauth=ANoY7crvSUNFPgFLMFsgbLM81k3wLSXzvvID7p0QGpwicA99zpOCOwJqh49UaWxIzLbptSMvcNugJ6JjtWEfryQ7jwtweCtEQO1t_pHoccMdYE-oAONlg4Kp1b6CgAHLXv_c43TL2udGtetLTqUJDSBZeW_TRcc5n7FZJ-r7j-squlZh5AZbvg5UqPfjPBX6-mk2Ss-aZx4VB-igB6aavZCpM8KGdjxGqA%3D%3D&attredirects=0). Massin, F.; Ferrazzini, V.; Bachelery, P.; Duputel, Z.. American Geophysical Union, Fall Meeting 2009, [abstract #V23D-2107](http://adsabs.harvard.edu/abs/2009AGUFM.V23D2107M).

# Please ! #
Show up on the  [golden book](https://github.com/FMassin/naino-kami/blob/wiki/Golden_book.md) when using NNK ! Email are strongly encouraged to request help before using these scripts. Contact [project owner](https://github.com/FMassin) :). Also, exploitation modules in other domains than seismology are welcomed (infrasound ?). Please request to be member to add your great work !


#[Project owner](http://fredmassin.blogspot.fr/)
