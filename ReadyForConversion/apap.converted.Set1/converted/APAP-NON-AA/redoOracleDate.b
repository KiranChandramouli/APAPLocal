FUNCTION redoOracleDate(yProcessValue,yDateFormat)
*-----------------------------------------------------------------------------
*  REDO Oracle Date
*  Allows to get the processValue as representation of to_date Oracle instruction
*  using the date format
*
*  Input/Output
*  ---------------
*           yProcessValue       (in)  String to process
*           yDateFormat         (in)  Oracle Date format, for example yyyyMMdd
*   NULL is returned if yProcessValue is blank or null
*
*  Example
*           yValue = redoOracleDate("20101121","yyyyMMdd")
*           ;* to_date('20101121','yyyyMMdd') will be returned
*-----------------------------------------------------------------------------
    DEFFUN redoOracleNull()
    IF yProcessValue EQ '' THEN
        RETURN redoOracleNull(yProcessValue)
    END
    Y.FORMAT = "to_date('" : yProcessValue : "','" : yDateFormat : "')"
RETURN Y.FORMAT
END
