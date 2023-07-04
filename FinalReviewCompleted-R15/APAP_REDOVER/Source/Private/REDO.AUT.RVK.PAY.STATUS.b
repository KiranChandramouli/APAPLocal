* @ValidationCode : MjoxODkyNTcwNjEzOkNwMTI1MjoxNjgyNDEyMzI2OTMzOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUT.RVK.PAY.STATUS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This subroutine would serve as a cross validation level validation routine
* The purpose of this routine is to check the field STOPPAYMENT.STATUS,
* depending upon the value of STOP.PAYMENT.STATUS system should populate
* the EXPIRY.DATE and  STOP.CHEQ.VALIDITY
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who                        Reference                      Description
* 25-Nov-2009       SHANKAR RAJU           ODR-2009-10-0426(HD1053407)         Initial Creation
*04-04-2023         Conversion Tool          R22 Auto Code conversion            VM TO @VM
*04-04-2023            Samaran T                Manual R22 Code Conversion       No Changes
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PAYMENT.STOP
    $INSERT I_F.USER
    $INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT
    $INSERT I_F.REDO.CHEQUE.STOP.PARA

*------------------------------MAIN-------------------------------------
    GOSUB INIT
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------


    FN.REDO.PAYMENT.STOP.ACCOUNT = 'F.REDO.PAYMENT.STOP.ACCOUNT'
    FN.REDO.CHEQUE.STOP.PARA = 'F.REDO.CHEQUE.STOP.PARA'
    F.REDO.CHEQUE.STOP.PARA =''
    F.REDO.PAYMENT.STOP.ACCOUNT = ''
    Y.VALUE.NEW = ''
    R.PAYSTOP = ''

    CALL OPF(FN.REDO.PAYMENT.STOP.ACCOUNT,F.REDO.PAYMENT.STOP.ACCOUNT)
    CALL OPF(FN.REDO.CHEQUE.STOP.PARA,F.REDO.CHEQUE.STOP.PARA)

    LREF.APPLN="PAYMENT.STOP"
    LREF.FLDS="L.PS.STP.PMT.ST":@VM:"L.PS.EXP.DATE":@VM:"L.PS.STOP.TIME" ;*R22 AUTO CODE CONVERSION

    CALL MULTI.GET.LOC.REF(LREF.APPLN,LREF.FLDS,LREF.POS)
    POS.STOPPAYMENT.STATUS=LREF.POS<1,1>
    POS.EXPIRY.DATE=LREF.POS<1,2>
    POS.STOP.TIME =LREF.POS<1,3>

RETURN
*-----------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------

    Y.AC.OGM.ID = R.NEW(REDO.PS.ACCT.ACCOUNT.NUMBER)
    STATUS.NOS = DCOUNT(R.NEW(REDO.PS.ACCT.PAY.STOP.STATUS),@VM) ;*R22 AUTO CODE CONVERSION
    Y.ACCT.ID = R.NEW(REDO.PS.ACCT.ACCOUNT.NUMBER)
    Y.FLAG = ''
    Y.CONFIRM  = R.NEW(REDO.PS.ACCT.USER)
    START.COUNT = 1

    LOOP
    WHILE START.COUNT LE STATUS.NOS

        Y.VALUE.NEW = R.NEW(REDO.PS.ACCT.PAY.STOP.STATUS)<1,START.COUNT>
        Y.VALUE.OLD = R.OLD(REDO.PS.ACCT.PAY.STOP.STATUS)<1,START.COUNT>
        IF Y.VALUE.NEW EQ 'NONE' AND Y.VALUE.OLD NE 'NONE' THEN

            R.PAYSTOP<AC.PAY.CUSTOMER.NO>                   =  R.NEW(REDO.PS.ACCT.CUSTOMER)
            R.PAYSTOP<AC.PAY.CURRENCY>                      =  R.NEW(REDO.PS.ACCT.CURRENCY)
            FIRST.CHEQUE                                    =  R.NEW(REDO.PS.ACCT.CHEQUE.FIRST)<1,START.COUNT>
            Y.NO.OF.LEAVES                                  =  R.NEW(REDO.PS.ACCT.NO.OF.LEAVES)<1,START.COUNT>
            COUNT.MOD.CHQ = 1
            LOOP
            WHILE COUNT.MOD.CHQ LE Y.NO.OF.LEAVES
                R.PAYSTOP<AC.PAY.MOD.PS.CHQ.NO,COUNT.MOD.CHQ> = FIRST.CHEQUE
                R.PAYSTOP<AC.PAY.MOD.CHQ.TYPE,COUNT.MOD.CHQ> = R.NEW(REDO.PS.ACCT.CHEQUE.TYPE)<1,START.COUNT>
                R.PAYSTOP<AC.PAY.MOD.PS.DATE,COUNT.MOD.CHQ> = TODAY
                COUNT.MOD.CHQ += 1  ;*R22 AUTO CODE CONVERSION
                FIRST.CHEQUE += 1   ;*R22 AUTO CODE CONVERSION
            REPEAT

            R.PAYSTOP<AC.PAY.LOCAL.REF,POS.STOPPAYMENT.STATUS,START.COUNT> = 'NONE'

            R.PAYSTOP<AC.PAY.LOCAL.REF,POS.EXPIRY.DATE,START.COUNT> = TODAY
            R.PAYSTOP<AC.PAY.LOCAL.REF,POS.STOP.TIME,START.COUNT> = ''

            R.NEW(REDO.PS.ACCT.EXPIRY.DATE)<1,START.COUNT> = TODAY
            Y.FLAG = '1'

        END

        START.COUNT += 1  ;*R22 AUTO CODE CONVERSION

    REPEAT
    IF Y.FLAG THEN
        GOSUB UPDT.FLDS

    END
    GOSUB CHEQ.PARA.UPDATE
RETURN
*-----------------------------------------------------------------------
CHEQ.PARA.UPDATE:
*-----------------------------------------------------------------------

    Y.FRT.CHEQ.STOP = R.NEW(REDO.PS.ACCT.CHEQUE.FIRST)
    Y.STATUS.CS = R.NEW(REDO.PS.ACCT.PAY.STOP.STATUS)
    Y.FIRST.CS.COUNT = DCOUNT(Y.FRT.CHEQ.STOP,@VM) ;*R22 AUTO CODE CONVERSION
    Y.LST.CHEQ.STOP = R.NEW(REDO.PS.ACCT.CHEQUE.LAST)
    Y.CS.CNT = 1
    LOOP
    WHILE Y.CS.CNT LE Y.FIRST.CS.COUNT
        Y.FIRST.CHEQ.STOP = Y.FRT.CHEQ.STOP<1,Y.CS.CNT>
        LOOP
        WHILE Y.FIRST.CHEQ.STOP LE Y.LST.CHEQ.STOP<1,Y.CS.CNT>
            Y.CHQ.STOP.PARA.ID = Y.AC.OGM.ID:"*":Y.FIRST.CHEQ.STOP
            IF Y.STATUS.CS<1,Y.CS.CNT> EQ 'NONE' THEN
                R.REDO.CHEQUE.STOP.PARA<CHQ.STOP.STATUS> = 'NONE'
                CALL F.WRITE(FN.REDO.CHEQUE.STOP.PARA,Y.CHQ.STOP.PARA.ID,R.REDO.CHEQUE.STOP.PARA)
                CALL F.DELETE(FN.REDO.CHEQUE.STOP.PARA,Y.CHQ.STOP.PARA.ID)

            END

            Y.FIRST.CHEQ.STOP += 1 ;*R22 AUTO CODE CONVERSION
        REPEAT

        Y.CS.CNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT
RETURN

*-----------------------------------------------------------------------------

UPDT.FLDS:
*-----------------------------------------------------------------------------

    APP.NAME = 'PAYMENT.STOP'
    OFSFUNCT = 'I'
    PROCESS  = 'PROCESS'
    OFSVERSION = 'PAYMENT.STOP,UPDATE'
    GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = Y.ACCT.ID
    OFSRECORD = ''
    OFS.MSG.ID =''
    OFS.SOURCE.ID = 'PAYMENT.STOP.UPDATE'
    OFS.ERR = ''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.PAYSTOP,OFSRECORD)
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

RETURN
END
*-----------------------------------------------------------------------
