"""Pre-render do Notas: compila as figuras da coleção TikZ e regenera a galeria.

As figuras ficam em tikz/_build/ (gitignorado, recompilado no CI); o build é incremental
localmente (só recompila o que mudou). A galeria (tikz/index.qmd e tikz/categorias/*.qmd)
é gerada a partir de tikz/figuras/ + tikz/_build/.
"""
import subprocess
import sys
from pathlib import Path

TIKZ = Path(__file__).resolve().parent.parent / "tikz"
for script in ("build_figuras.py", "generate_gallery.py"):
    subprocess.run([sys.executable, str(TIKZ / "scripts" / script)], check=True, cwd=TIKZ)
