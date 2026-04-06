#include "oxorany.h"
#include <cstddef>

_lxy__size_t& _lxy_oxor_any_::X() {
    static _lxy__size_t x = 0;
    return x;
}

_lxy__size_t& _lxy_oxor_any_::Y() {
    static _lxy__size_t y = 0;
    return y;
}