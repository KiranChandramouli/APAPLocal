SUBROUTINE REDO.E.CONV.UPLOAD.ID
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This is used as Convertion  routine in EB.FILE.UPLOAD enuriy  to form the ID
*-----------------------------------------------------------------------------------------------------
* * Input / Output
*--------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Sakthi Sellappillai
* PROGRAM NAME : REDO.E.CONV.UPLOAD.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE            WHO                     REFERENCE             DESCRIPTION
*=======          ==============          ==================    ===============
* 07-10-2010      Sakthi Sellappillai     ODR-2010-08-0031      INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------------------------------
    Y.CUSTOMER.VAL = ''
    Y.DATE.TIME.VAL = ''
    Y.TEMP.VAL  = O.DATA
RETURN
*-----------------------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------------------
    Y.CUSTOMER.VAL = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CUSTOMER.VAL = ""
    END
    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    Y.TIME.VALUE = UNIQUE.TIME
    Y.DATE.VALUE = TODAY
    Y.UPLOAD.ID = Y.CUSTOMER.VAL:".":Y.DATE.VALUE:".":Y.TIME.VALUE
    O.DATA = Y.UPLOAD.ID
RETURN
*----------------------------------------------------------------------------------------------
END
