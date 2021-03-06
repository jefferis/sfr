#' S3 Ops Group Generic Functions (multiply and add/subtract) for affine transformation
#'
#' Ops functions for simple feature geometry objects (constrained to multiplication and addition)
#'
#' @param e1 object of class \code{sfg}
#' @param e2 numeric; in case of multiplication an n x n matrix, in case of addition or subtraction a vector of length n, with n the number of dimensions of the geometry
#'
#' @return object of class \code{sfg}
#' @export
#'
#' @examples
#' st_point(c(1,2,3)) + 4
#' st_point(c(1,2,3)) * 3 + 4
#' m = matrix(0, 2, 2)
#' diag(m) = c(1, 3)
#' # affine:
#' st_point(c(1,2)) * m + c(2,5)
Ops.sfg <- function(e1, e2) {
	if (nargs() == 1)
		stop(paste("unary", .Generic, "not defined for \"units\" objects"))

	prd <- switch(.Generic, "*" = TRUE, FALSE)
	pm  <- switch(.Generic, "+" = , "-" = TRUE, FALSE)
	if (!(prd || pm))
		stop("operation not supported for sfg objects")

	dims = nchar(class(e1)[1])
	Vec = rep(0, dims)
	Mat = matrix(0, dims, dims)
	diag(Mat) = 1
	if (pm) {
		if (length(e2) == 1)
			Vec = rep(e2, length.out = dims)
		else
			Vec = e2
		if (.Generic == "=")
			Vec = -Vec
	} else if (prd) {
		if (length(e2) == 1)
			diag(Mat) = e2
		else
			Mat = e2
	} 
	cls = class(e1)
	e1 = if (is.numeric(e1)) {
		if (prd) {
			if (inherits(e1, "POINT"))
				structure(as.vector(e1 %*% Mat), class = cls)
			else
				structure(e1 %*% Mat, class = cls)
		} else { # pm:
			if (is.matrix(e1))
				structure(t(t(unclass(e1)) + Vec), class = cls)
			else
				structure(unclass(e1) + Vec, class = cls)
		}
	} else # recurse:
		structure(lapply(e1, function(x) { 
			structure(
			if (is.list(x)) 
				lapply(x, function(y) {
					if (is.list(y))
						lapply(y, function(z) { z %*% Mat + Vec })
					else
						y %*% Mat + Vec
				})
			else
				x %*% Mat + Vec 
			, class = class(x))
		}),
			class = cls)
}

#' @export
Ops.sfc <- function(e1, e2) {
	ret = st_sfc(lapply(e1, function(x) NextMethod(.Generic, x, e2)))
	st_crs(ret) = NA_integer_
	ret
}
