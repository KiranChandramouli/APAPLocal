* @ValidationCode : MjoxNzExMTUwNDM5OkNwMTI1MjoxNjkzMzc0OTE2OTAyOklUU1M6LTE6LTE6MjkwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 30 Aug 2023 11:25:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 290
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
