* @ValidationCode : MjotMTE5OTQ4NTY3OkNwMTI1MjoxNjk4MjM4MjA2MjE3OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Oct 2023 18:20:06
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
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.REDO.SET.VAR.BENEF
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                  Nochanges
*-----------------------------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Description :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.BENEFICIARY

*-----------------------------------------------------------------------------

    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
* Main Process
PROCESS:
*-------

    CALL System.setVariable('EXT.SMS.CUSTOMERS',R.NEW(ARC.BEN.OWNING.CUSTOMER)<1,1,1>)
    PGM.VERSION = ',AI.REDO.ADD.OWN.BANK.BEN'
*    ETEXT=  System.getVariable('EXT.SMS.CUSTOMERS') :  " test"
*    CALL STORE.END.ERROR

    RETURN

*-----------------------------------------------------------------------------

END
