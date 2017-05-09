// The IMaps class defines static methods for the IMap<K,V> type.
// In particular, it defines static factory methods for creating
// empty maps of the IMap<K,V> type.

import java.util.Iterator;

import java.util.Comparator;

class IMaps {

    private static IMap theEmptyIMap = new IMapList();

    // static factory methods for creating an empty IMap<K,V>

    @SuppressWarnings("unchecked")
    public static <K,V> IMap<K,V> empty () {
        return (IMap<K,V>) theEmptyIMap;
    }

}