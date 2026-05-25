local core = require("snippetlib.core")

local sn = core.sn
local t = core.t
local i = core.i
local r = core.r

local M = {}

local function matrix_dimension(capture)
  local value = tonumber(capture)
  if not value or value < 1 or value ~= math.floor(value) then
    return nil
  end
  return value
end

function M.latex(_, snip)
  local rows = matrix_dimension(snip.captures[1])
  local cols = matrix_dimension(snip.captures[2])
  if not rows or not cols then
    return sn(nil, { i(1) })
  end

  local nodes = {}
  local ins_indx = 1
  for j = 1, rows do
    table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
    ins_indx = ins_indx + 1
    for k = 2, cols do
      table.insert(nodes, t(" & "))
      table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
      ins_indx = ins_indx + 1
    end
    if j < rows then
      table.insert(nodes, t({ "\\\\", "" }))
    end
  end
  return sn(nil, nodes)
end

function M.typst(_, snip)
  local rows = matrix_dimension(snip.captures[1])
  local cols = matrix_dimension(snip.captures[2])
  if not rows or not cols then
    return sn(nil, { i(1) })
  end

  local nodes = {}
  local ins_indx = 1
  for j = 1, rows do
    table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
    ins_indx = ins_indx + 1
    for k = 2, cols do
      table.insert(nodes, t(" , "))
      table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
      ins_indx = ins_indx + 1
    end
    if j < rows then
      table.insert(nodes, t({ ";", "" }))
    end
  end
  return sn(nil, nodes)
end

return M
