from simple_term_menu import TerminalMenu
from pygments import formatters, highlight, lexers
from pygments.util import ClassNotFound
from rich.console import Console
from os import listdir, system, geteuid
from os.path import isfile, join
import sys
import subprocess

console = Console()

rootPlaybooks = [f for f in listdir("ansible") if isfile(join("ansible", f))]
normalPlaybooks = [
    f for f in listdir("ansible/no_root/") if isfile(join("ansible/no_root/", f))
]

lookup = {}
for i in rootPlaybooks:
    lookup[i.split(".")[0]] = join(f"ansible/{i}")

for i in normalPlaybooks:
    lookup[i.split(".")[0]] = join(f"ansible/no_root/{i}")

validPlaybook = normalPlaybooks
if geteuid() == 0:
    console.print("[bold]You are logged in as root.", style="#ff455e")
    validPlaybook.extend(rootPlaybooks)
else:
    console.print("[bold]You are logged in as a regular user.", style="#4e77fc")

validPlaybook.sort()

def previewCommand(name):
    path=lookup[name]
    with open(path, "r") as f:
        file_content = f.read()
    try:
        lexer = lexers.get_lexer_for_filename(path, stripnl=False, stripall=False)
    except ClassNotFound:
        lexer = lexers.get_lexer_by_name("text", stripnl=False, stripall=False)
    formatter = formatters.TerminalFormatter(bg="dark")  # dark or light
    text = highlight(file_content, lexer, formatter)
    return text

menu = TerminalMenu(
    [f.split(".")[0] for f in validPlaybook],
    multi_select=True,
    show_multi_select_hint=True,
    multi_select_select_on_accept=False,
    multi_select_empty_ok=True,
    preview_command=previewCommand,
    preview_size=0.5,
)
indices = menu.show()

if indices == None:
    sys.exit(0)

for i in indices:
    file = lookup[validPlaybook[i].split(".")[0]]

    p = subprocess.Popen(f"ansible-playbook {file}", shell=True)
    p.wait()
    if p.returncode != 0:
        sys.exit(1)
