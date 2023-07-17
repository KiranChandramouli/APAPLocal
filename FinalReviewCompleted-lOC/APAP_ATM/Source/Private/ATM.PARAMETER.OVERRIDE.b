* @ValidationCode : MjotMTc1MDkzNTYwNDpDcDEyNTI6MTY4NDUwMjM3ODIzMDphaml0aDotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 18:49:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
* Version 2 03/04/00  GLOBUS Release No. G10.2.01 25/02/00
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   CALL DBR to CALL CACHE.READ ,= to EQ
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
SUBROUTINE ATM.PARAMETER.OVERRIDE
************************************************************************
*
* Routine to process the overrides for a XXXX contract
*
************************************************************************
* XX/XX/XX - GBXXXXXXX
*            Pif Description
*
************************************************************************

************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATM.PARAMETER
    $INSERT I_F.INTERCO.PARAMETER
************************************************************************
************************************************************************

    GOSUB INITIALISE

    GOSUB PROCESS.OVERRIDES

RETURN
*
************************************************************************
*
PROCESS.OVERRIDES:

*
* Place Overrides Here
*
* Set text to be the key to the override you
* want to use form the OVERRIDE file
*
* Set AF/AV/AS to be the Field you wish GLOBUS
* to return to if the user rejects the override
*
* AF = XX.RETURN.FIELD
* TEXT = "SAMPLE.OVERRIDE.KEY"
* GOSUB DO.OVERRIDE
*
    Y.ACCT.NO.LENGHT = 0
    CALL CACHE.READ('F.INTERCO.PARAMETER', 'SYSTEM', R.INTERCO.PARAMETER.2, ERR.FREAD)
    Y.ACCT.NO.LENGTH = R.INTERCO.PARAMETER.2<ST.ICP.ACCOUNT.NO.LENGTH> ;*R22 AUTO CODE CONVERSION
    IF ETEXT EQ '' AND Y.ACCT.NO.LENGTH NE R.NEW(ATM.PARA.ACCT.NO.LEN) THEN
        AF = ATM.PARA.ACCT.NO.LEN
        TEXT = 'ACCT.NO.LENGTH DEFFERS FROM THAT DEFINED IN INTERCO.PARAMETER'
        GOSUB DO.OVERRIDE
    END
RETURN
*
************************************************************************
*
DO.OVERRIDE:
    CALL STORE.OVERRIDE(CURR.NO)
    IF TEXT EQ 'NO' THEN ;*R22 AUTO CODE CONVERSION
        GOSUB PROGRAM.ABORT;* R22 Manual conversion - GOTO changed to GOSUB
    END
RETURN
*
*************************************************************************

*************************************************************************
*
INITIALISE:

    CURR.NO = 0
    CALL STORE.OVERRIDE(CURR.NO)

RETURN
*
*************************************************************************
*
* If the user said no, get the hell out..
*
PROGRAM.ABORT:

RETURN TO PROGRAM.ABORT
RETURN
*
*************************************************************************
*
END
