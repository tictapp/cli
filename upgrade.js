// Copyright 2021 Deno Land Inc. All rights reserved. MIT license.

import { error } from "./error.js";
import { semverGreaterThanOrEquals, semverValid } from "./deps.js";
import { VERSION } from "./version.js";
import * as path from "https://deno.land/std@0.57.0/path/mod.ts";

const help = `tictapp upgrade
Upgrade tictapp to the given version (defaults to latest).

To upgrade to latest version:
tictapp upgrade

To upgrade to specific version:
tictapp upgrade 1.2.3

The version is downloaded from https://deno.land/x/tictapp/tictapp.js

USAGE:
  tictapp upgrade [OPTIONS] [<version>]

OPTIONS:
    -h, --help        Prints help information

ARGS:
    <version>         The version to upgrade to (defaults to latest)
`;

export default async function (rawArgs) {
  const args = {
    help: !!rawArgs.help,
  };
  const version = typeof rawArgs._[0] === "string" ? rawArgs._[0] : null;
  if (args.help) {
    console.log(help);
    Deno.exit();
  }
  if (rawArgs._.length > 1) {
    console.error(help);
    error("Too many positional arguments given.");
  }
  if (version && !semverValid(version)) {
    error(`The provided version is invalid.`);
  }

  const { latest, versions } = await getVersions().catch((err) => {
    error(err.message);
  });
  if (version && !versions.includes(version)) {
    error(
      "The provided version is not found.\n\nVisit https://github.com/serebano/tictapp-cli/releases/ for available releases.",
    );
  }

  if (!version && semverGreaterThanOrEquals(VERSION, latest)) {
    console.log("You're using the latest version.", latest);
    Deno.exit();
  } else {
    console.log("Installing the latest version.", latest);
    const process = Deno.run({
      cmd: [
        Deno.execPath(),
        "install",
        "--allow-read",
        "--allow-write",
        "--allow-env",
        "--allow-net",
        "--allow-run",
        "--no-check",
        "-f",
        `https://deno.land/x/tictapp@${version ? version : latest}/tictapp.js`,
      ],
    });
    await process.status();

    const binPath = path.dirname(Deno.execPath())

    console.log("Creating 'tt' symlink.");
    const process1 = Deno.run({
      cmd: [
        "ln",
        "-s",
        `${binPath}/tictapp`,
        `${binPath}/tt`,
      ],
    });
    await process1.status();
  }
}

export async function getVersions() {
  const aborter = new AbortController();
  const timer = setTimeout(() => aborter.abort(), 2500);
  const response = await fetch(
    "https://cdn.deno.land/tictapp/meta/versions.json",
    { signal: aborter.signal },
  );
  if (!response.ok) {
    throw new Error(
      "couldn't fetch the latest version - try again after sometime",
    );
  }
  const data = await response.json();
  clearTimeout(timer);
  return data;
}
