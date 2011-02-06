

function distance(x1,y1,x2,y2)
  local x = x1 - x2
  local y = y1 - y2
  return math.sqrt(x*x + y*y)
end

function scalar(x1,y1,x2,y2)
  return x1*x2 + y1*y2
end

function isin(x,y,x1,y1,w1,h1)
  return x >= x1 and y >= y1 and x < x1 + w1 and y < y1 + h1
end

function calcAngle(x1,y1,x2,y2)
    local len1 = math.sqrt(x1 * x1 + y1 * y1)
    local len2 = math.sqrt(x2 * x2 + y2 * y2)

    x1 = x1 / len1
    y1 = y1 / len1

    x2 = x2 / len2
    y2 = y2 / len2

    return math.acos(x1 * x2 + y1 * y2)
end