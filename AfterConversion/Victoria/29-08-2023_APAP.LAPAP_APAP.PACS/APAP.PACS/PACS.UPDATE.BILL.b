* @ValidationCode : MjoxNzExMTUwNDM5OkNwMTI1MjoxNjkzMzExMjQwNTA3OnZpY3RvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 29 Aug 2023 17:44:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.PACS
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*29-08-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE PACS.UPDATE.BILL

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.BILL.DETAILS

    GOSUB INIT
    GOSUB UPD.BILL
RETURN

INIT:

    FN.BD = 'F.AA.BILL.DETAILS'
    F.BD = ''
    CALL OPF(FN.BD, F.BD)

    BD.ID = "AABILL22207XQFNM"

    R.BD = ""
RETURN

UPD.BILL:
    READ R.BD FROM F.BD, BD.ID THEN
        R.BD<AA.BD.OS.TOTAL.AMOUNT> = 0

    END
    WRITE R.BD TO F.BD,BD.ID
RETURN
