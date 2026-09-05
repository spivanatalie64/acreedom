#!/usr/bin/env python3
"""Apply Acreedom product names while retaining upstream license attribution."""
from pathlib import Path
import re

sources = [p for p in Path("output").glob("icecat-*") if p.is_dir()]
if len(sources) != 1:
    raise SystemExit(f"Expected one prepared source directory, found {sources}")
source = sources[0]
branding = source / "browser/branding/official"
config = branding / "configure.sh"
text = config.read_text()
assert "MOZ_APP_DISPLAYNAME=IceCat" in text
config.write_text(text.replace("MOZ_APP_DISPLAYNAME=IceCat", "MOZ_APP_DISPLAYNAME=Acreedom"))
confvars = source / "browser/confvars.sh"
text = confvars.read_text()
assert "MOZ_APP_BASENAME=IceCat" in text
confvars.write_text(text.replace("MOZ_APP_BASENAME=IceCat", "MOZ_APP_BASENAME=Acreedom"))
for path in [*branding.rglob("brand.ftl"), *branding.rglob("brand.properties")]:
    lines = path.read_text().splitlines(keepends=True)
    path.write_text("".join(
        line.replace("GNU IceCat", "Acreedom").replace("IceCat", "Acreedom")
        if re.match(r"\s*(?:-brand-|brand(?:Short|Full|Product))", line) else line
        for line in lines
    ))
(source / ".mozconfig").write_text("""ac_add_options --enable-application=browser
ac_add_options --enable-official-branding
ac_add_options --with-app-name=acreedom
ac_add_options --with-app-basename=Acreedom
ac_add_options --with-distribution-id=org.acreetionos
ac_add_options --disable-debug
ac_add_options --disable-tests
ac_add_options --disable-updater
ac_add_options --disable-crashreporter
ac_add_options --disable-eme
mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/obj-acreedom
mk_add_options MOZ_MAKE_FLAGS=-j2
""")
print(f"Prepared Acreedom branding in {source}; upstream artwork and notices retained.")
