
-- Extract content between {} of Latex command. s is a string.
local function Extract_content(s, command)
  s = string.gsub(s, " ", "")
  _, loc_start = string.find(s, "\\" .. command .. "{")

  content_cmd = {}
  while (loc_start ~= nil) do
    _, loc_end = string.find(s, "}", loc_start + 1)
    content_cmd[#content_cmd + 1] = string.sub(s, loc_start + 1, loc_end - 1) -- append
    _, loc_start = string.find(s, "{", loc_end + 1)
  end

  return content_cmd
end

-- Format numbers
local function Format_num(number, sep)
  -- Split the sign, the significand, and the fractional part
  local _, _, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')

  -- reverse the int-string and append the sep to all blocks of 3 digits
  int = int:reverse():gsub("(%d%d%d)", "%1" .. sep)

  -- reverse the int-string back remove an optional sep and put the optional minus and fractional part back
  return minus .. int:reverse():gsub("^" .. sep, "") .. fraction
end

-- Format units
local function Format_units(s)
  print("print from Format_units = " .. s)
  return "lala"
end

-- Filter to modify the output 
RawInline = function(element)
  if FORMAT:match 'html' then
    -- Handling the \num command
    pos, _ = string.find(element.text, "\\num{")
    if pos ~= nil then
      return pandoc.Str(Format_num(Extract_content(element.text, "num")[1], " "))
    end

  --   -- Handling the \qty{}{} command, the same should apply to \SI and \si commands although outdated
    pos, _ = string.find(element.text, "\\qty{")
    if pos ~= nil then
      return pandoc.Str(Format_units(Extract_content(element.text, "qty")[1])) -- ! RESTART HERE. pandoc.Para ???
    end
  end
  return element
end