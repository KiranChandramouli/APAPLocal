* @ValidationCode : MjotNzQyOTgwODc2OkNwMTI1MjoxNjgxMjE0ODY2MDMwOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 17:37:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.DUE.BILL
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.INP.DUE.BILL
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is a validation routine attached to install payment version of FT and TELLER
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who                  Reference                       Description
* 3-JUN-2010        Prabhu.N            ODR-2010-01-0081                Initial Creation

* 31-MAY-2011       Dhamu.S             ODR-2009-10-0331              PACS00061651 issue
*11-04-2023         Conversion Tool     R22 Auto Code conversion      FM TO @FM VM TO @VM
*11-04-2023         Samaran T           R22 Manual Code conversion       No Changes
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
*   $INSERT I_F.TELLER    ;*R22 AUTO CODE CONVERSION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT

    IF V$FUNCTION EQ 'I' THEN
        GOSUB INIT
    END
RETURN
INIT:
    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS=''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    APL.ARRAY = 'FUNDS.TRANSFER':@FM:'TELLER'
    APL.FIELD = 'L.LOAN.STATUS.1':@VM:'L.LOAN.COND':@FM:'L.LOAN.STATUS.1':@VM:'L.LOAN.COND'
    FLD.POS   = ''

    CALL MULTI.GET.LOC.REF(APL.ARRAY,APL.FIELD,FLD.POS)
    FT.LOC.LOAN.STATUS1.POS = FLD.POS<1,1>
    FT.LOC.LOAN.COND.POS    = FLD.POS<1,2>
    TT.LOC.LOAN.STATUS1.POS = FLD.POS<2,1>
    TT.LOC.LOAN.COND.POS    = FLD.POS<2,2>

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        FT.FLAG = '1'
        VAR.AC.ID=R.NEW(FT.CREDIT.ACCT.NO)
        LOAN.STATUS = R.NEW(FT.LOCAL.REF)<1,FT.LOC.LOAN.STATUS1.POS>
        LOAN.COND   = R.NEW(FT.LOCAL.REF)<1,FT.LOC.LOAN.COND.POS>
        GOSUB PROCESS
    END
    IF APPLICATION EQ 'TELLER' THEN
        TT.FLAG = '1'
        VAR.AC.ID=R.NEW(TT.TE.ACCOUNT.2)
        LOAN.STATUS = R.NEW(TT.TE.LOCAL.REF)<1,TT.LOC.LOAN.STATUS1.POS>
        LOAN.COND   = R.NEW(TT.TE.LOCAL.REF)<1,TT.LOC.LOAN.COND.POS>
        GOSUB PROCESS
    END
RETURN

*********
PROCESS:
*********

    IF FT.FLAG EQ '1' THEN
        IF LOAN.STATUS EQ "Judicial Collection" OR LOAN.STATUS EQ "Write-off" THEN
            GOSUB CHECK.ERROR
        END
        IF LOAN.COND EQ "Legal" THEN
            GOSUB CHECK.ERROR
        END
    END
    IF TT.FLAG EQ '1' THEN
        IF LOAN.STATUS EQ "Judicial Collection" OR LOAN.STATUS EQ "Write-off" THEN
            GOSUB CHECK.ERROR
        END
        IF LOAN.COND EQ "Legal" THEN
            GOSUB CHECK.ERROR
        END
    END
RETURN
************
CHECK.ERROR:
************
    IF FT.FLAG EQ '1' THEN
        AF = FT.CREDIT.ACCT.NO
        ETEXT = 'EB-REDO.USE.COLLECT.AREA'
        CALL STORE.END.ERROR
    END

    IF TT.FLAG EQ '1' THEN
        AF = TT.TE.ACCOUNT.2
        ETEXT = 'EB-REDO.USE.COLLECT.AREA'
        CALL STORE.END.ERROR
    END
RETURN
******************************************************
END
*-----------------End of program----------------------------------------
