* @ValidationCode : Mjo0MzYwMTY4NTg6Q3AxMjUyOjE2ODExOTc1MzQ3MTk6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 12:48:54
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
SUBROUTINE REDO.V.ID.TTID.VAULT
*-----------------------------------------------------------------------------
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: V NAVA
* PROGRAM NAME: REDO.V.ID.TTID.VAULT
*----------------------------------------------------------------------
*DESCRIPTION: This routine is used to check that current TELLER.ID record
*it's a valid Vault on current COMPANY.
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:   TELLER.ID,MAIN.LIMIT version.
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO                 REFERENCE                          DESCRIPTION
*27.11.2012     V.NAVA             PACS00235401                     INITIAL CREATION
*11-04-2023    Conversion Tool     R22 Auto Code conversion      FM TO @FM VM TO @VM, CONVERT TO CHANGE
*11-04-2023     Samaran T          R22 Manual Code conversion          No Changes
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.PARAMETER
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
    F.TELLER.PARAMETER = ''
    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    CALL OPF(FN.TELLER.PARAMETER, F.TELLER.PARAMETER)
*
    Y.VAULT.ID     = COMI
    Y.FUNCT        = V$FUNCTION
*
RETURN
*
*-------
PROCESS:
*-------
*
    R.TELLER.PARAMETER = "" ; TT.PRM.ERR = ""
    CALL CACHE.READ(FN.TELLER.PARAMETER, ID.COMPANY, R.TELLER.PARAMETER, TT.PRM.ERR)
    IF R.TELLER.PARAMETER NE "" AND Y.FUNCT EQ "I" THEN
*
        LIST.OF.VAULTS = R.TELLER.PARAMETER<TT.PAR.VAULT.ID>
        CHANGE @VM TO @FM IN LIST.OF.VAULTS    ;*R22 AUTO CODE CONVERSION
*
        LOCATE Y.VAULT.ID IN LIST.OF.VAULTS SETTING POS THEN
*
        END
        ELSE
            E = 'TT-ONLY.ALLOW.TO.VAULT'
        END
*
    END
*
RETURN
*
END
