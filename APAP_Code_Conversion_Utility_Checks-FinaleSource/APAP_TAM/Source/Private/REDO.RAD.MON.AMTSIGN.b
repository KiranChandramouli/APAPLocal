* @ValidationCode : MjozOTMyMzc4OTk6Q3AxMjUyOjE2ODI1Mjg0NzA1ODc6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Apr 2023 22:31:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.RAD.MON.AMTSIGN
*-----------------------------------------------------------------------------
* Primary Purpose: Returns the sign of an amount given
*                  Used in RAD.CONDUIT.LINEAR as API routine.
* Input Parameters:  Amount
* Output Parameters: Sign: Positive(P) or Negative (N)
*-----------------------------------------------------------------------------
* Modification History:
*
* 13/09/10 - Cesar Yepez
*            New Development
*
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*18-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*18-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    Y.PARAM = COMI
    Y.RETURN = ''

    BEGIN CASE
        CASE Y.PARAM GE 0
            Y.RETURN = 'P'
        CASE Y.PARAM LT 0
            Y.RETURN = 'N'
    END CASE

    COMI = Y.RETURN

RETURN

END
