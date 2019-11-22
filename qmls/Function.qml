pragma Singleton
import QtQml 2.13

QtObject {

    function thousandSeparator(value, decimal) {
        var nvalue = Number(value);
        if(isNaN(nvalue)) {
            return value;
        }
        var ndecimal = Number(decimal);
        if(isNaN(ndecimal)) {
            ndecimal = 0
        }
        return (nvalue.toFixed(ndecimal) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
    }
}
