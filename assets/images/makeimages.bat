rem Starting with arrow_rr.png, arrow_sr.png, arrow_rs.png, arrow_ur.png, and arrow_ss.png, make all arrow images.

magick arrow_rr.png -rotate "90" arrow_dd.png
magick arrow_dd.png -rotate "90" arrow_ll.png
magick arrow_ll.png -rotate "90" arrow_uu.png

magick arrow_sr.png -rotate "90" arrow_sd.png
magick arrow_sd.png -rotate "90" arrow_sl.png
magick arrow_sl.png -rotate "90" arrow_su.png

magick arrow_rs.png -rotate "90" arrow_ds.png
magick arrow_ds.png -rotate "90" arrow_ls.png
magick arrow_ls.png -rotate "90" arrow_us.png

magick arrow_ur.png -rotate "90" arrow_rd.png
magick arrow_rd.png -rotate "90" arrow_dl.png
magick arrow_dl.png -rotate "90" arrow_lu.png

magick arrow_ur.png -transpose arrow_ld.png
magick arrow_ld.png -rotate "90" arrow_ul.png
magick arrow_ul.png -rotate "90" arrow_ru.png
magick arrow_ru.png -rotate "90" arrow_dr.png