* @ValidationCode : MjotNTA1NjU5MzY4OkNwMTI1MjoxNjgxMTIwODMxNDAyOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 15:30:31
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
SUBROUTINE REDO.V.AUTH.REJECT.CHECK
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.ORDER.DETAILS
*----------------------------------------------------------------------------
* Description:
* This routine will be attached to the version REDO.ORDER.DETAIL,ITEM.REQUEST as
* a auth routine
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.V.AUTH.SERIES.CHECK
*-------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE             DESCRIPTION
* 12.04.2010  MARIMUTHU S     FIX FOR ISSUE HD1053868  INITIAL CREATION
* ------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*10-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*10-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
 
*----------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------------------
    Y.REJ.ORDER = ''
    Y.REJ.ORDER = R.NEW(RE.ORD.REJECTED.ORDER)

RETURN
*-----------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------

    IF Y.REJ.ORDER EQ 'YES' THEN

        R.NEW(RE.ORD.ORDER.STATUS) = "Request Rejected"

    END

    IF (Y.REJ.ORDER EQ 'NO' OR Y.REJ.ORDER EQ '') THEN

        R.NEW(RE.ORD.ORDER.STATUS) = "Delivered Order"

    END

RETURN
END
