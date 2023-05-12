* @ValidationCode : MjoxODUxNzIxMTgwOkNwMTI1MjoxNjgzODExOTUxMjQ2OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 May 2023 19:02:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.REINV.INT.LIQ.BAL

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.INT.LIQ.BAL
*--------------------------------------------------------------------------------
* Description: This Authorisation routine is for Teller & FT application to update
* the balance of Interest Liq Account in reinvested deposit
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE           DESCRIPTION
* 05-Jul-2011    H GANESH       PACS00072695_N.11  INITIAL CREATION
* 10.04.2023   Conversion Tool       R22            Auto Conversion     - FM TO @FM
* 10.04.2023   Shanmugapriya M       R22            Manual Conversion   - CALL routine format modified
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER

    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    LOC.REF.APPLICATION="ACCOUNT":@FM:'AZ.ACCOUNT':@FM:'FUNDS.TRANSFER':@FM:'TELLER'
    LOC.REF.FIELDS='L.AC.AV.BAL':@FM:'L.AZ.REIVSD.INT':@FM:'L.FT.AZ.ACC.REF':@FM:'L.TT.AZ.ACC.REF'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS) ;*MANUAL R22 CODE CONVERSION
    POS.L.AC.AV.BAL = LOC.REF.POS<1,1>
    POS.L.AZ.REIVSD.INT = LOC.REF.POS<2,1>
    FT.L.FT.AZ.ACC.REF = LOC.REF.POS<3,1>
    TT.L.TT.AZ.ACC.REF = LOC.REF.POS<4,1>

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB FT
    END
    IF APPLICATION EQ 'TELLER' THEN
        GOSUB TT
    END

RETURN
*---------------------------------------------------------------------------------
FT:
*---------------------------------------------------------------------------------
    Y.AZ.ID = R.NEW(FT.LOCAL.REF)<1,FT.L.FT.AZ.ACC.REF>
    CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
    Y.INT.LIQ.ACC = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
    CALL F.READ(FN.ACCOUNT,Y.INT.LIQ.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.INT.LIQ.BAL = R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.AV.BAL>
    R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.L.AZ.REIVSD.INT> = Y.INT.LIQ.BAL
    CALL F.WRITE(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT)
RETURN
*---------------------------------------------------------------------------------
TT:
*---------------------------------------------------------------------------------
    Y.AZ.ID = R.NEW(TT.TE.LOCAL.REF)<1,TT.L.TT.AZ.ACC.REF>
    CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
    Y.INT.LIQ.ACC = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
    CALL F.READ(FN.ACCOUNT,Y.INT.LIQ.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.INT.LIQ.BAL = R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.AV.BAL>
    R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.L.AZ.REIVSD.INT> = Y.INT.LIQ.BAL
    CALL F.WRITE(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT)

RETURN
END
