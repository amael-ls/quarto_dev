
-- Extract number from latex num command. s is a string
function Extract_num(s)
  s = string.gsub(s, " ", "")
  _, loc_start = string.find(s, "\\num{")

  if (loc_start ~= nil) then
    _, loc_end = string.find(s, "}", loc_start + 1)
    num = string.sub(s, loc_start + 1, loc_end - 1)
    return num
  end
  return nil
end

-- Format numbers
function Format_num(number, sep)
  -- Split the sign, the significand, and the fractional part
  local _, _, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')

  -- reverse the int-string and append the sep to all blocks of 3 digits
  int = int:reverse():gsub("(%d%d%d)", "%1" .. sep)

  -- reverse the int-string back remove an optional sep and put the optional minus and fractional part back
  return minus .. int:reverse():gsub("^" .. sep, "") .. fraction
end

--! THIS PARA FILTER MIGHT STILL HAVE BUGS
-- Filter to detect if there are spaces after '{' or before '}' in \num{ xyz } which would create problems
-- Para = function(element)
--   -- Function to process \num{...} and remove spaces within the braces, with anonymous function to remove spaces from the content within braces
--   local function process_latex_num(text)
--     return text:gsub("\\num%s*{([^}]*)}", function(num_content)
--       local trimmed_content = num_content:gsub("%s+", "")
--       return "\\num{" .. trimmed_content .. "}"
--     end)
--   end

--   -- Rebuild sentences from Para, keeping only words and spaces
--   local concatenate_str = ""
--   for _, inline in ipairs(element) do
--     if inline.t == "Str" then
--       concatenate_str = concatenate_str .. inline
--     elseif inline.t == "Space" then
--       concatenate_str = concatenate_str .. " "
--     end -- Do nothing for the other types that can be met in Para
--   end
  
--   -- Remove spurious spaces
--   concatenate_str = process_latex_num(concatenate_str)

--   -- Rebuild the Para object with the corrected \\num latex commands
--   local original_para = {}
--   for word in concatenate_str:gmatch("%S+") do
--     table.insert(original_para, pandoc.Str(word))
--     table.insert(original_para, pandoc.Space())
--   end
  
--   -- Remove the last added Space if present (by first checking that original_para is not empty)
--   if #original_para ~= 0 and original_para[#original_para].t == "Space" then
--     table.remove(original_para, #original_para)
--   end

--   -- Return the modified paragraph
--   element.content = original_para
--   return element
-- end

-- Filter to modify the output 
RawInline = function(element)
  if FORMAT:match 'html' then
    pos, _ = string.find(element.text, "\\num{")
    if pos ~= nil then
      return pandoc.Str(Format_num(Extract_num(element.text), " "))
    end
  end
  return element
end