const station = getStations.data.find(station => station.id === stationLocksSelect.value);

if (station) {
    const rows = [
        { Statistics : "Total number of locks", "col2" :  station.lockCount},
        { Statistics : "Number of free locks", "col2" :  station.freeLockCount},
        { Statistics : "Number of occupied locks", "col2" :  station.ownedLockCount},
        { Statistics : "Percentage of locks occupied", "col2" :  `${((station.ownedLockCount / station.lockCount) * 100).toFixed(2)}%`}
    ];

    return rows;
} else {
    return [];
}
