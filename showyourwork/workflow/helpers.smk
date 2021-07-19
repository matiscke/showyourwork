import showyourwork
from showyourwork.utils import glob
from showyourwork.constants import TEMP, PROJECT, USER, FIGURE_EXTENSIONS
from pathlib import Path


def figure_scripts():
    return showyourwork.meta.get_script_metadata(clobber=False)[
        "figures"
    ].values()


def figures(wildcards):
    checkpoints.script_info.get(**wildcards)
    figures = []
    for entry in figure_scripts():
        figures += entry["files"]
    return figures


def figure_script(wildcards):
    checkpoints.script_info.get(**wildcards)
    figure = wildcards.figure
    for entry in figure_scripts():
        if figure in entry["files"]:
            return entry["script"]
    raise ValueError(
        "Input script not found for output figure `{}`.".format(figure)
    )


def cache_cmd(wildcards, input, output):
    other = []
    for entry in figure_scripts():
        if entry["script"] == input[0]:
            other = [
                Path(file).name for file in entry["files"] if file != output[0]
            ]
    return " && ".join(
        [f"mv {file} {TEMP / PROJECT / 'figures'}" for file in other]
    )


def cached_figure(wildcards, input, output):
    return str(TEMP / PROJECT / output[0])


def script_name(wildcards, input):
    return Path(input[0]).name


def run_pdf():
    showyourwork.utils.make_pdf(
        tmpdir=TEMP / PROJECT / "tex",
        publish=True,
        **showyourwork.meta.get_metadata(clobber=False),
    )


def run_user_info():
    showyourwork.meta.get_user_metadata(clobber=True)


def run_repo_info():
    showyourwork.meta.get_repo_metadata(clobber=True)


def run_script_info():
    showyourwork.meta.get_script_metadata(clobber=True)


def run_metadata():
    showyourwork.meta.get_metadata(clobber=True)
