# Variables
GOROOT=$(shell go env GOROOT)
WASM_EXEC=$(GOROOT)/misc/wasm/wasm_exec.js
WASM_DIR=cmd/wasm
WEBSITE_DIR=website
WASM_FILE=main.wasm

.PHONY: all clean wasm website

all: wasm website

# Build the WebAssembly file
wasm:
	GOOS=js GOARCH=wasm go build -o $(WASM_DIR)/$(WASM_FILE) ./$(WASM_DIR)

# Set up the website directory
website: wasm
	# Copy wasm_exec.js from Go installation
	cp $(WASM_EXEC) $(WEBSITE_DIR)/
	# Copy the compiled wasm file
	cp $(WASM_DIR)/$(WASM_FILE) $(WEBSITE_DIR)/

# Clean build artifacts
clean:
	rm -f $(WASM_DIR)/$(WASM_FILE)
	rm -f $(WEBSITE_DIR)/$(WASM_FILE)
	rm -f $(WEBSITE_DIR)/wasm_exec.js

# Run a local server for testing
serve:
	cd $(WEBSITE_DIR) && python3 -m http.server 8080
