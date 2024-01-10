Application.ensure_all_started(:red_cache)
Test.Cache.start_link([])
ExUnit.start()
