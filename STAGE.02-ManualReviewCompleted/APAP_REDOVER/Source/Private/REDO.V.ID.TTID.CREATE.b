* @ValidationCode : MjoxNTQ4NTQ1MDgxOkNwMTI1MjoxNjgyNDEyMzQ3MDk1OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:47
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
SUBROUTINE REDO.V.ID.TTID.CREATE
*-----------------------------------------------------------------------------
*
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: V NAVA
* PROGRAM NAME: REDO.V.ID.TTID.CREATE
*----------------------------------------------------------------------
*DESCRIPTION: This routine is used to check that current TELLER.ID record
*it's already CREATED, sends and error.
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:   TELLER.ID,CREATE version.
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO                  REFERENCE                      DESCRIPTION
*20.10.2012     V.NAVA            PACS00230506                    INITIAL CREATION
*11-04-2023    Conversion Tool     R22 Auto Code conversion          No Changes
*11-04-2023     Samaran T          R22 Manual Code Conversion         No Changes
*----------------------------------------------------------------------------------------
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
*
    GOSUB INITIALISE
    GOSUB PROCESS
*
RETURN
*
*----------
INITIALISE:
*----------
*
    F.TELLER.ID = ''
    FN.TELLER.ID = 'F.TELLER.ID'
    CALL OPF(FN.TELLER.ID, F.TELLER.ID)
*
    TO.VAULT.ID    = COMI
    Y.FUNCT        = V$FUNCTION
*
RETURN
*
*-------
PROCESS:
*-------
*
    R.TELLER.ID = "" ; TT.ID.ERR = ""
    CALL F.READ(FN.TELLER.ID, TO.VAULT.ID, R.TELLER.ID, F.TELLER.ID, TT.ID.ERR)
    IF R.TELLER.ID NE "" AND Y.FUNCT EQ "I" THEN
        E = 'EB-ONLY.NOT.CREATED'
    END
*
RETURN
*
*** </region>
END
