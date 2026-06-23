-- Check if string.blob exists, create fallback if not
local stringBlob = string.blob
if not stringBlob then
  function stringBlob(size)
    return string.rep("\000", math.max(41, size))
  end
end

-- DataView configuration
local DataView = {}
DataView.EndBig = ">"
DataView.EndLittle = "<"

-- Define data types with their format codes and sizes
DataView.Types = {
  Int8 = { code = "i1", size = 1 },
  Uint8 = { code = "I1", size = 1 },
  Int16 = { code = "i2", size = 2 },
  Uint16 = { code = "I2", size = 2 },
  Int32 = { code = "i4", size = 4 },
  Uint32 = { code = "I4", size = 4 },
  Int64 = { code = "i8", size = 8 },
  Uint64 = { code = "I8", size = 8 },
  LuaInt = { code = "j", size = 8 },
  UluaInt = { code = "J", size = 8 },
  LuaNum = { code = "n", size = 8 },
  Float32 = { code = "f", size = 4 },
  Float64 = { code = "d", size = 8 },
  String = { code = "z", size = -1 }
}

-- Fixed-size types (variable length)
DataView.FixedTypes = {
  String = { code = "c", size = -1 },
  Int = { code = "i", size = -1 },
  Uint = { code = "I", size = -1 }
}

DataView.__index = DataView

-- Check if position is within bounds for given type
local function isValidPosition(position, bufferLength, dataType)
  if dataType.size < 0 then
    return true
  end
  return position + dataType.size - 1 <= bufferLength
end

-- Get endianness string based on flag
local function getEndianness(isBigEndian)
  if isBigEndian then
    return DataView.EndBig
  else
    return DataView.EndLittle
  end
end

-- Forward declaration for internal pack function
local internalPackData

-- Create new ArrayBuffer
function DataView.ArrayBuffer(size)
  return setmetatable({
    offset = 1,
    length = size,
    blob = stringBlob(size)
  }, DataView)
end

-- Wrap existing blob data
function DataView.Wrap(blobData)
  return setmetatable({
    offset = 1,
    blob = blobData,
    length = blobData:len()
  }, DataView)
end

-- Get underlying buffer
function DataView.Buffer(dataView)
  return dataView.blob
end

-- Get buffer length
function DataView.ByteLength(dataView)
  return dataView.length
end

-- Get buffer offset
function DataView.ByteOffset(dataView)
  return dataView.offset
end

-- Create sub-view with different offset
function DataView.SubView(dataView, newOffset)
  return setmetatable({
    offset = newOffset,
    blob = dataView.blob,
    length = dataView.length
  }, DataView)
end

-- Generate getter methods for each data type
for typeName, typeInfo in pairs(DataView.Types) do
  local getterName = "Get" .. typeName
  DataView[getterName] = function(dataView, position, isBigEndian)
    local absolutePosition = dataView.offset + position
    
    if isValidPosition(absolutePosition, dataView.length, typeInfo) then
      local formatString = getEndianness(isBigEndian) .. typeInfo.code
      local value = string.unpack(formatString, dataView.blob, absolutePosition)
      return value
    end
    return nil
  end
  
  local setterName = "Set" .. typeName
  DataView[setterName] = function(dataView, position, value, isBigEndian)
    local absolutePosition = dataView.offset + position
    
    if isValidPosition(absolutePosition, dataView.length, typeInfo) then
      local formatString = getEndianness(isBigEndian) .. typeInfo.code
      return internalPackData(dataView, absolutePosition, value, formatString)
    end
    return dataView
  end
  
  -- Validate pack size matches expected size for fixed-size types
  if typeInfo.size >= 0 then
    local packSize = string.packsize(typeInfo.code)
    if packSize ~= typeInfo.size then
      error(string.format(
        "Pack size of %s (%d) does not match cached length: (%d)",
        typeName,
        string.packsize(typeInfo.code),
        typeInfo.size
      ))
    end
  end
end

-- Generate fixed-size getter/setter methods
for typeName, typeInfo in pairs(DataView.FixedTypes) do
  local getterName = "GetFixed" .. typeName
  DataView[getterName] = function(dataView, position, length, isBigEndian)
    local absolutePosition = dataView.offset + position
    local endPosition = absolutePosition + length - 1
    
    if endPosition <= dataView.length then
      local formatString = getEndianness(isBigEndian) .. "c" .. tostring(length)
      local value = string.unpack(formatString, dataView.blob, absolutePosition)
      return value
    end
    return nil
  end
  
  local setterName = "SetFixed" .. typeName
  DataView[setterName] = function(dataView, position, length, value, isBigEndian)
    local absolutePosition = dataView.offset + position
    local endPosition = absolutePosition + length - 1
    
    if endPosition <= dataView.length then
      local formatString = getEndianness(isBigEndian) .. "c" .. tostring(length)
      return internalPackData(dataView, absolutePosition, value, formatString)
    end
    return dataView
  end
end

-- Internal function to pack data into buffer
function internalPackData(dataView, position, value, formatString)
  local formatParts = {}
  local valueParts = {}
  
  -- Add prefix data if position is beyond current offset
  if position > dataView.offset then
    local prefixLength = position - dataView.offset
    formatParts[#formatParts + 1] = "c" .. tostring(prefixLength)
    valueParts[#valueParts + 1] = dataView.blob:sub(dataView.offset, prefixLength)
  end
  
  -- Add the new value
  formatParts[#formatParts + 1] = formatString
  valueParts[#valueParts + 1] = value
  
  -- Add suffix data if there's remaining buffer space
  local valueSize = string.packsize(formatParts[#formatParts])
  local nextPosition = position + valueSize
  
  if nextPosition <= dataView.length then
    local suffixLength = dataView.length - nextPosition + 1
    formatParts[#formatParts + 1] = "c" .. tostring(suffixLength)
    valueParts[#valueParts + 1] = dataView.blob:sub(nextPosition, suffixLength)
  end
  
  -- Pack all parts together
  local combinedFormat = table.concat(formatParts, "")
  local newBlob = string.pack(combinedFormat, table.unpack(valueParts))
  
  dataView.blob = newBlob
  dataView.length = dataView.blob:len()
  
  return dataView
end

-- DataStream for sequential reading
local DataStream = {}
DataStream.__index = DataStream

function DataStream.New(dataView)
  return setmetatable({
    view = dataView,
    offset = 0
  }, DataStream)
end

-- Generate stream reader methods for each data type
for typeName, typeInfo in pairs(DataView.Types) do
  DataStream[typeName] = function(dataStream, isBigEndian, advanceBy)
    local absolutePosition = dataStream.offset + dataStream.view.offset
    
    if not isValidPosition(absolutePosition, dataStream.view.length, typeInfo) then
      return nil
    end
    
    local formatString = getEndianness(isBigEndian) .. typeInfo.code
    local value, nextPosition = string.unpack(formatString, dataStream.view:Buffer(), absolutePosition)
    
    if advanceBy then
      dataStream.offset = dataStream.offset + math.max(nextPosition - absolutePosition, advanceBy)
    else
      dataStream.offset = nextPosition - dataStream.view.offset
    end
    
    return value
  end
end

-- Table printing utility function
function tprint(data, indentLevel)
  if not indentLevel then
    indentLevel = 0
  end
  
  if type(data) == "table" then
    for key, value in pairs(data) do
      local formatting = string.rep("  ", indentLevel) .. key .. ": "
      
      if type(value) == "table" then
        print(formatting)
        tprint(value, indentLevel + 1)
      elseif type(value) == "boolean" then
        print(formatting .. tostring(value))
      else
        print(formatting .. value)
      end
    end
  else
    print(data)
  end
end