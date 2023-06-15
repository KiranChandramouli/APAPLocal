* @ValidationCode : MjotMjQ4MTkxMzgzOkNwMTI1MjoxNjg0ODQyMTMyMTM3OklUU1M6LTE6LTE6ODM6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 83
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.STO.OVERRIDE.PARAM.VALIDATE
*-----------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.STO.OVERRIDE.PARAM table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* Revision History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*24.08.2010      SUDHARSANAN S      PACS00054326    INITIAL CREATION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION        FM TO @FM, VM TO @VM,++ TO +=, F.READ TO CACHE.READ
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.OVERRIDE
    $INSERT I_F.REDO.STO.OVERRIDE.PARAM

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*----------
OPENFILES:
*----------
    FN.OVERRIDE = 'F.OVERRIDE'
    F.OVERRIDE = ''
    CALL OPF(FN.OVERRIDE,F.OVERRIDE)
RETURN
*---------
PROCESS:
*---------

    VAR.OVERRIDE.ID = R.NEW(STO.OVE.OVERRIDE.ID)
    CHANGE @VM TO @FM IN VAR.OVERRIDE.ID
    OVERRIDE.ID.CNT = DCOUNT(VAR.OVERRIDE.ID,@FM) ; CNT.LOOP  = 1

    LOOP
    WHILE CNT.LOOP LE OVERRIDE.ID.CNT
        Y.OVERRIDE.ID  = VAR.OVERRIDE.ID<CNT.LOOP>
        CALL CACHE.READ(FN.OVERRIDE, Y.OVERRIDE.ID, R.OVER.VALUES, OVR.ERR) ;*AUTO R22 CODE CONVERSION
        Y.MESSAGE = R.OVER.VALUES<EB.OR.MESSAGE,1>
        R.NEW(STO.OVE.MESSAGE)<1,CNT.LOOP> = Y.MESSAGE
        CNT.LOOP += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
RETURN
*---------------------------------------------------------------------
END
