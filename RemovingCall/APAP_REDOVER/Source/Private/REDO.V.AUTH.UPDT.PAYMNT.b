* @ValidationCode : MjoyMzc1ODc2MTE6Q3AxMjUyOjE2ODMwMTA3NTcxMzI6SVRTUzotMTotMToxMTExOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 May 2023 12:29:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1111
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUTH.UPDT.PAYMNT
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine will update the local field depending upon the value of TRANSACTION.CODE. This routine
* TELLER,REDO.THIRDPRTY.PAYMENT

* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date         who                  Reference           Description
* 11-Jan-2010    Ganesh R             ODR2009100480       Initial Creation
* 26-oct-2010    Prabhu N             ODR-2009-09-0080    Modification done-INTERFACE.UPD added
* 12 JUL 2013    Vignesh Kumaar M R   PACS00307024        SELECTION TO BE BASED ON THE COMPANY
* 02 JAN 2014    Vignesh Kumaar M R   PACS00338051        THIRDPARTY BILL PAYMENT NOT UPDATING DURING RTE APPROVAL
*------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,F.READ TO CACHE.READ,IF CONDITION ADDED
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-------------------------------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.LOCKING
    $INSERT I_F.EB.ERROR
    $INSERT I_F.REDO.THIRDPRTY.PAYMENT
    $INSERT I_F.TELLER.ID
    $INSERT I_F.REDO.THIRDPRTY.PARAMETER
    $INSERT I_F.REDO.TRANS.CODE.PARAM
    $INSERT JBC.h
    $INSERT I_GTS.COMMON
    $INSERT I_System ;*
    $USING APAP.REDOCHNLS

* Fix for PACS00338051 [THIRDPARTY BILL PAYMENT NOT UPDATING DURING RTE APPROVAL]

    Y.TT.STATUS=R.NEW(TT.TE.RECORD.STATUS)
    Y.TT.STATUS=Y.TT.STATUS[1,2]

    IF (V$FUNCTION EQ 'I' OR (V$FUNCTION EQ 'A' AND Y.TT.STATUS EQ 'IN' )) AND OFS$OPERATION EQ 'PROCESS' THEN

* End of Fix

        GOSUB INIT
        GOSUB OPEN.FILES
        GOSUB CREATING.ID
        GOSUB PROCESS
    END ELSE
        RETURN
    END


RETURN
*-------------
INTERFACE.UPD:
*-------------
    Y.ID                = R.NEW(TT.TE.LOCAL.REF)<1,VAR.L.TT.CMPNY.ID>
    Y.INTERFACE.REQ     = R.REDO.THIRD.PARAMETER<REDO.TP.INTERFACE.REQ>
    Y.METHOD.LIST       = R.REDO.THIRD.PARAMETER<REDO.TP.METHOD.DESC>
    Y.METHOD.NAMES      = R.REDO.THIRD.PARAMETER<REDO.TP.METHOD.NAME>
    CHANGE @VM TO @FM IN Y.METHOD.LIST
    CHANGE @VM TO @FM IN Y.METHOD.NAMES
    Y.TT.BILL.NUM.VALUE   = R.NEW(TT.TE.LOCAL.REF)<1,VAR.L.TT.BILL.NUM>
    Y.INTERFACE.USER.NAME = R.REDO.THIRD.PARAMETER<REDO.TP.INTERFACE.USER>
    Y.INTERFACE.PASS      = R.REDO.THIRD.PARAMETER<REDO.TP.INTERFACE.PASS>
    ACTIVATION.KEY = R.REDO.TRANS.CODE.PARAM<REDO.TS.ACTIVATION.KEY>
    Y.DELIMITER    = R.REDO.TRANS.CODE.PARAM<REDO.TS.DELIMITER>
    IF Y.INTERFACE.REQ EQ "Y" THEN
        LOCATE "ProcessPayment" IN Y.METHOD.LIST SETTING METHOD.POS THEN
            GOSUB EXEC.PROCESS
        END
    END
RETURN
*-------------
EXEC.PROCESS:
*-------------

    Y.METHOD           = Y.METHOD.NAMES<METHOD.POS>
    IF R.NEW(TT.TE.DR.CR.MARKER) EQ 'CREDIT' THEN
        Y.TT.PAY.AMOUNT=R.NEW(TT.TE.AMOUNT.LOCAL.1)
    END
    ELSE
        Y.TT.PAY.AMOUNT=R.NEW(TT.TE.AMOUNT.LOCAL.2)
    END

*------------------------------------------------------------------------------------------
*performing update to third party interfaces
*------------------------------------------------------------------------------------------
    Y.METHOD.PAY=R.NEW(TT.TE.LOCAL.REF)<1,VAR.L.TT.MET.OF.PAY>
    Y.MODE.LIST=R.REDO.THIRD.PARAMETER<REDO.TP.PAY.MODE>
    CHANGE @VM TO @FM IN Y.MODE.LIST
    LOCATE Y.METHOD.PAY IN Y.MODE.LIST SETTING MODE.POS THEN
        Y.METHOD.PAY=R.REDO.THIRD.PARAMETER<REDO.TP.PAY.CODE,MODE.POS>
    END
*--------------------------------------------------------------------------------------------------
*This case is to get the due from the orange company
*--------------------------------------------------------------------------------------------------
    BEGIN CASE
        CASE Y.METHOD EQ "ProcessPaymentOrange"
            EJB_ARGUMENT       = Y.METHOD:Y.DELIMITER:Y.TT.BILL.NUM.VALUE:Y.DELIMITER:Y.TT.PAY.AMOUNT
            Y.RESPONSE         = CALLJEE(ACTIVATION.KEY,EJB_ARGUMENT)
            CHANGE Y.DELIMITER TO @FM IN EJB_ARGUMENT
            IF EJB_ARGUMENT<1> NE 'SUCCESS' THEN
                GOSUB HANDLE.FAIL
            END
            ELSE
                R.NEW(TT.TE.LOCAL.REF)<1,Y.TP.AUTH.NO.POS>=EJB_ARGUMENT<5>
            END

*----------------------------------------------------------------------------------------------------
*This case is to get the due from CODETEL company
*----------------------------------------------------------------------------------------------------

        CASE Y.METHOD EQ "PROCESS_INVOICE_PAYMENT"
            Y.MSD                 = R.NEW(TT.TE.LOCAL.REF)<1,VAR.TT.MSD.POS>
            Y.MEANS.CODE          = R.REDO.THIRD.PARAMETER<REDO.TP.CHANNEL.CODE>
            Y.INTERFACE.USER.NAME = R.REDO.THIRD.PARAMETER<REDO.TP.INTERFACE.USER>
            Y.INTERFACE.PASS      = R.REDO.THIRD.PARAMETER<REDO.TP.INTERFACE.PASS>
            Y.ID.REF              ='1':ID.NEW[8,5]
            EJB_ARGUMENT          = Y.METHOD:Y.DELIMITER:Y.TT.BILL.NUM.VALUE:Y.DELIMITER:Y.MSD:Y.DELIMITER:Y.TT.PAY.AMOUNT:Y.DELIMITER:Y.ID.REF:Y.DELIMITER:Y.METHOD.PAY:Y.DELIMITER:Y.MEANS.CODE:Y.DELIMITER:Y.INTERFACE.USER.NAME:Y.DELIMITER:Y.INTERFACE.PASS
            Y.RESPONSE            = CALLJEE(ACTIVATION.KEY,EJB_ARGUMENT)
            CHANGE Y.DELIMITER TO @FM IN EJB_ARGUMENT
            IF EJB_ARGUMENT<1> NE 'SUCCESS' THEN
                GOSUB HANDLE.FAIL
            END
            ELSE
                R.NEW(TT.TE.LOCAL.REF)<1,Y.TP.AUTH.NO.POS>=EJB_ARGUMENT<4>
            END
*----------------------------------------------------------------------------------------------------
*            This is to update the payment using generic interface for future companies
*----------------------------------------------------------------------------------------------------
        CASE Y.METHOD EQ "ProcessPayment"
            Y.COMPANY.CODE     =R.REDO.THIRD.PARAMETER<REDO.TP.COMP.NAME>
            EJB_ARGUMENT       =Y.METHOD:Y.DELIMITER:Y.COMPANY.CODE:Y.DELIMITER:Y.TT.BILL.NUM.VALUE:Y.DELIMITER:Y.METHOD.PAY:Y.DELIMITER:Y.TT.PAY.AMOUNT:Y.DELIMITER:ID.NEW
            Y.RESPONSE         = CALLJEE(ACTIVATION.KEY,EJB_ARGUMENT)
            CHANGE Y.DELIMITER TO @FM IN EJB_ARGUMENT
            IF EJB_ARGUMENT<1> NE 'SUCCESS' THEN
                GOSUB HANDLE.FAIL
            END
    END CASE
RETURN
*-----------
HANDLE.FAIL:
*-----------
    IF EJB_ARGUMENT<1> EQ 'FAIL' THEN
        ETEXT="EB-INVALID.DATA"
        CALL STORE.END.ERROR
    END
    ELSE
        GOSUB CONNECTION.FAIL
    END
RETURN
*---------------
CONNECTION.FAIL:
*---------------
    Y.RESPONSE.MSG =EJB_ARGUMENT[1,4]
    IF Y.RESPONSE.MSG EQ 'FAIL' OR Y.RESPONSE THEN
        Y.MESSAGE  =EJB_ARGUMENT<1>
        IF Y.RESPONSE THEN
            CALL CACHE.READ(FN.EB.ERROR, "EB-TP.CON.FAIL.CODE", R.EB.ERROR, ERR)  ;*R22 AUTO CODE CONVERSION
            Y.RESP.ERR=R.EB.ERROR<EB.ERR.ERROR.MSG>: ' ' : Y.RESPONSE
        END
        ELSE
            Y.RESP.ERR =FIELDS(Y.MESSAGE,':',2)
        END
        INT.CODE = 'TPI001'
        INT.TYPE = 'ONLINE'
        BAT.NO = ''
        BAT.TOT = ''
        INFO.OR = ''
        INFO.DE = ''
        ID.PROC = ID.NEW
        MON.TP = '03'
        DESC = Y.RESP.ERR
        REC.CON = ''
        EX.USER = ''
        EX.PC = ''
        CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);* R22 Manual conversion
        ETEXT = "EB-TP.CONNECT.FAIL"
        CALL STORE.END.ERROR
    END
RETURN
*---*
INIT:
*---*
*--------------------------*
*Initialising the Variables
*--------------------------*
    LOC.REF.APPLICATION='TELLER'
    LOC.REF.FIELDS='L.TT.CMPNY.ID':@VM:'L.TT.CMPNY.NAME':@VM:'L.TT.BILL.TYPE':@VM:'L.TT.BILL.COND':@VM:'L.TT.BILL.NUM':@VM:'L.TT.MET.OF.PAY':@VM:'L.TT.PARTY.NAME':@VM:'L.TT.MSD':@VM:'L.SUNL.SQ.NO'
    LOC.REF.POS=''
    R.RTP =''
    R.TELLER.ID=''
    Y.INTERFACE.REQ     = ""
RETURN

*---------*
OPEN.FILES:
*---------*
*Opening the Files

    FN.LOCKING='F.LOCKING'
    F.LOCK=''
    CALL OPF(FN.LOCKING,F.LOCK)

    FN.RTP='F.REDO.THIRDPRTY.PAYMENT'
    F.RTP=''
    CALL OPF(FN.RTP,F.RTP)

    FN.TELLER.ID='F.TELLER.ID'
    F.TELLER.ID=''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)

    FN.REDO.THIRD.PARAMETER='F.REDO.THIRDPRTY.PARAMETER'

    FN.REDO.TRANS.CODE.PARAM='F.REDO.TRANS.CODE.PARAM'

    FN.EB.ERROR='F.EB.ERROR'
    F.EB.ERROR =''
    CALL OPF(FN.EB.ERROR,F.EB.ERROR)
RETURN


CREATING.ID:
*--------------------------------*
*CREATING NEW ID FOR PAYMENT TABLE
*--------------------------------*
    LOCK.ID='F.REDO.THIRDPRTY.PAYMENT'
    R.LOCKING = ''
    CALL F.READU(FN.LOCKING,LOCK.ID,R.LOCKING,F.LOCK,LOCK.ERR,RETRY)
    CALL CACHE.READ(FN.REDO.TRANS.CODE.PARAM,"SYSTEM",R.REDO.TRANS.CODE.PARAM,REDO.TRANS.CODE.PARAM.ERR)
    ACTIVATION.KEY = R.REDO.TRANS.CODE.PARAM<REDO.TS.ACTIVATION.KEY>
    IF R.LOCKING THEN
        REMARK.VAL=R.LOCKING<EB.LOK.REMARK>

        IF REMARK.VAL EQ '' THEN
            R.LOCKING<EB.LOK.REMARK>= TODAY
            CALL F.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING)
        END
        ELSE
            IF TODAY GT REMARK.VAL THEN
                R.LOCKING<EB.LOK.REMARK> = TODAY
                R.LOCKING<EB.LOK.CONTENT> = '0000'
                VAR.ID = '0000'
                CALL F.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING)
            END
            IF TODAY EQ REMARK.VAL THEN
                R.LOCKING<EB.LOK.REMARK> = TODAY
                R.LOCKING<EB.LOK.CONTENT> =R.LOCKING<EB.LOK.CONTENT>+1
                VAR.CONT.ID=R.LOCKING<EB.LOK.CONTENT>
                VAR.ID=VAR.CONT.ID
                CALL F.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING)
            END

        END
    END ELSE
        R.LOCKING<EB.LOK.REMARK> = TODAY
        R.LOCKING<EB.LOK.CONTENT> = '0000'
        VAR.ID = '0000'
        CALL F.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING)
    END

    RTP.LIVE.ID = TODAY:FMT(VAR.ID,'R%4')

RETURN

*--------*
PROCESS:
*--------*
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    VAR.L.TT.CMPNY.ID=LOC.REF.POS<1,1>
    VAR.L.TT.CMPNY.NAME=LOC.REF.POS<1,2>
    VAR.L.TT.BILL.TYPE=LOC.REF.POS<1,3>
    VAR.L.TT.BILL.COND=LOC.REF.POS<1,4>
    VAR.L.TT.BILL.NUM=LOC.REF.POS<1,5>
    VAR.L.TT.MET.OF.PAY=LOC.REF.POS<1,6>
    VAR.L.TT.PARTY.NAME=LOC.REF.POS<1,7>
    VAR.TT.MSD.POS     =LOC.REF.POS<1,8>
    Y.TP.AUTH.NO.POS   =LOC.REF.POS<1,9>

    VAR.COMP.ID=R.NEW(TT.TE.LOCAL.REF)<1,VAR.L.TT.CMPNY.ID>
    CALL CACHE.READ(FN.REDO.THIRD.PARAMETER,VAR.COMP.ID,R.REDO.THIRD.PARAMETER,REC.ERR)
    VAR.RTP.STATUS = R.REDO.THIRD.PARAMETER<REDO.TP.STATUS>
    VAR.RTP.INTERFACE = R.REDO.THIRD.PARAMETER<REDO.TP.INTERFACE.REQ>

    IF VAR.RTP.STATUS EQ 'D' THEN
        ETEXT = "EB-STATUS.DISABLED"
        CALL STORE.END.ERROR
    END
    IF VAR.RTP.INTERFACE EQ 'Y' THEN
        GOSUB INTERFACE.UPD
    END
    GOSUB UPDATE.FIELDS
RETURN


UPDATE.FIELDS:
    RTP.ID=ID.NEW
    CALL F.READ(FN.RTP,RTP.LIVE.ID,R.RTP,F.RTP,R.ERR)
    IF R.RTP EQ '' THEN

*------------------------------------------*
*Updating the Fields into Live template
*-------------------------------------------*

        VAL1=R.NEW(TT.TE.LOCAL.REF)<1,VAR.L.TT.CMPNY.ID>
        R.RTP<TPT.BRANCH> = VAL1
        VAR.TELL.ID = R.NEW(TT.TE.TELLER.ID.1)
        R.RTP<TPT.TELLER.ID> = VAR.TELL.ID

        CALL F.READ(FN.TELLER.ID,VAR.TELL.ID,R.TELLER.ID,F.TELLER.ID,TELL.ERR)
        VAR.TELL.NAME=R.TELLER.ID<TT.TID.USER>
        TELLER.NAME = VAR.TELL.NAME
        R.RTP<TPT.TELLER.NAME>=TELLER.NAME

        VAL3 = R.NEW(TT.TE.LOCAL.REF)<1,VAR.L.TT.CMPNY.NAME>
        R.RTP<TPT.COMP.NAME> = VAL3
        VAL4 = R.NEW(TT.TE.LOCAL.REF)<1,VAR.L.TT.BILL.COND>
        R.RTP<TPT.BILL.COND> = VAL4
        VAL5 = R.NEW(TT.TE.LOCAL.REF)<1,VAR.L.TT.BILL.TYPE>
        R.RTP<TPT.BILL.TYPE>= VAL5
        VAL6 = R.NEW(TT.TE.LOCAL.REF)<1,VAR.L.TT.BILL.NUM>
        R.RTP<TPT.BILL.NUMBER> = VAL6
        VAL7 = R.NEW(TT.TE.LOCAL.REF)<1,VAR.L.TT.MET.OF.PAY>
        R.RTP<TPT.METHOD.OF.PAY> = VAL7
        VAL8 = R.NEW(TT.TE.AMOUNT.LOCAL.1)
        R.RTP<TPT.AMOUNT> = VAL8
        VAL9 = R.NEW(TT.TE.CHEQUE.NUMBER)
        R.RTP<TPT.CHEQUE.NUMBER> = VAL9

    END

* Fix for PACS00307024 [SELECTION TO BE BASED ON THE COMPANY]

    E.BACK = E
    GET.COMP.ID = System.getVariable("CURRENT.USER.BRANCH")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 AUTO CODE CONVERSION.START
        GET.COMP.ID = ""  ;*R22 AUTO CODE CONVERSION
    END   ;*R22 AUTO CODE CONVERSION.END


    IF GET.COMP.ID EQ "CURRENT.USER.BRANCH" THEN
        LOCATE 'EB-UNKNOWN.VARIABLE' IN E<1,1> SETTING POS THEN
            E = E.BACK
        END
        GET.COMP.ID = ID.COMPANY
    END

    R.RTP<TPT.PAY.COMPANY> = GET.COMP.ID

* End of Fix

    CALL F.WRITE(FN.RTP,RTP.LIVE.ID,R.RTP)

RETURN
END
