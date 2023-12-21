* @ValidationCode : MjotMTg0MjY3OTAyMTpDcDEyNTI6MTY5ODc1MDY3MzcxMTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>-67</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE T24.FS.VALIDATE
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion             USPLATFORM.BP File Removed, VM TO @VM, CALL GET.LOC.REF
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY
    $INCLUDE I_F.TFS.TRANSACTION ;*R22 Manual Conversion
    $INCLUDE I_T24.FS.COMMON ;*R22 Manual Conversion
    $INCLUDE I_F.T24.FUND.SERVICES ;*R22 Manual Conversion
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.TRANSACTION
    $INCLUDE I_F.TFS.PARAMETER ;*R22 Manual Conversion
    $USING EB.LocalReferences

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

**************
INITIALISE:
**************

    TXN.CNT = ''
    TFS.TXN = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    PRMY.ACC = ''
    R.PRMY.ACC = ''
    PRMY.ACC.ERR = ''
    PRMY.ACC.CCY = ''
    TXN.CCY = ''
    FN.CURRENCY = ''
    F.CURRENCY = ''
    CCY.SEL.RATE = ''
    R.PRM.ACC.CCY = ''
    CCY.ERR = ''
    TFS.CCY.MKT = ''
    FN.TFS.TXN = 'F.TFS.TRANSACTION'
    F.TFS.TXN = ''
    R.TFS.TXN = ''
    TFS.TXN.ERR = ''
    CCY.MKT.POS = ''
    TXN.AMT.LOCAL = ''
    DIFF = ''
    TXN.AMT.FCY = ''
    RET.CODE = ''
    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    TXNS.LIST = ''
    CCY.MKT.POS = ''
    DEAL.RATE = ''
    CCY.BUY.RATE = ''
    TTXN.ID = ''
    FN.TTXN = 'F.TELLER.TRANSACTION'
    F.TTXN = ''
    R.TTXN = ''
    ERR.TTXN = ''
    FN.TXN = 'F.TRANSACTION'
    F.TXN = ''
    R.TXN = ''
    ERR.TXN = ''
    TXN.ID = ''
    DR.OR.CR = ''

RETURN

**************
OPEN.FILES:
**************

    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.CURRENCY,F.CURRENCY)
    CALL OPF(FN.TFS.TXN,F.TFS.TXN)
    CALL OPF(FN.TTXN,F.TTXN)
    CALL OPF(FN.TXN,F.TXN)

RETURN

**************
PROCESS:
**************

    TXNS.LIST = R.NEW(TFS.TRANSACTION)
    TXN.CNT = DCOUNT(TXNS.LIST,@VM) ;*R22 Manual Conversion
*    CALL GET.LOC.REF("TFS.TRANSACTION","TFS.CCY.MKT",TFS.CCY.MKT.POS)
    EB.LocalReferences.GetLocRef("TFS.TRANSACTION","TFS.CCY.MKT",TFS.CCY.MKT.POS)
    TFS.APP = TFS$R.TFS.PAR<TFS.PAR.APPLICATION>
    FOR I = 1 TO TXN.CNT
        GOSUB CLEAR.VARIABLES
        TXN.AMT.LOCAL = R.NEW(TFS.AMOUNT)<1,I>
        TFS.TXN.CCY.MKT = TFS$R.TFS.TXN(I)<TFS.TXN.LOCAL.REF,TFS.CCY.MKT.POS>
        PRMY.ACC = R.NEW(TFS.PRIMARY.ACCOUNT)
        CALL F.READ(FN.ACCOUNT,PRMY.ACC,R.PRMY.ACC,F.ACCOUNT,PRMY.ACC.ERR)
        PRMY.ACC.CCY = R.PRMY.ACC<AC.CURRENCY>
        TXN.CCY = R.NEW(TFS.CURRENCY)<1,I>
        TTXN.ID = TFS$R.TFS.TXN(I)<TFS.TXN.INTERFACE.AS>
        CALL F.READ(FN.TTXN,TTXN.ID,R.TTXN,F.TTXN,ERR.TTXN)

        IF R.TTXN THEN
            TXN.CODE.1 = R.TTXN<TT.TR.TRANSACTION.CODE.1>
            CALL F.READ(FN.TXN,TXN.CODE.1,R.TXN,F.TXN,ERR.TXN)
            DR.OR.CR = R.TXN<AC.TRA.DEBIT.CREDIT.IND>
        END

        IF TFS$R.TFS.TXN(I)<TFS.TXN.INTERFACE.TO> EQ 'TT' THEN
            IF TXN.CCY NE PRMY.ACC.CCY THEN
*                GOSUB SET.FCY.FLAG

                BEGIN CASE
                    CASE DR.OR.CR EQ "DEBIT"
                        GOSUB PROCESS.DEBIT

                    CASE DR.OR.CR EQ "CREDIT"
                        GOSUB PROCESS.CREDIT

                END CASE
            END     ;* HD0933751 20090904 UMAR S/E
        END

    NEXT I

RETURN

**************
CLEAR.VARIABLES:
**************
    TXN.AMT.LOCAL = ''
    TFS.TXN.CCY.MKT = ''
    PRMY.ACC = ''
    R.PRMY.ACC = ''
    PRMY.ACC.ERR = ''
    PRMY.ACC.CCY = ''
    TXN.CCY = ''
    TTXN.ID = ''
    R.TTXN = ''
    ERR.TTXN = ''
    TXN.CODE.1 = ''
    R.TXN = ''
    ERR.TXN = ''
    DR.OR.CR = ''
    R.PRM.ACC.CCY = ''
    CCY.ERR = ''
    CCY.MKT.POS = ''
    CCY.SEL.RATE = ''
    TXN.AMT.FCY = ''
    TXN.AMT.LCCY = ''
    RET.CODE = ''
    CUST.RATE = ''
    TR.RATE = ''
    CUST.SPREAD = ''
    SPREAD.PCT = ''
    LCY.AMT1 = ''
    LCY.AMT2 = ''
    RET.CODE = ''

RETURN

**************
PROCESS.DEBIT:
**************

*    IF DEBIT.SIDE THEN
    !*        BUY.CCY = TXN.CCY ; SELL.CCY = PRMY.ACC.CCY ; BUY.AMT = TXN.AMT.LOCAL ; SELL.AMT = ''
*    BUY.CCY = PRMY.ACC.CCY ; SELL.CCY = TXN.CCY ; BUY.AMT = '' ; SELL.AMT = TXN.AMT.LOCAL
*    END

*    IF CREDIT.SIDE THEN
    !*        BUY.CCY = PRMY.ACC.CCY ; SELL.CCY = TXN.CCY ; BUY.AMT = '' ; SELL.AMT = TXN.AMT.LOCAL
    BUY.CCY = TXN.CCY ; SELL.CCY = PRMY.ACC.CCY ; BUY.AMT = TXN.AMT.LOCAL ; SELL.AMT = ''
*    END

    IF R.NEW(TFS.DEAL.RATE)<1,I> EQ '' THEN

*        IF DEBIT.SIDE THEN
*            BUY.CCY = TXN.CCY ; SELL.CCY = PRMY.ACC.CCY ; BUY.AMT = TXN.AMT.LOCAL ; SELL.AMT = ''
*        END
*
*        IF CREDIT.SIDE THEN
*            BUY.CCY = PRMY.ACC.CCY ; SELL.CCY = TXN.CCY ; BUY.AMT = '' ; SELL.AMT = TXN.AMT.LOCAL
*        END

        CALL CUSTRATE(TFS.TXN.CCY.MKT,BUY.CCY,BUY.AMT,SELL.CCY,SELL.AMT,'',TR.RATE,CUST.RATE,CUST.SPREAD,SPREAD.PCT,LCY.AMT1,LCY.AMT2,RET.CODE)

        R.NEW(TFS.DEAL.RATE)<1,I> = CUST.RATE

*        IF DEBIT.SIDE THEN
*            R.NEW(TFS.FCY.AMOUNT)<1,I> = SELL.AMT
*        END ELSE
*            R.NEW(TFS.FCY.AMOUNT)<1,I> = BUY.AMT
*        END

    END ELSE
        DEAL.RATE = R.NEW(TFS.DEAL.RATE)<1,I>
        CALL EXCHRATE(TFS.TXN.CCY.MKT,BUY.CCY,BUY.AMT,SELL.CCY,SELL.AMT,TXN.CCY,DEAL.RATE,DIFF,TXN.AMT.LCCY,RET.CODE)
*        R.NEW(TFS.FCY.AMOUNT)<1,I> = TXN.AMT.LCCY
    END

*    IF DEBIT.SIDE THEN
*R.NEW(TFS.FCY.AMOUNT)<1,I> = SELL.AMT
*    END ELSE
*        R.NEW(TFS.FCY.AMOUNT)<1,I> = BUY.AMT
*    END

RETURN

***************
PROCESS.CREDIT:
***************

*    IF CREDIT.SIDE THEN
*        BUY.CCY = TXN.CCY ; SELL.CCY = PRMY.ACC.CCY ; BUY.AMT = TXN.AMT.LOCAL ; SELL.AMT = ''
*    END
*
*    IF DEBIT.SIDE THEN
*        BUY.CCY = PRMY.ACC.CCY ; SELL.CCY = TXN.CCY ; BUY.AMT = '' ; SELL.AMT = TXN.AMT.LOCAL
*    END

    BUY.CCY = PRMY.ACC.CCY ; SELL.CCY = TXN.CCY ; BUY.AMT = '' ; SELL.AMT = TXN.AMT.LOCAL


    IF R.NEW(TFS.DEAL.RATE)<1,I> EQ '' THEN

*        IF CREDIT.SIDE THEN
*            BUY.CCY = TXN.CCY ; SELL.CCY = PRMY.ACC.CCY ; BUY.AMT = TXN.AMT.LOCAL ; SELL.AMT = ''
*        END
*
*        IF DEBIT.SIDE THEN
*            BUY.CCY = PRMY.ACC.CCY ; SELL.CCY = TXN.CCY ; BUY.AMT = '' ; SELL.AMT = TXN.AMT.LOCAL
*        END

        CALL CUSTRATE(TFS.TXN.CCY.MKT,BUY.CCY,BUY.AMT,SELL.CCY,SELL.AMT,'',TR.RATE,CUST.RATE,CUST.SPREAD,SPREAD.PCT,LCY.AMT1,LCY.AMT2,RET.CODE)
*        CALL EXCHRATE(TFS.TXN.CCY.MKT,BUY.CCY,BUY.AMT,SELL.CCY,SELL.AMT,TXN.CCY,CUST.RATE,DIFF,TXN.AMT.LCCY,RET.CODE)

        R.NEW(TFS.DEAL.RATE)<1,I> = CUST.RATE

*        IF DEBIT.SIDE THEN
*            R.NEW(TFS.FCY.AMOUNT)<1,I> = BUY.AMT
*        END ELSE
*            R.NEW(TFS.FCY.AMOUNT)<1,I> = SELL.AMT
*        END

    END ELSE
        DEAL.RATE = R.NEW(TFS.DEAL.RATE)<1,I>
        CALL EXCHRATE(TFS.TXN.CCY.MKT,BUY.CCY,BUY.AMT,SELL.CCY,SELL.AMT,TXN.CCY,DEAL.RATE,DIFF,TXN.AMT.LCCY,RET.CODE)
*        R.NEW(TFS.FCY.AMOUNT)<1,I> = TXN.AMT.LCCY
    END

*    IF DEBIT.SIDE THEN
*R.NEW(TFS.FCY.AMOUNT)<1,I> = BUY.AMT
*    END ELSE
*        R.NEW(TFS.FCY.AMOUNT)<1,I> = SELL.AMT
*    END


RETURN

!***************
!SET.FCY.FLAG:
!***************
!
!
!    BOTH.SIDE = ''
!    CREDIT.SIDE = ''
!    DEBIT.SIDE = ''
!
!    IF PRMY.ACC.CCY NE LCCY THEN
!        IF TXN.CCY NE LCCY THEN
!            BOTH.SIDE = 1
!        END
!        DEBIT.SIDE = 1
!    END ELSE
!        CREDIT.SIDE = 1
!    END
!
!    RETURN
!

END



