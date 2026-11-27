package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/modelcontextprotocol/go-sdk/mcp"
	sdk "github.com/voxgig-sdk/voxgig-solardemo-sdk/go"
)

func main() {
	transport := flag.String("transport", "stdio", "transport: stdio | http")
	addr := flag.String("addr", ":8080", "listen address for http transport")
	flag.Parse()

	// Configure from the environment, which a secrets vault can fill.
	// Unset -> nil config defaults.
	var opts map[string]any
	if base := os.Getenv("VOXGIG_SOLARDEMO_BASE"); base != "" {
		if opts == nil {
			opts = map[string]any{}
		}
		opts["base"] = base
	}
	client, err := sdk.NewVoxgigSolardemoSDK(opts)
	if err != nil {
		log.Fatal(err)
	}
	server := mcp.NewServer(
		&mcp.Implementation{
			Name:    "voxgig-solardemo",
			Version: "0.0.1",
		},
		nil,
	)
	registerTools(server, client)

	switch *transport {
	case "stdio":
		if err := server.Run(context.Background(), &mcp.StdioTransport{}); err != nil {
			log.Fatalf("stdio server: %v", err)
		}
	case "http":
		handler := mcp.NewStreamableHTTPHandler(
			func(r *http.Request) *mcp.Server { return server },
			nil,
		)
		log.Printf("MCP streamable HTTP server listening on %s", *addr)
		if err := http.ListenAndServe(*addr, handler); err != nil {
			log.Fatalf("http server: %v", err)
		}
	default:
		fmt.Fprintf(os.Stderr, "unknown transport %q (want stdio | http)\n", *transport)
		os.Exit(2)
	}
}
