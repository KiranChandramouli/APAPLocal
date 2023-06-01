* @ValidationCode : MjotMTcxNTYxMDk3ODpDcDEyNTI6MTY4MjQxMjMzMjk3MjpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:32
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
SUBROUTINE REDO.V.ANC.SC.DEF.ACCOUNT
*---------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.ANC.SC.DEF.ACCOUNT
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is auto new content routine attached to DEBIT.ACCT.NO field in

*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: SEC.TRADE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO               REFERENCE                         DESCRIPTION
*06-04-2023    Conversion Tool    R22 Auto Code conversion          No Changes
*06-04-2023     Samaran T         R22 Manual Code Conversion         No Changes
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.COMPANY

    GOSUB INIT
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    FN.SEC.TRADE = 'F.SEC.TRADE'
    F.SEC.TRADE  = ''
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)

RETURN


*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.TRADE.CCY = R.NEW(SC.SBS.TRADE.CCY)
    Y.BROKER.TYPE = COMI
    Y.BROK.ACT.SUSP.CAT = R.NEW(SC.SBS.BROK.ACT.SUSP.CAT)
    Y.MISC.ACT.SUSP.CAT = R.NEW(SC.SBS.MISC.ACT.SUSP.CAT)
    Y.CUST.ACT.SUSP.CAT = R.NEW(SC.SBS.CUST.ACT.SUSP.CAT)
    Y.DIVISION.CODE = R.COMPANY(EB.COM.SUB.DIVISION.CODE)

    IF Y.BROK.ACT.SUSP.CAT EQ '' AND Y.MISC.ACT.SUSP.CAT EQ '' AND Y.CUST.ACT.SUSP.CAT EQ '' THEN


        RETURN

    END


    BEGIN CASE
        CASE Y.BROKER.TYPE EQ 'BROKER'
            R.NEW(SC.SBS.BR.ACC.NO) = Y.TRADE.CCY:Y.BROK.ACT.SUSP.CAT:'0001':Y.DIVISION.CODE
        CASE Y.BROKER.TYPE EQ 'COUNTERPARTY'
            R.NEW(SC.SBS.BR.ACC.NO) = Y.TRADE.CCY:Y.MISC.ACT.SUSP.CAT:'0001':Y.DIVISION.CODE
        CASE Y.BROKER.TYPE EQ 'CLIENT'
            R.NEW(SC.SBS.BR.ACC.NO) = Y.TRADE.CCY:Y.CUST.ACT.SUSP.CAT:'0001':Y.DIVISION.CODE
        CASE 1
            R.NEW(SC.SBS.BR.ACC.NO) = 'DOP':Y.MISC.ACT.SUSP.CAT:'0001':Y.DIVISION.CODE
    END CASE
RETURN
END
