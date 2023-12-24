# expr

### simple expression lexer & parser in lua

### example

```lua
local lexer = Lexer.new("2 / 2")
local tokens = lexer:lex()
local parser = Parser.new(tokens)

for index, token in ipairs(tokens) do
    print("-----------------------")
    print("Type:", token.type)
    print("Value:", token.value)
    print("-----------------------")
end

local result = parser:parse_expression()

print("Result:", result)
```

```
-----------------------
Type:   NUMBER
Value:  2
-----------------------
-----------------------
Type:   OTHER
Value:  /
-----------------------
-----------------------
Type:   NUMBER
Value:  2
-----------------------
Result: 1
```
