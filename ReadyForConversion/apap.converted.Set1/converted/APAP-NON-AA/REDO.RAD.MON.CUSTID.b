SUBROUTINE REDO.RAD.MON.CUSTID

*-----------------------------------------------------------------------------
* Primary Purpose: Return de identification and type of identification separated by delimiter @
*                  It receives as parameters: Identification1 and Identification2 separated by delimiter @
*                  Used in RAD.CONDUIT.LINEAR as API routine.
* Input Parameters: L.CU.CIDENT @ LEGAL.ID
* Output Parameters:IDENTIFICACION_NUMBER @ IDENTIFICATION_TYPE
*-----------------------------------------------------------------------------
* Modification History:
*
* 12/09/10 - Cesar Yepez
*            New Development
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_TSS.COMMON

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*DEBUG
    BEGIN CASE
        CASE Y.PARAM.ID1 NE ''
            Y.RETURN = Y.PARAM.ID1 : Y.DELIMITER : Y.CEDULA.IDENTIF
        CASE Y.PARAM.ID2 NE ''
            Y.RETURN = Y.PARAM.ID2 : Y.DELIMITER : Y.PASSPORT.IDENTIF
    END CASE

    COMI = Y.RETURN

RETURN
*-----------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------

*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:
    PROCESS.GOAHEAD = 1
    IP.ADDRESS = TSS$CLIENTIP
    Y.INTERF.ID = 'MON001'
    Y.PARAM = COMI
    Y.RETURN = ''
    Y.DELIMITER = '@'
    Y.CEDULA.IDENTIF   = 'CE'
    Y.PASSPORT.IDENTIF = 'PA'
    ERR.MSG = ''
    ERR.TYPE = ''

    Y.PARAM.ID1 = FIELD(Y.PARAM,Y.DELIMITER,1)
    Y.PARAM.ID2 = FIELD(Y.PARAM,Y.DELIMITER,2)


RETURN
*-----------------------------------------------------------------------------------

OPEN.FILES:


RETURN

*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:

    IF (Y.PARAM.ID1 EQ '') AND (Y.PARAM.ID2 EQ '') THEN
        PROCESS.GOAHEAD = 0
*Commented. This validarion does not apply for new customers
*ERR.MSG = 'INVALID PARAMETERS IN ROUTINE REDO.RAD.MON.CUSTID'
*ERR.TYPE = 'WARNING'
*GOSUB LOG.ERROR
    END

RETURN

*-----------------------------------------------------------------------------------
LOG.ERROR:

* Register error in the fault log

    INT.CODE = Y.INTERF.ID
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = 'T24'
    INFO.DE = 'T24'
    ID.PROC = 'REDO.RAD.MON.CUSTID'
    MON.TP = ''
    DESC = ERR.MSG
    REC.CON = Y.PARAM
    EX.USER = OPERATOR
    EX.PC = IP.ADDRESS

    BEGIN CASE
        CASE ERR.TYPE EQ 'WARNING'
            MON.TP = 05
        CASE ERR.TYPE EQ 'ERROR'
            MON.TP = 08
    END CASE


    CALL REDO.INTERFACE.REC.ACT(INT.CODE, INT.TYPE, BAT.NO, BAT.TOT, INFO.OR, INFO.DE, ID.PROC, MON.TP, DESC, REC.CON, EX.USER, EX.PC)

RETURN

*-----------------------------------------------------------------------------------

END
