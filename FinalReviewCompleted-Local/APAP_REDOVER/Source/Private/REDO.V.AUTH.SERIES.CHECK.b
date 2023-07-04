* @ValidationCode : MjoxNDE3MDcxNTA5OkNwMTI1MjoxNjgyNDEyMzQwMTkwOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUTH.SERIES.CHECK
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
*Modification history
*Date                Who               Reference                  Description
*13-04-2023      conversion tool     R22 Auto code conversion     No changes
*13-04-2023      Mohanraj R          R22 Manual code conversion   No changes
* ------------------------------------------------------------------------
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

        R.NEW(RE.ORD.ORDER.STATUS) = "Orden Rechazada"

    END

    IF (Y.REJ.ORDER EQ 'NO' OR Y.REJ.ORDER EQ '') THEN

        R.NEW(RE.ORD.ORDER.STATUS) = "Orden Despachada"

    END

RETURN
END
