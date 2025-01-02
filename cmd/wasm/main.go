package main

import (
	"encoding/json"
	"syscall/js"

	"github.com/yashp5/preciouslang/lexer"
	"github.com/yashp5/preciouslang/token"
)

type Token struct {
	Type    string `json:"type"`
	Literal string `json:"literal"`
}

func evaluate(this js.Value, args []js.Value) interface{} {
	if len(args) == 0 {
		return nil
	}

	input := args[0].String()
	l := lexer.New(input)

	var tokens []Token

	for tok := l.NextToken(); tok.Type != token.EOF; tok = l.NextToken() {
		tokens = append(tokens, Token{
			Type:    string(tok.Type),
			Literal: string(tok.Literal),
		})
	}

	// Convert to JSON
	jsonBytes, err := json.Marshal(tokens)
	if err != nil {
		return "Error: " + err.Error()
	}

	// Parse JSON in JavaScript
	return js.Global().Get("JSON").Call("parse", string(jsonBytes))
}

func main() {
	js.Global().Set("evaluateLang", js.FuncOf(evaluate))
	select {}
}
