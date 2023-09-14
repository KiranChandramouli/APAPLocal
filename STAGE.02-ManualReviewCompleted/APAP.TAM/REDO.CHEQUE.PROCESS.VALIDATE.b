* @ValidationCode : MjotMTE3NTYxNDg1NjpDcDEyNTI6MTY4MDc4MDY5Mjc1MzpJVFNTMTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:01:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CHEQUE.PROCESS.VALIDATE
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CHEQUE.PROCESS.VALIDATE
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
*            This validation routine is be attached to the VERSION FUNDS.TRANSFER,REINV.WDL
* to populate DEBIT.ACCOUNT number and currency
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 22-AUG-2011     JEEVA T      PACS00103288       changes made (DRAFT.CHECK)
** 05-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 05-04-2023 Skanda R22 Manual Conversion - No Change
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.CHEQUE.PROCESS


    GOSUB INIT
    GOSUB GET.LOC.VALUES
    GOSUB PROCESS
    GOSUB AMT.CHECK
RETURN

*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.AZACCOUNT='F.AZ.ACCOUNT'
    F.AZACCOUNT=''
    R.AZACCOUNT=''
    CALL OPF(FN.AZACCOUNT,F.AZACCOUNT)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    R.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    R.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    Y.VAL.DRAFT = ''

RETURN

*-----------------------------------------------------------------------------
GET.LOC.VALUES:
*----------------
* Get the Needed Local table position
*
    LOC.REF.APPL="FUNDS.TRANSFER":@FM:'ACCOUNT'
    LOC.REF.FIELDS='L.FT.REINV.AMT':@VM:'L.FT.ORG.DEPST':@VM:'BENEFIC.NAME':@FM:'L.AC.AV.BAL'
    LOC.REF.POS=" "
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.L.REIVSD.INT.POS     = LOC.REF.POS<1,1>
    Y.L.ORG.DP.AMT.POS     = LOC.REF.POS<1,2>
    POS.BENEFIC.NAME       = LOC.REF.POS<1,3>
    Y.L.AC.AV.BAL          = LOC.REF.POS<2,1>


RETURN
*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------
    Y.FT.ACC.REF = ''
    Y.FT.ACC.REF=R.NEW(CHQ.PRO.AZ.ACCOUNT)
    IF NOT(Y.FT.ACC.REF) THEN
        R.NEW(FT.DEBIT.ACCT.NO)  = ''
        R.NEW(CHQ.PRO.DEBIT.CUR)= ''
        R.NEW(CHQ.PRO.ORG.DEPST) = ''
        R.NEW(CHQ.PRO.INT.AMT) = ''
        RETURN
    END
RETURN
*---------------------
AMT.CHECK:
*---------------------
    CALL F.READ(FN.AZACCOUNT,Y.FT.ACC.REF,R.AZACCOUNT,F.AZACCOUNT,Y.ERR)
    Y.INT.LIQ.ACCT = R.AZACCOUNT<AZ.INTEREST.LIQU.ACCT>
    IF Y.INT.LIQ.ACCT THEN
        CALL F.READ(FN.ACCOUNT,Y.INT.LIQ.ACCT,R.ACCOUNT,F.ACCOUNT,Y.ERR)
        Y.FIN.INT.AMT = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.AV.BAL>
    END
    Y.DEBIT.AMT = ''
    Y.INT.AMT = R.NEW(CHQ.PRO.INT.AMT)
    Y.DEBIT.AMT =R.NEW(CHQ.PRO.DEBIT.AMOUNT)

    IF NOT(Y.DEBIT.AMT) THEN
        AF =  CHQ.PRO.DEBIT.AMOUNT
        ETEXT="AC-INPUT.MISSING"
        CALL STORE.END.ERROR
    END
    IF Y.DEBIT.AMT GT Y.FIN.INT.AMT THEN
        AF =  CHQ.PRO.DEBIT.AMOUNT
        ETEXT="FT-REINV.WDL"
        CALL STORE.END.ERROR
    END
RETURN
END
