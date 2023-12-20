* @ValidationCode : MjotMTkzMTEzNzc2NTpDcDEyNTI6MTY4MTA1NjQ4NTI0NzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.REINV.AUT.DEAL.SLIP
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.AUT.DEAL.SLIP
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
*This routine is a Authorisation routine for Admin cheque issue of reinvested interest
* withdrawal. Deal slip will be printed when local ref field in L.FT.AZ.ACC.REF(FT)
* L.TT.AZ.ACC.REF(TELLER) has value
*---------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 05-04-2011     H GANESH     N.11 - PACS00030247  Changes Made
* 10.04.2023  Conversion Tool       R22            Auto Conversion     - FM TO @FM
* 10.04.2023  Shanmugapriya M       R22            Manual Conversion   - No changes
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER


    GOSUB PROCESS

RETURN

*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------
* This routine produces the deal slip based on routine at authorisation level


    LOC.REF.APPLICATION="TELLER":@FM:"FUNDS.TRANSFER"
    LOC.REF.FIELDS='L.TT.AZ.ACC.REF':@FM:'L.FT.AZ.ACC.REF'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.TT.AZ.ACC.REF=LOC.REF.POS<1,1>
    POS.L.FT.AZ.ACC.REF=LOC.REF.POS<2,1>

    IF APPLICATION EQ 'TELLER' THEN
        IF R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.AZ.ACC.REF> NE '' THEN
            DEAL.SLIP.CALL = 'REDO.REINV.TTAD'
            CALL PRODUCE.DEAL.SLIP(DEAL.SLIP.CALL)
        END
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        IF R.NEW(FT.LOCAL.REF)<1,POS.L.FT.AZ.ACC.REF> NE '' THEN
            DEAL.SLIP.CALL = 'REDO.REINV.FTAD'
            CALL PRODUCE.DEAL.SLIP(DEAL.SLIP.CALL)
        END
    END

RETURN

END
