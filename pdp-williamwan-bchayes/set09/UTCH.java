// UTC Helper Class

public class UTCH {
	
	// number of minutes in an hour
	private static final int MINUTESINHOUR = 60;
	private static final int HOURSINDAY = 24;
	
	// duration : UTC UTC -> NonNegInt
	// GIVEN: start UTC and end UTC
	// RETURNS: the duration of time between start and end in minutes
	public static int duration(UTC start, UTC end) {
		
		int startMinutes = UTCtoMinutes(start);
		int endMinutes = UTCtoMinutes(end);
		
		if (startMinutes == endMinutes) {
			return 0;
		} else if (startMinutes < endMinutes) {
			return durationEndGreater(startMinutes, endMinutes);
		} else {
			return durationStartGreater(startMinutes,endMinutes);
		}
	}
	
	// PRIVATE METHODS - HELPERS
	// -------------------------------------------------------------------------
	
	// UTCtoMinutes : UTC -> NonNegInt
	// GIVEN: a UTC
	// RETURNS: number of mintues from 0h 0m for the given UTC
	private static int UTCtoMinutes(UTC u) {
		return u.hour() * MINUTESINHOUR + u.minute();
	}

	// durationCalculator : NonNegInt NonNegInt NonNegInt -> NonNegInt
	// GIVEN: start time in minutes, end time in minutes, hour factor
	// WHERE: hourFactor is 0 when start is less than end, and 24 if greater
	// RETURNS: number of minutes from start to end taking into account
	//          if it goes from one day into another
	private static int durationCalculator(int start, int end, int hourFactor) {
		int duration;
		duration = start / MINUTESINHOUR;
		duration = hourFactor - duration;
		duration = duration + (end / MINUTESINHOUR);
		duration = duration * MINUTESINHOUR;
		duration = duration - (start % MINUTESINHOUR);
		duration = duration + (end % MINUTESINHOUR);
		return duration;
	}
	
	// durationStartGreater : NonNegInt NonNegInt -> NonNegInt
	// GIVEN: start time in minutes and end time in minutes
	// WHERE: start time is greater than end time
	// RETURNS: duration between times in minutes
	private static int durationStartGreater(int start, int end) {
		return durationCalculator(start,end,HOURSINDAY);
	}
	
	// durationStartGreater : NonNegInt NonNegInt -> NonNegInt
	// GIVEN: start time in minutes and end time in minutes
	// WHERE: start time is less than end time
	// RETURNS: duration between times in minutes
	private static int durationEndGreater(int start, int end) {
		return durationCalculator(start,end,0);
	}	
}