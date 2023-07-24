* @ValidationCode : MjoyMTM2MTA5NzE0OkNwMTI1MjoxNjgyNDEyMzQ3MTA3OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
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
SUBROUTINE REDO.V.ID.TTID.OPEN
*-----------------------------------------------------------------------------
*
*******************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: V NAVA
* PROGRAM NAME: REDO.V.ID.TTID.OPEN
*----------------------------------------------------------------------
*DESCRIPTION: This routine is used to check that current TELLER.ID record
*it's already OPEN, sends and error.
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:   TELLER.ID,OPEN and TELLER.ID,AUTH versions.
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO                  REFERENCE                      DESCRIPTION
*20.10.2012     V.NAVA             PACS00230506                  INITIAL CREATION
*11-04-2023     Conversion Tool     R22 Auto Code conversion          No Changes
*11-04-2023     Samaran T            R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.ID
*-----------------------------------------------------------------------
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
    Y.FUNCT        = V$FUNCTION
    TO.VAULT.ID    = COMI
    Y.TTID.ST      = ""
*
RETURN
*
*-------
PROCESS:
*-------
*
    R.TELLER.ID = "" ; TT.ID.ERR = ""
    CALL F.READ(FN.TELLER.ID, TO.VAULT.ID, R.TELLER.ID, F.TELLER.ID, TT.ID.ERR)
    IF R.TELLER.ID NE "" THEN
        GOSUB GET.TTID.STATUS     ;* Get current status of cashier.
    END
*
RETURN
*
*** <region name= GET.TTID.STATUS>
GET.TTID.STATUS:
*** <desc>Get current status of cashier.</desc>
    Y.TTID.ST = R.TELLER.ID<TT.TID.STATUS>
    IF Y.TTID.ST EQ "OPEN" AND Y.FUNCT EQ "I" THEN
        E = 'EB-ONLY.CLOSE'
    END
*
RETURN
*** </region>
END
