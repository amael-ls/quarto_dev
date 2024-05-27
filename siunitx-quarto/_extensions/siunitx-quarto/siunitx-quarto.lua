
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
  num = s[1]
  unit = s[2]

  -- Check the format of num
  -- ! TO DO: If num contains something like 10^{x} then I need to treat it
  
  -- metric prefixes
  -- ... Small first (negative power of 10)
  unit = string.gsub(unit, "\\quecto", "q")        -- -30
  unit = string.gsub(unit, "\\ronto",  "r")        -- -27
  unit = string.gsub(unit, "\\yocto",  "y")        -- -24
  unit = string.gsub(unit, "\\zepto",  "z")        -- -21
  unit = string.gsub(unit, "\\atto",   "a")        -- -18
  unit = string.gsub(unit, "\\femto",  "f")        -- -15
  unit = string.gsub(unit, "\\pico",   "p")        -- -12
  unit = string.gsub(unit, "\\nano",   "n")        --  -9
  unit = string.gsub(unit, "\\micro",  "\194\181") --  -6
  unit = string.gsub(unit, "\\milli",  "m")        --  -3
  unit = string.gsub(unit, "\\centi",  "c")        --  -2
  unit = string.gsub(unit, "\\deci",   "d")        --  -1

  -- ... Large second (positive power of 10)
  unit = string.gsub(unit, "\\deca",   "da") -- 1
  unit = string.gsub(unit, "\\deka",   "da") -- 1
  unit = string.gsub(unit, "\\hecto",  "h")  -- 2
  unit = string.gsub(unit, "\\kilo",   "k")  -- 3
  unit = string.gsub(unit, "\\mega",   "M")  -- 6
  unit = string.gsub(unit, "\\giga",   "G")  -- 9
  unit = string.gsub(unit, "\\tera",   "T")  -- 12
  unit = string.gsub(unit, "\\peta",   "P")  -- 15
  unit = string.gsub(unit, "\\exa",    "E")  -- 18
  unit = string.gsub(unit, "\\zetta",  "Z")  -- 21
  unit = string.gsub(unit, "\\yotta",  "Y")  -- 24
  unit = string.gsub(unit, "\\ronna",  "R")  -- 27
  unit = string.gsub(unit, "\\quetta", "Q")  -- 30

  -- Units
  -- ... SI units
  unit = string.gsub(unit, "\\kilogram", "kg")
  unit = string.gsub(unit, "\\metre",    "m")
  unit = string.gsub(unit, "\\meter",    "m") -- metre is the SI recognised spelling, but US english uses meter
  unit = string.gsub(unit, "\\mole",     "mol")
  unit = string.gsub(unit, "\\second",   "s")
  unit = string.gsub(unit, "\\ampere",   "A")
  unit = string.gsub(unit, "\\kelvin",   "K")
  unit = string.gsub(unit, "\\candela",  "cd")

  unit = string.gsub(unit, "\\gram", "g") -- Technically non SI, but put here in case of \kilo\gram instead of \kilogram

  -- ... Derived units, by alphabetical order
  unit = string.gsub(unit, "\\becquerel", "Bq")
  unit = string.gsub(unit, "\\degreeCelsius", "\194\176C")
  unit = string.gsub(unit, "\\coulomb",   "C")
  unit = string.gsub(unit, "\\farad",     "F")
  unit = string.gsub(unit, "\\gray",      "Gy")
  unit = string.gsub(unit, "\\hertz",     "Hz")
  unit = string.gsub(unit, "\\henry",     "H")
  unit = string.gsub(unit, "\\joule",     "J")
  unit = string.gsub(unit, "\\katal",     "kat")
  unit = string.gsub(unit, "\\lumen",     "lm")
  unit = string.gsub(unit, "\\lux",       "lx")

  unit = string.gsub(unit, "\\newton",    "N")
  unit = string.gsub(unit, "\\ohm",       "\226\132\166")
  unit = string.gsub(unit, "\\pascal",    "Pa")
  unit = string.gsub(unit, "\\radian",    "rad")
  unit = string.gsub(unit, "\\siemens",   "S")
  unit = string.gsub(unit, "\\sievert",   "Sv")
  unit = string.gsub(unit, "\\steradian", "sr")
  unit = string.gsub(unit, "\\tesla",     "T")
  unit = string.gsub(unit, "\\volt",      "V")
  unit = string.gsub(unit, "\\watt",      "W")
  unit = string.gsub(unit, "\\weber",     "Wb")

  -- ... Non SI units accepted for use with the International System of Units.
  unit = string.gsub(unit, "\\astronomicalunit", "au")
  unit = string.gsub(unit, "\\bel",              "B")
  unit = string.gsub(unit, "\\decibel",          "dB")
  unit = string.gsub(unit, "\\dalton",           "Da")
  unit = string.gsub(unit, "\\day",              "d")
  unit = string.gsub(unit, "\\electronvolt",     "eV")
  unit = string.gsub(unit, "\\hectare",          "ha")
  unit = string.gsub(unit, "\\hour",             "h")
  unit = string.gsub(unit, "\\litre",            "L")
  unit = string.gsub(unit, "\\liter",            "L")
  unit = string.gsub(unit, "\\minute",           "min")
  unit = string.gsub(unit, "\\neper",            "Np")
  unit = string.gsub(unit, "\\tonne",            "t")

  -- ... Arc units
  unit = string.gsub(unit, "\\arcminute", "\202\185")
  unit = string.gsub(unit, "\\arcsecond", "\202\186")
  unit = string.gsub(unit, "\\degree", "\194\176")
  
  -- ... Percent
  unit = string.gsub(unit, "\\percent", "%%") -- This sign must be escaped with a second percent in Lua

  --! TO DO LIST:
  -- 1. Manage the spacing
  -- 2. Manage power
  -- 3. Manage the \per command that put a power minus sign to the next unit
  -- 4. Manage the dot and slash

  --! TO DO: Sometimes a space will be required between the number and its units, sometimes not!
  return num .. unit
end

-- Filter to modify the output 
RawInline = function(element)
  if FORMAT:match 'html' then
    -- Handling the \num command
    pos, _ = string.find(element.text, "\\num{")
    if pos ~= nil then
      return pandoc.Str(Format_num(Extract_content(element.text, "num")[1], " "))
    end

  -- Handling the \qty{}{} command, the same should apply to \SI and \si commands although outdated
    pos, _ = string.find(element.text, "\\qty{")
    if pos ~= nil then
      return pandoc.Str(Format_units(Extract_content(element.text, "qty")))
    end
  end
  return element
end