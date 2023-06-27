* @ValidationCode : MjotNDAzMTI5MDA1OkNwMTI1MjoxNjg0ODM2MDQxODk1OklUU1M6LTE6LTE6NTY1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 565
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.INP.BULK.TRNS
*******************************************
*----------------------------------------------------------
* COMPANY NAME    : APAP
* DEVELOPED BY    : Pradeep.P
* PROGRAM NAME    : REDO.APAP.INP.BULK.TRNS
*----------------------------------------------------------


* DESCRIPTION     : This routine is a input routine attached
* FT.BULK.SUP.PAY,REDO.MUL.SUP.PAY version for posting multiple FTs
*------------------------------------------------------------

* IN PARAMETER   : NONE
* OUT PARAMETER  : NONE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*31.12.2010     Pradeep.P             ODR-2010-08-0031    INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------


*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FT.BULK.SUP.PAY
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
*

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*
INIT:
*----
    FN.FT.BULK.SUP.PAY = 'F.FT.BULK.SUP.PAY'
    F.FT.BULK.SUP.PAY = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''

    FN.AI.REDO.ARCIB.PARAMETER = 'F.AI.REDO.ARCIB.PARAMETER'
    F.AI.REDO.ARCIB.PARAMETER  = ''

    FN.AI.REDO.OFS.QUEUE = 'F.AI.REDO.OFS.QUEUE'
    F.AI.REDO.OFS.QUEUE  = ''


RETURN
*
OPENFILES:
*---------
    CALL OPF(FN.FT.BULK.SUP.PAY,F.FT.BULK.SUP.PAY)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.AI.REDO.ARCIB.PARAMETER,F.AI.REDO.ARCIB.PARAMETER)
    CALL OPF(FN.AI.REDO.OFS.QUEUE,F.AI.REDO.OFS.QUEUE)
    CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,AI.REDO.ARCIB.PARAMETER.ERR)
    IF NOT(AI.REDO.ARCIB.PARAMETER.ERR) THEN
        Y.TRANSACTION.TYPE = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.TRANSACTION.TYPE>
        Y.TRANSACTION.CODE = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.TRANSACTION.CODE>
        CHANGE @VM TO @FM IN Y.TRANSACTION.TYPE
        CHANGE @VM TO @FM IN Y.TRANSACTION.CODE
        LOCATE 'MULTI-PAYMENT' IN Y.TRANSACTION.TYPE SETTING MULTI.POS THEN
            Y.TXN.CODE = Y.TRANSACTION.CODE<MULTI.POS>
        END
    END
RETURN
*
PROCESS:
*--------

    Y.DEB.ACCT = R.NEW(FT.BUL76.DR.ACCOUNT)
    Y.DEB.CCY = R.NEW(FT.BUL76.DR.CURRENCY)

    CALL F.READ(FN.ACCOUNT,Y.DEB.ACCT,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
    Y.DEB.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
    GOSUB GET.LOC.REF.DETS
    Y.AVAL.BAL = R.ACCOUNT<AC.LOCAL.REF,Y.AV.BAL.POS>
    Y.CRD.AMT = R.NEW(FT.BUL76.CR.AMOUNT)
    CHANGE @VM TO @FM IN Y.CRD.AMT
    Y.TOT.CRE.AMT = SUM(Y.CRD.AMT)
    Y.CR.ACCT = R.NEW(FT.BUL76.CR.ACCOUNT)
    Y.CNTR = 1
    Y.CNT = DCOUNT(Y.CR.ACCT,@VM)
    LOOP
    WHILE Y.CNTR LE Y.CNT
        Y.CR.ACT = R.NEW(FT.BUL76.CR.ACCOUNT)<1,Y.CNTR>
        Y.CR.AMT = R.NEW(FT.BUL76.CR.AMOUNT)<1,Y.CNTR>
        Y.FT.COMMENT = R.NEW(FT.BUL76.L.FT.COMMENT)<1,Y.CNTR>

        IF Y.CR.AMT LT 0 THEN
            AF = FT.BUL76.CR.AMOUNT
            AV = Y.CNTR
            ETEXT = 'FT-INP.CANT.NEGATIVE'
            CALL STORE.END.ERROR
        END
        Y.CR.CCY=R.NEW(FT.BUL76.CR.CURRENCY)
        Y.SIGN.CUS = R.NEW(FT.BUL76.ORDERING.CUS)
        APP.NAME='FUNDS.TRANSFER'
        OFS.FUNCTION='I'
        PROCESS='PROCESS'
        OFS.SOURCE.ID='OFSUPDATE'
        OFSVERSION='FUNDS.TRANSFER,AI.REDO.ARC.BULK.TRANSFER'
        GTS.MODE=''
        NO.OF.AUTH='0'

        R.APP.RECORD=''
        OFS.STRING=''
        OFS.MSG.ID = ''
        TRANSACTION.ID=''
        R.APP.RECORD<FT.DEBIT.ACCT.NO>=Y.DEB.ACCT
        R.APP.RECORD<FT.DEBIT.AMOUNT>  = Y.CR.AMT
        R.APP.RECORD<FT.DEBIT.CURRENCY>= Y.CR.CCY
        R.APP.RECORD<FT.CREDIT.ACCT.NO>=Y.CR.ACT
        R.APP.RECORD<FT.CREDIT.CURRENCY>=Y.CR.CCY
        R.APP.RECORD<FT.SIGNATORY> = Y.SIGN.CUS
        R.APP.RECORD<FT.PAYMENT.DETAILS> = Y.FT.COMMENT
        CALL OFS.BUILD.RECORD(APP.NAME,OFS.FUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.APP.RECORD,OFS.STRING)
        OFS.STRING.AFTER.VAL<Y.CNTR>=OFS.STRING
        Y.CNTR += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT
    Y.CNTR = 1
    Y.CNT = DCOUNT(Y.CR.ACCT,@VM)
    LOOP
    WHILE Y.CNTR LE Y.CNT
*        CALL OFS.POST.MESSAGE(OFS.STRING.AFTER.VAL<Y.CNTR>,MSG.KEY,OFS.SOURCE.ID,OFS.ERR)
        CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
        ARC.OFS.ID = ID.NEW:'.':UNIQUE.TIME
*    WRITE OFS.STRING.AFTER.VAL<Y.CNTR> TO F.AI.REDO.OFS.QUEUE,ARC.OFS.ID ;*Tus Start
        CALL F.WRITE(FN.AI.REDO.OFS.QUEUE,ARC.OFS.ID,OFS.STRING.AFTER.VAL<Y.CNTR>) ;*Tus End
        Y.CNTR += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT

RETURN
******************
GET.LOC.REF.DETS:
*****************
    Y.APP = 'ACCOUNT'
    Y.FLDS = 'L.AC.AV.BAL'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLDS,Y.POS)
    Y.AV.BAL.POS = Y.POS
RETURN
*
END
