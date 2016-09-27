# unary, interfaced through GEOS:

#' Geometric operations on (pairs of) simple feature geometries
#' 
#' Geometric operations on (pairs of) simple feature geometries
#' @name geos
#' @export
#' @return matrix (sparse or dense); if dense: of type \code{character} for \code{relate}, \code{numeric} for \code{distance}, and \code{logical} for all others; matrix has dimension \code{x} by \code{y}; if sparse (only possible for those who return logical in case of dense): return list of length length(x) with indices of the TRUE values for matching \code{y}.
st_is_valid = function(x) CPL_geos_is_valid(st_geometry(x))

#' @name geos
#' @export
#' @return st_is_simple and st_is_valid return a logical vector
st_is_simple = function(x) CPL_is_simple(st_geometry(x))

# binary, interfaced through GEOS:

# returning matrix, distance or relation string -- the work horse is:

st_geos_binop = function(op = "intersects", x, y = x, par = 0.0, sparse = TRUE)
	CPL_geos_binop(st_geometry(x), st_geometry(y), op, par, sparse)

#' @param x first simple feature (sf) or simple feature geometry (sfc) collection
#' @param y second simple feature (sf) or simple feature geometry (sfc) collection
#' @name geos
#' @return st_distance returns a dense numeric matrix of dimension length(x) by length(y)
#' @export
st_distance = function(x, y = x) CPL_geos_dist(st_geometry(x), st_geometry(y))

#' @name geos
#' @return st_relate returns a dense \code{character} matrix
#' @export
st_relate           = function(x, y) st_geos_binop("relate", x, y)

#' @name geos
#' @param sparse logical; should a sparse matrix be returned (TRUE) or a dense matrix?
#' @return st_intersects ...  st_is_within_distance return a sparse or dense logical matrix with rows and columns corresponding to the number of geometries (or rows) in x and y, respectively
#' @export
st_intersects       = function(x, y, sparse = TRUE) st_geos_binop("intersects", x, y, sparse = sparse)

#' @name geos
#' @export
st_disjoint         = function(x, y, sparse = TRUE) st_geos_binop("disjoint", x, y, sparse = sparse)

#' @name geos
#' @export
st_touches          = function(x, y, sparse = TRUE) st_geos_binop("touches", x, y, sparse = sparse)

#' @name geos
#' @export
st_crosses          = function(x, y, sparse = TRUE) st_geos_binop("crosses", x, y, sparse = sparse)

#' @name geos
#' @export
st_within           = function(x, y, sparse = TRUE) st_geos_binop("within", x, y, sparse = sparse)

#' @name geos
#' @export
st_contains         = function(x, y, sparse = TRUE) st_geos_binop("contains", x, y, sparse = sparse)

#' @name geos
#' @export
st_overlaps         = function(x, y, sparse = TRUE) st_geos_binop("overlaps", x, y, sparse = sparse)

#' @name geos
#' @export
st_equals           = function(x, y, sparse = TRUE) st_geos_binop("equals", x, y, sparse = sparse)

#' @name geos
#' @export
st_covers           = function(x, y, sparse = TRUE) st_geos_binop("covers", x, y, sparse = sparse)

#' @name geos
#' @export
st_covered_by       = function(x, y, sparse = TRUE) st_geos_binop("coveredBy", x, y, sparse = sparse)

#' @name geos
#' @export
#' @param par numeric; parameter used for "equalsExact" (margin) and "isWithinDistance"
st_equals_exact     = function(x, y, par, sparse = TRUE) 
	st_geos_binop("equalsExact", x, y, par = par, sparse = sparse)

#' @name geos
#' @export
st_is_within_distance = function(x, y, par, sparse = TRUE) 
	st_geos_binop("isWithinDistance", x, y, par = par, sparse = sparse)


# unary, returning geometries -- GEOS interfaced through GDAL:

#' @name geos
#' @export
#' @param dist buffer distance
#' @param nQuadSegs integer; number of segments per quadrant (fourth of a circle)
#' @returns st_buffer ... st_segmentize return an \link{sfc} object with the same number of geometries as in \code{x}
st_buffer = function(x, dist, nQuadSegs = 30)
	st_sfc(CPL_geom_op("buffer", st_geometry(x), dist, nQuadSegs))

#' @name geos
#' @export
st_boundary = function(x) st_sfc(CPL_geom_op("boundary", st_geometry(x)))

#' @name geos
#' @export
st_convexhull = function(x) st_sfc(CPL_geom_op("convexhull", st_geometry(x)))

#' @name geos
#' @export
#' @examples 
#' s = st_read(system.file("shapes/", package="maptools"), "sids")
#' plot(st_unioncascaded(st_sfc(do.call(c, st_geometry(s)))),col=0)
st_unioncascaded = function(x) st_sfc(CPL_geom_op("unioncascaded", st_geometry(x)))

#' @name geos
#' @export
#' @param preserveTopology logical; carry out topology preserving simplification?
#' @param dTolerance numeric; tolerance parameter
st_simplify = function(x, preserveTopology = FALSE, dTolerance = 0.0)
	st_sfc(CPL_geom_op("simplify", st_geometry(x)), preserveTopology = preserveTopology, dTolerance = dTolerance)

#' @name geos
#' @export
#' @param bOnlyEdges logical; if TRUE, return lines, else return polygons
st_triangulate = function(x, dTolerance = 0.0, bOnlyEdges = FALSE)
	st_sfc(CPL_geom_op("triangulate", st_geometry(x)), dTolerance = dTolerance, bOnlyEdges = bOnlyEdges)

#' @name geos
#' @export
st_polygonize = function(x) st_sfc(CPL_geom_op("polygonize", st_geometry(x)))

#' @name geos
#' @export
#' @examples
#' s = st_read(system.file("shapes/", package="maptools"), "sids")
#' plot(s)
#' plot(st_centroid(s), add = TRUE, pch = 3)
st_centroid = function(x) st_sfc(CPL_geom_op("centroid", st_geometry(x)))

#' @name geos
#' @export
#' @param dfMaxLength numeric; max length of a line segment
st_segmentize  = function(x, dfMaxLength) 
	st_sfc(CPL_geom_op("segmentize", st_geometry(x)), dfMaxLength = dfMaxLength)

#' @name geos
#' @export
#' @param y0 object of class \code{sfc} which is merged, using \code{c.sfi} (\link{st}), before intersection etc. with it is computed 
st_intersection = function(x, y0) CPL_geom_op2("intersection", st_geometry(x), 
	st_sfc(do.call(c, st_geometry(y0))))

#' @name geos
#' @export
st_union = function(x, y0) CPL_geom_op2("union", st_geometry(x), 
	st_sfc(do.call(c, st_geometry(y0))))

#' @name geos
#' @export
st_difference = function(x, y0) CPL_geom_op2("difference", st_geometry(x), 
	st_sfc(do.call(c, st_geometry(y0))))

#' @name geos
#' @export
st_sym_difference = function(x, y0) CPL_geom_op2("sym_difference", st_geometry(x), 
	st_sfc(do.call(c, st_geometry(y0))))