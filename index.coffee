fs = require 'fs'
path = require 'path'

splitter = "%-------------------------------------------------------------------------------\n"

process = (filename) ->
  contents = fs.readFileSync(filename).toString()
  sections = contents.split splitter
  lines = sections[sections.length - 1]
  #console.log "data", data
  info = ""
  for section,i in sections
    if i == sections.length - 1
      break
    info += splitter
    info += section


  data = []
  for line,i in lines.split "\n"
    parts = line.split " "
    if i == 0
      console.log "first line", line
      meta = { rows: parts[0], cols: parts[1], value: parts[1], rowIndex: "source", colIndex: "target"}
    else
      if +parts[0] && +parts[1]
        data.push { source: +parts[0]-1, target: +parts[1]-1, value: +parts[1]}

  return {
    info: info
    meta: meta,
    data: data
  }

mtxdir = __dirname + "/mtx"
jsondir = __dirname + "/json"
list = []
files = fs.readdirSync mtxdir
files.forEach (file) ->
  ext = path.extname file
  base = path.basename file, ext
  if ext == ".mtx"
    list.push { name: base, url: "http://enjalot.github.io/sparse-matrix-zoo/json/" + base + ".json"}
    result = process path.join(mtxdir, file)
    fs.writeFileSync path.join(jsondir, base + ".json"), JSON.stringify(result)

fs.writeFileSync jsondir + "/list.json", JSON.stringify(list)
  