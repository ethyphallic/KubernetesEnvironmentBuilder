from experiment_runner.sink.sli_storage_sink import SliStorageSink

if __name__ == '__main__':
    testee = SliStorageSink("abcde", "test", False)

    testee.evaluate_slo(32, 0, True)
    testee.evaluate_slo(33, 0, True)
    testee.evaluate_slo(34, 0, True)
    testee.evaluate_slo(35, 0, True)

    testee.end_hook()
