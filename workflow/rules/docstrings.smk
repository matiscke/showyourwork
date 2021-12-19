rule docstrings:
    """
    Generates simple documentation for the rules in this workflow. This
    rule is called when building the API documentation, but only when running
    it locally (since we do not install ``Snakemake``, or ``conda`` for that
    matter, on ``ReadTheDocs``). Therefore, we should build the documentation
    locally from time to time and push changes to the ``rules.rst`` file
    containing these docstrings so that our online docs are up to date.

    """
    run:
        rules_rst = abspaths.workflow.parents[0] / "docs" / "rules.rst"
        if not rules_rst.exists():
            rules_rst = abspaths.workflow.parents[2] / "docs" / "rules.rst"
        if not rules_rst.exists():
            raise ValueError("Can't find `docs/rules.rst`.")
        with open(rules_rst, "w") as f:
            for rule in workflow.rules:
                try:
                    int(rule.name)
                except ValueError:
                    # We're good
                    pass
                else:
                    # This is an anonymous rule (its name is
                    # a number), so let's skip it
                    continue
                header = "rule {}".format(rule.name)
                print(header, file=f)
                print("^" * len(header), file=f)
                if rule.docstring:
                    for line in rule.docstring.split("\n"):
                        print(line.strip(), file=f)
                print("\n", file=f)