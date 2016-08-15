if (Sys.getenv("USER") == "edzer") {
  library(RPostgreSQL)
  library(sf)
  cn = dbConnect(PostgreSQL(), dbname = "postgis")
  round_trip = function(cn, wkt) {
  	query = paste0("SELECT '", wkt, "'::geometry;")
  	w = options("warn")[[1]]
  	options(warn = -1)
	returnstr = dbGetQuery(cn, query)$geometry
	# print(returnstr)
  	options(warn = w)
  	options(warn = 2)
  	n = nchar(returnstr)/2
    wkb = lapply(returnstr, function(y) as.raw(as.numeric(paste0("0x", 
  	  sapply(1:n, function(x) substr(y, (x-1)*2+1, x*2))))))
  	class(wkb) = "WKB"
    ret = ST_as.sfc(wkb, EWKB = TRUE)[[1]]
	cat(returnstr, "\n")
    cat(paste(wkt, "<-->", ST_as.WKT(ret, EWKT=TRUE), "\n"))
	invisible(ret)
  }
  round_trip(cn, "SRID=4326;POINTM(0 0 0)")
  round_trip(cn, "POINTZ(0 0 0)")
  round_trip(cn, "POINTZM(0 0 0 0)")
  round_trip(cn, "POINT(0 0)")
  round_trip(cn, "LINESTRING(0 0,1 1,2 2)")
  round_trip(cn, "MULTIPOINT(0 0,1 1,2 2)")
  round_trip(cn, "POLYGON((0 0,1 0,1 1,0 0))")
  round_trip(cn, "MULTIPOLYGON(((0 0,1 0,1 1,0 0)),((2 2,3 2,3 3,2 2)))")
  round_trip(cn, "MULTIPOLYGON(((0 0,1 0,1 1,0 0),(.2 .2,.8 .2, .8 .8, .2 .2)),((2 2,3 2,3 3,2 2)))")
  round_trip(cn, "MULTILINESTRING((0 0,1 0,1 1,0 0),(.2 .2,.8 .2, .8 .8, .2 .2),(2 2,3 2,3 3,2 2))")


options(warn = -1)
query = paste0("SELECT geom from meuse2 limit 2;")
returnstr = dbGetQuery(cn, query)$geom
# print(returnstr)
n = nchar(returnstr)/2
wkb = lapply(returnstr, function(y) as.raw(as.numeric(paste0("0x", 
  sapply(1:n, function(x) substr(y, (x-1)*2+1, x*2))))))
class(wkb) = "WKB"
ret = ST_as.sfc(wkb, EWKB = TRUE)
ret 

# nc:
#query = paste0("SELECT geom from nc;")
#returnstr = dbGetQuery(cn, query)$geom
#wkb = lapply(returnstr, function(y) { 
#	  n = nchar(y)/2
#	  as.raw(as.numeric(paste0("0x", sapply(1:n, function(x) substr(y, (x-1)*2+1, x*2)))))
#	}
#)
#class(wkb) = "WKB"
#ret = ST_as.sfc(wkb)
#ret 

}