from svc_operator.operator_core import OperatorCore

if __name__ == '__main__':
    OperatorCore(
        base_directory="../build/sut/base",
        patch_directory="../build/sut/resourceChaos",
        reaction_delay=30,
        elasticity_time=15
    ).run()