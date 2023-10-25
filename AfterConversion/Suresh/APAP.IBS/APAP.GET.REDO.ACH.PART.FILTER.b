* @ValidationCode : MjotMjA2NTY5NzU4OTpDcDEyNTI6MTY5ODIzOTI5ODc1ODozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Oct 2023 18:38:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
SUBROUTINE APAP.GET.REDO.ACH.PART.FILTER(ID.LIST)
*-----------------------------------------------------------------------------
* Description :
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ACH.PARTICIPANTS
    $INSERT I_EB.MOB.FRMWRK.COMMON
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
 
*    IF NOT(ID.LIST) THEN
    GOSUB PROCESS
*   END

RETURN

*-----------------------------------------------------------------------------
INITIALISE:

    FN.REDO.ACH.PART = 'F.REDO.ACH.PARTICIPANTS'
    F.REDO.ACH.PART = ''
    CALL OPF(FN.REDO.ACH.PART, F.REDO.ACH.PART)

    IF ID.LIST THEN
        CHANGE ',' TO @FM IN ID.LIST
    END

RETURN

*-----------------------------------------------------------------------------
PROCESS:

    SEL.CMD = 'SELECT ':FN.REDO.ACH.PART
    IF ID.LIST NE "" THEN
        SEL.CMD =SEL.CMD: ' WITH @ID EQ ':ID.LIST
    END
    EXECUTE SEL.CMD CAPTURING SEL.OUT

    READLIST ID.LIST ELSE ID.LIST = ''

RETURN

*-----------------------------------------------------------------------------
END
