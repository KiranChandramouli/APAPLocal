* @ValidationCode : MjotNzk1NDQ1MzcwOkNwMTI1MjoxNjg0ODQyMTAwNTYzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.FOREX.SELL.SEQ.NUM.ID
*--------------------------------------------------------------------------------
* Company   Name    : Asociacion Popular de Ahorros y Prestamos
* Developed By      : GANESH.R
* Program   Name    : REDO.FOREX.SELL.SEQ.NUM.ID
*---------------------------------------------------------------------------------
* DESCRIPTION       : This routine is the .ID routine for the local template REDO.FOREX.SEQ.NUM
*                    and is used to set the ID
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*----------------------------------------------------------------------*
*Getting the ID and formattting the ID to 10 characters preceeded by 0's
*----------------------------------------------------------------------*
    TEMP.ID=ID.NEW
    ID.NEW = FMT(TEMP.ID,'R%10')
RETURN
END
