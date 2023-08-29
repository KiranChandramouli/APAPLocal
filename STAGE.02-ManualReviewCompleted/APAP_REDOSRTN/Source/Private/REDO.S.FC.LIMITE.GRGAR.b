* @ValidationCode : MjotNTA5NTE2MjQzOkNwMTI1MjoxNjkzMjI0NzAyOTQyOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Aug 2023 17:41:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.FC.LIMITE.GRGAR(CUST.ID, CUST.OUT)


*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return evaluation of customer.
*
* Incoming:
* ---------
* CUST.ID - ID FROM CUSTOMER
*
* Outgoing:
* ---------
* CUST.OUT - data returned to the routine
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : mgudino - TAM Latin America
* Date            :
*DATE           AUTHOR             Modification                 DESCRIPTION
*28/08/2023  CONVERSION TOOL  AUTO R22 CODE CONVERSION           RAD.BP is removed in insertfile , FM TO @FM
*28/08/2023  VIGNESHWARI      MANUAL R22 CODE CONVERSION         DYN.TO.OFS Change to OFS.BUILD.RECORD,CALL RTN MODIFIED
*
*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.CUSTOMER
    $INSERT I_RAPID.APP.DEV.COMMON     ;*AUTO R22 CODE CONVERSION
    $INSERT I_F.REDO.CCRG.CUSTOMER
    $INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM
    $USING APAP.REDOFCFI


    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN          ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    Y.ERROR = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,Y.ERROR)
    IF R.CUSTOMER THEN
        IF R.CUSTOMER<EB.CUS.CUSTOMER.TYPE> EQ 'PROSPECT' THEN
            VI.ARR = ''
            RETURN
        END
    END

    ID.CUST = System.getVariable("ID.CUST")

    ID.CUST.LIM = System.getVariable("ID.CUST.LIM")

    IF ID.CUST EQ CUST.ID THEN
        Y.ID.CUST.LIM = ID.CUST.LIM
        Y.ID.CUST = ID.CUST
    END ELSE
        Y.APPLICATION = 'REDO.CCRG.CUSTOMER'
        R.REDO.CCRG.CUSTOMER<REDO.CCRG.CUS.CUSTOMER.ID> = CUST.ID
        E = ''
        OFS.INFO.INPUT = ''
        OFS.INFO.INPUT<1,1> = Y.VER.INSURANCE
        OFS.INFO.INPUT<1,2> = 'I'
        OFS.INFO.INPUT<2,1> = 'PROCESS'
        OFS.INFO.INPUT<2,6> = '0'
        OFS.INFO.INPUT<2,4> = Y.INS.ID

* Get Y.ID.CUST.LI from OFS result.
*        Y.OFS.MSG.REQ = DYN.TO.OFS(R.REDO.CCRG.CUSTOMER, Y.APPLICATION, OFS.INFO.INPUT)

     APP.NAME     = Y.APPLICATION     ;*MANUAL R22 CODE CONVERSION-START-DYN.TO.OFS Change to OFS.BUILD.RECORD
    OFS.FUNCTION = 'I'
    OFS.PROCESS  = 'PROCESS'
    OFS.VERSION  = Y.VER.INSURANCE
    Y.GTSMODE    = ''
    NO.OF.AUTH   = ''
    TRANSACTION.ID = Y.INS.ID
    R.RECORD     = R.REDO.CCRG.CUSTOMER
    Y.OFS.STR   = ''
    CALL OFS.BUILD.RECORD(APP.NAME, OFS.FUNCTION, OFS.PROCESS, OFS.VERSION, Y.GTSMODE, NO.OF.AUTH, TRANSACTION.ID, R.RECORD, Y.OFS.MSG.REQ)   ;*MANUAL R22 CODE CONVERSION-END

        CALL OFS.GLOBUS.MANAGER(Y.OFS.SOURCE.ID, Y.OFS.MSG.REQ)
        Y.ID.CUST.LIM = Y.OFS.MSG.REQ
        IF NOT(E) THEN
            Y.ID.CUST.LIM = FIELD(Y.ID.CUST.LIM,'/',1)
            Y.ID.CUST = CUST.ID
            CALL System.setVariable(Y.ID.CUST, "ID.CUST")
            CALL System.setVariable(Y.ID.CUST.LIM, "ID.CUST.LIM")
        END
    END

* Evaluate Customer
   * CALL REDO.FC.EVAL(Y.ID.CUST.LIM, Y.ID.NAME.LIM, OUT.RESULT)
   APAP.REDOFCFI.redoFcEval(Y.ID.CUST.LIM, Y.ID.NAME.LIM, OUT.RESULT) ;*MANUAL R22 CODE CONVERSION-CALL RTN MODIFIED
    IF OUT.RESULT EQ 1 THEN
        GOSUB PROCESS.RESULT
    END

RETURN

*------------------------
PROCESS.RESULT:
*=============
    R.REDO.CCRG.RISK.LIMIT.PARAM = ''
    YERR = ''
    CALL F.READ(FN.REDO.CCRG.RISK.LIMIT.PARAM,Y.ID.NAME.LIM,R.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARAM,YERR)
    IF YERR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : Y.ID.NAME.LIM
        CUST.OUT = ETEXT
    END ELSE
        CUST.OUT = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.MAX.AMOUNT>
    END

RETURN

*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    FN.REDO.CCRG.RISK.LIMIT.PARAM = 'F.REDO.CCRG.RISK.LIMIT.PARAM'
    F.REDO.CCRG.RISK.LIMIT.PARAM = ''
    ID.CUST = ''
    ID.CUST.LIM = ''
    CUST.OUT = ''
    Y.VER.INSURANCE = 'MAN'
    Y.INS.ID = ''
    R.REDO.CCRG.CUSTOMER = ''
    Y.OFS.MSG.RES = ''
    Y.OFS.MSG.REQ = ''
    Y.OFS.SOURCE.ID = 'FC.OFS'

    Y.ID.NAME.LIM = 'RISK.GROUP.SECURED'
RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARAM)
RETURN
*------------
END
