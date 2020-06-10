%dw 2.0

var GC_CreationStatusMap = {
	"created": "GC_CREATE",
	"updated": "GC_MODIFY",
	"deleted": "GC_DELETE",
	"undefined": "GC_ERR"
}
