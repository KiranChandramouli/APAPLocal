* @ValidationCode : MjoxNzE2MzkxMjY1OkNwMTI1MjoxNjgyNDEyMzI3NzY2OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:27
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
SUBROUTINE REDO.AUTH.CHECK.LIMIT

***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RIYAS
* PROGRAM NAME: REDO.AUTH.CHECK.LIMIT
* ODR NO      : ODR-2010-09-0148
*-----------------------------------------------------------------------------
*DESCRIPTION: This is AUTH routine for REDO.CLEARING.INWARD,APPROVE to clear reason

*IN PARAMETER :  NA
*OUT PARAMETER: NA
*LINKED WITH  : REDO.CLEARING.INWARD,APPROVE
*----------------------------------------------------------------------
* Modification History :
* DATE             WHO                   REFERENCE                   DESCRIPTION
* 27-04-2012       RIYAS                PACS00131732                 sub process
*05-04-2023       Conversion Tool        R22 Auto Code conversion      No Changes
*05-04-2023       Samaran T              Manual R22 Code Conversion    No Changes
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.CLEARING.INWARD
    IF V$FUNCTION EQ 'A' THEN
        GOSUB PROCESS
    END
RETURN
*----------------------------------------------------------------------
********
PROCESS:
********

    Y.STATUS.PAID = R.NEW(CLEAR.CHQ.STATUS)
    IF Y.STATUS.PAID EQ 'PAID' THEN
        R.NEW(CLEAR.CHQ.REASON) = ''
    END

RETURN
END
