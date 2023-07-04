* @ValidationCode : MjoxOTAwNzE2Mjc4OkNwMTI1MjoxNjgyNDEyMzUwOTAzOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:50
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
SUBROUTINE REDO.V.INP.DUM.ROU
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is used as input routine to make chage to the field COMMENTS.
*-------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who                     Reference                    Description
* 26-09-2011        S.MARIMUTHU               PACS00128531                 Initial Creation
*11-04-2023          Conversion Tool        R22 Auto Code conversion          No Changes
*11-04-2023           Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AA.DISBURSE.METHOD

MAIN:

    Y.COMMENTS = R.NEW(DIS.MET.COMMENTS)
    IF Y.COMMENTS EQ '' THEN
        R.NEW(DIS.MET.COMMENTS) = 'PRINT'
    END ELSE
        R.NEW(DIS.MET.COMMENTS) = ''
    END

RETURN

END
