* @ValidationCode : MjoyMTExOTI5OTE3OkNwMTI1MjoxNjgyNTg5NTEzMTQwOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Apr 2023 15:28:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.RAD.MON.ENQCUST

*-----------------------------------------------------------------------------
* Primary Purpose: Get the client number associated to a consultant done
*      Used in RAD.CONDUIT.LINEAR as API routine.
* Input Parameters: ENQUIRY.NAME | SEL.CRITERIA
* Output Parameters:CLIENT.NUMBER
*-----------------------------------------------------------------------------
* Modification History:
*
* 12/09/10 - Cesar Yepez
*            New Development
*
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             = TO EQ
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION          CALL Rtn format modified
*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_TSS.COMMON
    $INSERT I_F.REDO.MONITOR.PARAMETER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    
    $USING APAP.REDOCHNLS

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

    CALL CACHE.READ(FN.MONITOR.PARAMETER,Y.APPLICATION,R.RECORD.PARAM,Y.ERR.PARAM)

    IF Y.ERR.PARAM THEN
        ERR.MSG = 'ENQUIRY APP NO DEFINED IN REDO.MONITOR.PARAMETER'
        ERR.TYPE = 'WARNING'
        GOSUB LOG.ERROR
        RETURN
    END

    LOCATE Y.PARAM.ENQ IN R.RECORD.PARAM<REDO.MON.PARAM.ENQUIRY.NAME,1> SETTING Y.POS.MV THEN
        Y.CUSTOMER.FIELD = R.RECORD.PARAM<REDO.MON.PARAM.ENQ.CUSTOMER,Y.POS.MV>
        Y.ACCOUNT.FIELD =  R.RECORD.PARAM<REDO.MON.PARAM.ENQ.ACCOUNT,Y.POS.MV>
    END ELSE
        ERR.MSG = 'INVALID ENQUIRY: ' : Y.PARAM.ENQ
        ERR.TYPE = 'WARNING'
        GOSUB LOG.ERROR
        RETURN
    END

    IF Y.CUSTOMER.FIELD NE '' THEN
        GOSUB ANALYZE.CUSTOMER
    END

    IF Y.ACCOUNT.FIELD NE '' AND Y.CUST.ID EQ '' THEN
        GOSUB ANALYZE.ACCOUNT
    END

*DEBUG

    IF Y.CUST.ID NE '' THEN
        Y.RETURN = Y.CUST.ID
    END


    COMI = Y.RETURN

RETURN
*-----------------------------------------------------------------------------------

ANALYZE.CUSTOMER:

*DEBUG

    Y.COUNT.CRIT = DCOUNT(Y.PARAM.CRIT,'<@FM>')

    FOR Y.COUNT = 1 TO Y.COUNT.CRIT
        Y.TMP.RECORD = FIELD(Y.PARAM.CRIT,'<@FM>',Y.COUNT)
        Y.TMP.CUST.FIELD = FIELD(Y.TMP.RECORD,'<@VM>',1)
        Y.TMP.CUST.OPER  = FIELD(Y.TMP.RECORD,'<@VM>',2)
        Y.TMP.CUST.VAL   = FIELD(Y.TMP.RECORD,'<@VM>',3)

        IF (Y.CUSTOMER.FIELD EQ Y.TMP.CUST.FIELD) AND (Y.TMP.CUST.OPER EQ 'EQ') THEN
            Y.CUST.ID = Y.TMP.CUST.VAL
            Y.COUNT = Y.COUNT.CRIT + 1
        END

    NEXT Y.COUNT


RETURN
*-----------------------------------------------------------------------------------

ANALYZE.ACCOUNT:


*DEBUG
    Y.COUNT.CRIT = DCOUNT(Y.PARAM.CRIT,'<@FM>')

    FOR Y.COUNT = 1 TO Y.COUNT.CRIT
        Y.TMP.RECORD = FIELD(Y.PARAM.CRIT,'<@FM>',Y.COUNT)
        Y.TMP.FIELD = FIELD(Y.TMP.RECORD,'<@VM>',1)
        Y.TMP.OPER  = FIELD(Y.TMP.RECORD,'<@VM>',2)
        Y.TMP.VAL   = FIELD(Y.TMP.RECORD,'<@VM>',3)

        IF (Y.ACCOUNT.FIELD EQ Y.TMP.FIELD) AND (Y.TMP.OPER EQ 'EQ') THEN
            Y.ACCOUNT.ID = Y.TMP.VAL
            GOSUB GET.CUST.ID
            Y.COUNT = Y.COUNT.CRIT + 1
        END

    NEXT Y.COUNT


RETURN
*-----------------------------------------------------------------------------------

GET.CUST.ID:

* Account
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,YERR.ACCOUNT)

    IF NOT(YERR.ACCOUNT) THEN
        Y.CUST.ID = R.ACCOUNT<AC.CUSTOMER>
        RETURN
    END

* AA Arrangement
    CALL F.READ(FN.AA.ARRANGEMENT,Y.ACCOUNT.ID,R.AA,F.AA.ARRANGEMENT,YERR.AA)

    IF NOT(YERR.AA) THEN
        Y.CUST.ID = R.AA<AA.ARR.CUSTOMER>
        RETURN
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
    ID.PROC = 'REDO.RAD.MON.ENQCUST'
    MON.TP = ''
    DESC = ERR.MSG
    REC.CON = Y.PARAM
    EX.USER = OPERATOR
    EX.PC = IP.ADDRESS

    BEGIN CASE
        CASE ERR.TYPE EQ 'WARNING'
            MON.TP = 05
        CASE ERR.TYPE EQ 'ERROR' ;*AUTO R22 CODE CONVERSION
            MON.TP = 08
    END CASE


    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE, INT.TYPE, BAT.NO, BAT.TOT, INFO.OR, INFO.DE, ID.PROC, MON.TP, DESC, REC.CON, EX.USER, EX.PC) ;*MANUAL R22 CODE CONVERSION

RETURN

*-----------------------------------------------------------------------------------

*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:
    PROCESS.GOAHEAD = 1
    IP.ADDRESS = TSS$CLIENTIP
    Y.INTERF.ID = 'MON001'
    Y.PARAM = COMI
    Y.RETURN = 'NULO'
    Y.DELIMITER = '|'
    Y.CUST.ID = ''
    Y.CUSTOMER.FIELD = ''
    Y.ACCOUNT.FIELD = ''
    ERR.MSG = ''
    ERR.TYPE = ''
    Y.APPLICATION = 'ENQUIRY'
*Y.FM = 'FM'

*DEBUG

    Y.PARAM.ENQ  = FIELD(Y.PARAM,Y.DELIMITER,1)
    Y.PARAM.CRIT = FIELD(Y.PARAM,Y.DELIMITER,2)

RETURN
*-----------------------------------------------------------------------------------

OPEN.FILES:


    FN.MONITOR.PARAMETER = 'F.REDO.MONITOR.PARAMETER'
    F.MONITOR.PARAMETER = ''
    CALL OPF(FN.MONITOR.PARAMETER,F.MONITOR.PARAMETER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

RETURN

*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:

    IF (Y.PARAM.ENQ EQ '') OR (Y.PARAM.CRIT EQ '') THEN
        PROCESS.GOAHEAD = 0
    END


RETURN
*-----------------------------------------------------------------------------------

END
