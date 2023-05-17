*-----------------------------------------------------------------------------
* <Rating>-6</Rating>
*-----------------------------------------------------------------------------
  FUNCTION redoOracleNull(valueToCheck)
*-----------------------------------------------------------------------------
*  REDO Oracle Date
*  Allows to check if the valueToCheckprocess is blank or null
*
*
*  Input/Output
*  ---------------
*           valueToCheck       (in)  string value to check
*
*   NULL is returned if valueToCheck is blank or null
*
*  Example
*           yValue = redoOracleNull("")
*           ;* NULL will be returned
*-----------------------------------------------------------------------------
  IF valueToCheck EQ '' OR NOT(valueToCheck) THEN
    RETURN 'NULL'
  END
  RETURN valueToCheck
END
