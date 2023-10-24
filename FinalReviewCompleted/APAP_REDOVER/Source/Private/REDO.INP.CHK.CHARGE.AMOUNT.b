* @ValidationCode : MjotMTA3NDEzMjMwOTpDcDEyNTI6MTY4MjQxMjMzMDc4OTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:30
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
SUBROUTINE REDO.INP.CHK.CHARGE.AMOUNT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.INP.CHK.CHARGE.AMOUNT
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
* This validation routine should be attached to the FT,SERVICE.CREATE to check the charge amount
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
* DATE WHO REFERENCE DESCRIPTION
* 10.07.2012 Sudhar PACS00197329 CREATION
*---------------------------------------------------------------------------
*Modification History
*DATE                     WHO                        REFERENCE               DESCRIPITION
*06-04-2023           Conversion Tool          R22 Auto Code conversion      FM TO @FM
*06-04-2023            Samaran T                Manual R22 Code Conversion    No Changes
*------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
*   $INSERT I_F.TELLER  ;*R22 AUTO CODE CONVERSION
    $INSERT I_F.FUNDS.TRANSFER


    GOSUB GET.LOC.VALUES
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
GET.LOC.VALUES:
*----------------
* Get the Needed Local table position
*
    LOC.REF.APPL='FUNDS.TRANSFER'
    LOC.REF.FIELDS="L.COMMENTS"
    LOC.REF.POS=" "
    CALL GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)


RETURN
*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------
    VAR.CR.AMOUNT = R.NEW(FT.CREDIT.AMOUNT)
    VAR.CHARGE.AMT = R.NEW(FT.LOCAL.REF)<1,LOC.REF.POS>
    IF VAR.CHARGE.AMT NE VAR.CR.AMOUNT THEN
        AF = FT.CREDIT.AMOUNT
        ETEXT = 'FT-CREDIT.CHARGE.AMT':@FM:VAR.CHARGE.AMT
        CALL STORE.END.ERROR
        RETURN
    END
RETURN
END
