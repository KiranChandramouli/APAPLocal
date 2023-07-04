* @ValidationCode : MjotMTI5NDUwOTM4NTpDcDEyNTI6MTY4MTkwNTY4MDM5OTpJVFNTOi0xOi0xOjE4MjoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 182
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.PORTFOLIO(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Pradeep S
* PROGRAM NAME: REDO.DS.PORTFOLIO
* PACS REF    : PACS00051213
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the PORTFOLIO used

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES

*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.ACC.MASTER

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.SAM = 'F.SEC.ACC.MASTER'
    F.SAM = ''

RETURN

OPENFILES:
**********
    CALL OPF(FN.SAM,F.SAM)
RETURN

PROCESS:
********

    SAM.ID = Y.RET


    CALL F.READ(FN.SAM,SAM.ID,R.SAM,F.SAM,SAM.ERR)
    Y.PORTFOLIO.NAME = R.SAM<SC.SAM.ACCOUNT.NAME>

    Y.RET = Y.PORTFOLIO.NAME

RETURN

END
