#Trims white space around images and saves 

library(magick)

#Set directory where list of icons are
icon_list <- dir()
for (i in 1:length(icon_list)) {
  
  curr <- image_trim(image_read(icon_list[i]))
  
  image_write(curr, path = paste('crop_',icon_list[i], sep = ''), format = "png")
  
}
