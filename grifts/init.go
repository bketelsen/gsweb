package grifts

import (
	"github.com/gobuffalo/buffalo"
	"github.com/gophersnacks/gsweb/actions"
)

func init() {
	buffalo.Grifts(actions.App())
}
