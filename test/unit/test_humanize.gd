extends GutTest


func test_elapsed_time_hh_ss():
    assert_eq(Humanize.elapsed_time_hh_ss(0.0), "00:00.00")
    assert_eq(Humanize.elapsed_time_hh_ss(10.0), "00:10.00")
    assert_eq(Humanize.elapsed_time_hh_ss(123.45), "02:03.45")


func test_place():
    assert_eq(Humanize.place(1), "1st")
    assert_eq(Humanize.place(2), "2nd")
    assert_eq(Humanize.place(3), "3rd")

    for i in range(4, 21):
        assert_eq(Humanize.place(i), "%dth" % i)
    
    assert_eq(Humanize.place(21), "21st")
    assert_eq(Humanize.place(22), "22nd")
    assert_eq(Humanize.place(23), "23rd")

    for i in range(24, 31):
        assert_eq(Humanize.place(i), "%dth" % i)
    
    assert_eq(Humanize.place(13551), "13551st")
    assert_eq(Humanize.place(792), "792nd")
    assert_eq(Humanize.place(613), "613rd")
    assert_eq(Humanize.place(1434), "1434th")