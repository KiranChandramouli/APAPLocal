$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.JSON.RTN.RUNNER(Y.OBJECT.NAME, JSON.REQUEST, Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.DYN.RESPONSE.TYPE, Y.ERROR)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - Include to Insert and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

*Subroutine RUNNER
*----------------------------------------------------------------------------------------------------------------------------------------------------
*CLEAR OUTPUT VARIABLES
    Y.DYN.RESPONSE.KEY = ''
    Y.DYN.RESPONSE.VALUE = ''
    Y.DYN.RESPONSE.TYPE = ''
    Y.ERROR = ''
    Y.ERROR<3> = 'L.APAP.JSON.RTN.RUNNER'

    BEGIN CASE
        CASE Y.OBJECT.NAME EQ 'ANY.ROUTINE'
**CALL ANY.ROUTINE(JSON.REQUEST, Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.DYN.RESPONSE.TYPE, Y.ERROR)
        CASE 1
            Y.ERROR<1> = '1'
            Y.ERROR<2> = 'INVALID ROUTINTE'
    END CASE
RETURN
END
