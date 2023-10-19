* @ValidationCode : MjotNzk1NDQ1MzcwOkNwMTI1MjoxNjgwNzc2Nzg5NTg4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:56:29
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
