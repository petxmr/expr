local Lexer = {}

function Lexer.new(input: string)
    local self = setmetatable({}, { __index = Lexer })
    self.input = input
    self.position = 1
    self.current_char = self.input:sub(self.position, self.position)
    return self
end

function Lexer:lex()
    if string.len(self.input) == 0 then
        return nil
    end

    local tokens = {}

    while self.position <= string.len(self.input) do
        self.current_char = self.input:sub(self.position, self.position)

        if self.current_char:match("%d") then
            local num = ""
            while self.current_char and self.current_char:match("%d") do
                num = num .. self.current_char
                self.position = self.position + 1
                self.current_char = self.input:sub(self.position, self.position)
            end
            table.insert(tokens, { type = "NUMBER", value = tonumber(num) })
        elseif self.current_char:match("%s") then
            self.position = self.position + 1
        else
            table.insert(tokens, { type = "OTHER", value = self.current_char })
            self.position = self.position + 1
        end
    end

    return tokens
end

local Parser = {}

function Parser.new(tokens)
    local self = setmetatable({}, { __index = Parser })
    self.tokens = tokens
    self.current_index = 1
    self:advance()
    return self
end

function Parser:parse_number()
    local value = self.current_token.value
    self:advance()
    return value
end

function Parser:parse_expression()
    local left = tonumber(self:parse_number())

    while self.current_token and self.current_token.type == "OTHER" and (self.current_token.value == '+' or self.current_token.value == '-' or self.current_token.value == '/' or self.current_token.value == '*') do
        local operator = self.current_token.value
        self:advance()
        local right = tonumber(self:parse_number())

        if operator == '+' then
            left = left + right
        elseif operator == '*' then
            left = left * right
        elseif operator == '/' then
            if (right == 0) then
                return "Divisable by zero"
            end

            left = left / right
        elseif operator == '-' then
            left = left - right
        end
    end

    return left
end

function Parser:advance()
    self.current_token = self.tokens[self.current_index]
    self.current_index = self.current_index + 1
end

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
