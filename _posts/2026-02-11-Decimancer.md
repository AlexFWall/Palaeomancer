---
layout: post
title: "Decimal degrees conversion tool"
date: 2026-02-11
---
I made a tool to convert spreadsheets of coordinates into decimal degrees. A version of the parser is below; follow the link to convert csv or (yuck) excel files.

-

For about the 137th time, I found exactly the data I was looking for, but the coordinates were recorded in a mix of Degrees, Minutes, Seconds; Decimal Minutes; and Decimal Degrees with just appalling formatting. I mean, lowercase o's for degree symbols, copy/paste jobs resulting in whatever "¬" is.

Until now, I've always typed abominations like this into an online converter. But this chore is evergreen, so I decided to put in a little more effort so I'd never have to spend more than a few moments on it again. I created Decimancer, a little tool that tries its darnedest to make sense of strings of numbers to spit out nicely formatted decimal degrees. Try it out!

<div id="deci-widget" style="border:2px solid #58B62C; border-radius:8px; padding:1em; margin:1.5em 0; background:#f9fff4; font-family:Arial,sans-serif; font-size:0.95em;">
  <div style="display:flex; align-items:center; margin-bottom:0.6em;">
    <strong style="color:#58B62C; font-size:1.1em;">Quick Convert</strong>
    <span style="margin-left:auto; font-size:0.8em; opacity:0.6;">Powered by <a href="https://alexfwall.shinyapps.io/Decimancer/" target="_blank" rel="noopener noreferrer" style="color:#58B62C;">Decimancer</a></span>
  </div>
  <textarea id="deci-input" rows="3" placeholder="e.g.  33&#176;51'54&quot;S, 151&#176;12'36&quot;E" style="width:100%; box-sizing:border-box; font-family:monospace; font-size:0.95em; padding:0.5em; border:1px solid #ccc; border-radius:4px; resize:vertical;"></textarea>
  <table id="deci-output" style="width:100%; border-collapse:collapse; margin-top:0.5em; font-size:0.9em; display:none;">
    <thead>
      <tr style="background:#58B62C; color:white;">
        <th style="padding:0.3em 0.5em; text-align:left;">Input</th>
        <th style="padding:0.3em 0.5em; text-align:right;">Latitude&nbsp;DD</th>
        <th style="padding:0.3em 0.5em; text-align:right;">Longitude&nbsp;DD</th>
      </tr>
    </thead>
    <tbody id="deci-tbody"></tbody>
  </table>
  <p id="deci-placeholder" style="color:#999; font-size:0.85em; margin:0.5em 0 0 0;">Results appear as you type.</p>
</div>

For batch conversion of entire spreadsheets, head over to the full <a href="https://alexfwall.shinyapps.io/Decimancer/" target="_blank" rel="noopener noreferrer">Decimancer</a> app.

<script>
(function () {
  /* ---- Coordinate parser (mirrors the R version) ---- */
  function parseCoord(s) {
    s = s.trim();
    if (!s) return NaN;
    var n = parseFloat(s);
    if (!isNaN(n) && /^[+\-]?\d+\.?\d*$/.test(s)) return n;

    var hemi = "";
    var m = s.match(/^([NSEWnsew])\s*/);
    if (m) { hemi = m[1].toUpperCase(); s = s.slice(m[0].length); }
    m = s.match(/\s*([NSEWnsew])\s*$/);
    if (m) { hemi = m[1].toUpperCase(); s = s.slice(0, -m[0].length); }

    var neg = false;
    if (/^[\-\u2212]/.test(s)) { neg = true; s = s.slice(1).trim(); }
    else if (/^\+/.test(s)) { s = s.slice(1).trim(); }

    var tok = s.match(/\d+\.?\d*/g);
    if (!tok) return NaN;
    var v = tok.map(Number), dd;
    if (v.length === 1) dd = v[0];
    else if (v.length === 2) { if (v[1] >= 60) return NaN; dd = v[0] + v[1] / 60; }
    else { if (v[1] >= 60 || v[2] >= 60) return NaN; dd = v[0] + v[1] / 60 + v[2] / 3600; }

    if (neg) dd = -dd;
    if (hemi === "S" || hemi === "W") dd = -dd;
    return dd;
  }

  function parseLine(line) {
    line = line.trim();
    if (!line) return null;

    /* delimiter split */
    var ds = [",", "\t", ";", "/"];
    for (var i = 0; i < ds.length; i++) {
      if (line.indexOf(ds[i]) !== -1) {
        var pp = line.split(ds[i]);
        if (pp.length === 2) {
          var a = parseCoord(pp[0]), b = parseCoord(pp[1]);
          if (!isNaN(a) || !isNaN(b)) return { input: line, lat: a, lon: b };
        }
      }
    }

    /* hemisphere-boundary split */
    var hl = [];
    for (var j = 0; j < line.length; j++) if ("NSEWnsew".indexOf(line[j]) !== -1) hl.push(j);
    if (hl.length === 2) {
      var p1 = line.slice(0, hl[0] + 1).trim(), p2 = line.slice(hl[0] + 1).trim();
      var x1 = parseCoord(p1), x2 = parseCoord(p2);
      if (!isNaN(x1) && !isNaN(x2)) return { input: line, lat: x1, lon: x2 };
      p1 = line.slice(0, hl[1]).trim(); p2 = line.slice(hl[1]).trim();
      x1 = parseCoord(p1); x2 = parseCoord(p2);
      if (!isNaN(x1) && !isNaN(x2)) return { input: line, lat: x1, lon: x2 };
    }

    /* single coordinate */
    var sc = parseCoord(line);
    if (!isNaN(sc)) return { input: line, lat: sc, lon: NaN };

    /* even-chunk split */
    var nums = line.match(/\d+\.?\d*/g) || [];
    var hAll = (line.match(/[NSEWnsew]/g) || []).map(function (c) { return c.toUpperCase(); });
    if (nums.length >= 2 && nums.length % 2 === 0) {
      var mid = nums.length / 2;
      var s1 = nums.slice(0, mid).join(" ") + (hAll.length >= 1 ? " " + hAll[0] : "");
      var s2 = nums.slice(mid).join(" ") + (hAll.length >= 2 ? " " + hAll[1] : "");
      var e1 = parseCoord(s1), e2 = parseCoord(s2);
      if (!isNaN(e1) || !isNaN(e2)) return { input: line, lat: e1, lon: e2 };
    }
    return { input: line, lat: NaN, lon: NaN };
  }

  /* ---- UI wiring ---- */
  var box   = document.getElementById("deci-input");
  var tbl   = document.getElementById("deci-output");
  var tbody = document.getElementById("deci-tbody");
  var ph    = document.getElementById("deci-placeholder");

  function fmt(v) { return isNaN(v) ? "—" : v.toFixed(5); }

  box.addEventListener("input", function () {
    var lines = box.value.split("\n").filter(function (l) { return l.trim() !== ""; });
    tbody.innerHTML = "";
    if (lines.length === 0) { tbl.style.display = "none"; ph.style.display = ""; return; }
    tbl.style.display = ""; ph.style.display = "none";
    lines.forEach(function (l) {
      var r = parseLine(l);
      if (!r) return;
      var tr = document.createElement("tr");
      tr.innerHTML =
        '<td style="padding:0.3em 0.5em; border-bottom:1px solid #e0e0e0;">' + r.input.replace(/</g,"&lt;") + "</td>" +
        '<td style="padding:0.3em 0.5em; border-bottom:1px solid #e0e0e0; text-align:right; background:#d4edda;">' + fmt(r.lat) + "</td>" +
        '<td style="padding:0.3em 0.5em; border-bottom:1px solid #e0e0e0; text-align:right; background:#d4edda;">' + fmt(r.lon) + "</td>";
      tbody.appendChild(tr);
    });
  });
})();
</script>
