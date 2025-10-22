#!/usr/bin/env node
const { spawn } = require('node:child_process');
const path = require('node:path');
const os = require('node:os');
const fs = require('node:fs');

const binDir = path.join(__dirname, '..', 'bin');
const exe = os.platform() === 'win32' ? 'snailer.exe' : 'snailer';
const bin = path.join(binDir, exe);

if (!fs.existsSync(bin)) {
  console.error('[snailer] Binary is missing. Reinstall or download from Releases.');
  process.exit(1);
}

const child = spawn(bin, process.argv.slice(2), { stdio: 'inherit' });
child.on('exit', (code) => process.exit(code));
