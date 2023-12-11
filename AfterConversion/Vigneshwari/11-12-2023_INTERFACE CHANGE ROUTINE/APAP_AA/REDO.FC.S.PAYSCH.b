* @ValidationCode : MjotMTk4Nzk2ODU2NTpDcDEyNTI6MTcwMjIxNTg5MzcxMTp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Dec 2023 19:14:53
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
$PACKAGE APAP.AA          ;*MANUAL R22 CODE CONVERSTION
SUBROUTINE REDO.FC.S.PAYSCH
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE ACTIVITY API
* Attached as     : ROUTINE
* Primary Purpose : Amend the payment schedule
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : 21 Jul 2011
*DATE              WHO                REFERENCE                        DESCRIPTION
*29-03-2023      Conversion Tool      AUTO R22 CODE CONVERSION        FM TO @FM,VM TO @VM
*29-03-2023      MOHANRAJ R           MANUAL R22 CODE CONVERSION         Package name added APAP.AA
*08-12-2023	 VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES        SQA-11092-By Santiago-No Changes

**-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.APP.COMMON
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_System

    GOSUB INITIALISE


    IF PROCESS.GOAHEAD THEN
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END
    
RETURN          ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    CALL CACHE.READ(FN.REDO.FC.PAYSCH,YID.ARR,R.REDO.FC.PAYSCH,YERR)
    IF YERR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.REDO.FC.PAYSCH          ;*AUTO R22 CODE CONVERSION
        CALL STORE.END.ERROR
    END ELSE
        Y.PAYMENT.TYPE   = R.REDO.FC.PAYSCH<AA.PS.PAYMENT.TYPE>
        Y.PAYMENT.METHOD   = R.REDO.FC.PAYSCH<AA.PS.PAYMENT.METHOD>
        Y.PAYMENT.FREQ = R.REDO.FC.PAYSCH<AA.PS.PAYMENT.FREQ>
        Y.PROPERTY   = R.REDO.FC.PAYSCH<AA.PS.PROPERTY>
        Y.START.DATE   = R.REDO.FC.PAYSCH<AA.PS.START.DATE>
        Y.END.DATE = R.REDO.FC.PAYSCH<AA.PS.END.DATE>
        Y.ACTUAL.AMT   =  R.REDO.FC.PAYSCH<AA.PS.ACTUAL.AMT>
        Y.ACC.TO.DEBIT = R.REDO.FC.PAYSCH<AA.PS.LOCAL.REF,WPOSL1>
        Y.FORM = R.REDO.FC.PAYSCH<AA.PS.LOCAL.REF,WPOSL2>
        Y.PAYMT.MHD = R.REDO.FC.PAYSCH<AA.PS.LOCAL.REF,WPOSL3>
    END
*TEST-START	;*Fix SQA-11092- By Santiago-new lines added- start
    IF Y.PAYMENT.TYPE THEN
        Y.PAY.CNT = DCOUNT(Y.PAYMENT.TYPE,@VM)
        I=1
        LOOP
        WHILE I LE Y.PAY.CNT

*TEST-END	;*Fix SQA-11092- By Santiago-end
;*Fix SQA-11092- By Santiago- "<1,I>" is added-start
            R.NEW(AA.PS.PAYMENT.TYPE)<1,I> =    Y.PAYMENT.TYPE<1,I>
            R.NEW(AA.PS.PAYMENT.METHOD)<1,I> = Y.PAYMENT.METHOD<1,I>
            R.NEW(AA.PS.PAYMENT.FREQ)<1,I> = '"':Y.PAYMENT.FREQ<1,I>:'"'	;*Fix SQA-11092- By Santiago-new lines added
            R.NEW(AA.PS.PAYMENT.FREQ)<1,I> = Y.PAYMENT.FREQ<1,I>
            R.NEW(AA.PS.PROPERTY)<1,I> = Y.PROPERTY<1,I>
            R.NEW(AA.PS.PERCENTAGE)<1,I> = ""
            R.NEW(AA.PS.DUE.FREQ) = Y.PAYMENT.FREQ<1,I>
            R.NEW(AA.PS.START.DATE)<1,I> = Y.START.DATE<1,I>
            R.NEW(AA.PS.END.DATE)<1,I> = Y.END.DATE<1,I>
            R.NEW(AA.PS.ACTUAL.AMT)<1,I> = Y.ACTUAL.AMT<1,I>
            I=I+1
        REPEAT
;*Fix SQA-11092- By Santiago-end
        R.NEW(AA.PS.LOCAL.REF)<1,WPOSL1> = Y.ACC.TO.DEBIT
        R.NEW(AA.PS.LOCAL.REF)<1,WPOSL2> = Y.FORM
        R.NEW(AA.PS.LOCAL.REF)<1,WPOSL3> = Y.PAYMT.MHD

    END

RETURN



*------------------------
INITIALISE:
*======


    IF (V$FUNCTION NE "I") THEN
        PROCESS.GOAHEAD = 0
        RETURN
    END

* Getting flag in order to know if transaction is coming through FC
    E = ""
    Y.ARR.ID = System.getVariable("CURRENT.RCA")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*AUTO R22 CODE CONVERSION
        Y.ARR.ID = ""
    END

    IF E THEN
        PROCESS.GOAHEAD = 0
        E = ""
        RETURN
    END

    FN.REDO.FC.PAYSCH = 'F.REDO.FC.PAYSCH'
    F.REDO.FC.PAYSCH = ''
    R.REDO.FC.PAYSCH = ''
    YID.ARR = AA$ARR.ID
    Y.PAYMENT.TYPE = ""

    PROCESS.GOAHEAD = 1
    WAPP.LST = "AA.PRD.DES.PAYMENT.SCHEDULE"
    WCAMPO    = "L.AA.DEBT.AC"
    WCAMPO<2> = "L.AA.FORM"
    WCAMPO<3> = "L.AA.PAY.METHD"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)  ;*;*AUTO R22 CODE CONVERSION
    CALL MULTI.GET.LOC.REF(WAPP.LST,WCAMPO,YPOS)
    WPOSL1    = YPOS<1,1>
    WPOSL2    = YPOS<1,2>
    WPOSL3    = YPOS<1,3>
RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.REDO.FC.PAYSCH, F.REDO.FC.PAYSCH)
RETURN
*------------
END
