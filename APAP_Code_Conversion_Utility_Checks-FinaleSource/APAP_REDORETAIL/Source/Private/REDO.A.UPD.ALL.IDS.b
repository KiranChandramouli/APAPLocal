* @ValidationCode : MjozMzQ1MDYzMTY6Q3AxMjUyOjE2ODEyNzY1NTQ3MDM6SVRTUzotMTotMTo1NjM6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:45:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 563
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.A.UPD.ALL.IDS
*---------------------------------------------------------------------------------------------
*
* Description           : Auth routine to update live table REDO.L.ALL.FT.TT.FX.IDS

* Developed By          : Thenmalar T
*
* Development Reference : TC01
*
* Attached To           : Version control - FT/TT/FX
*
* Attached As           : Auth routine
*---------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*---------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*---------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.FOREX
    $INSERT I_F.REDO.L.ALL.FT.TT.FX.IDS
*

    GOSUB INIT
    GOSUB PROCESS
*
RETURN
*---------------------------------------------------------------------------------------------
INIT:
*----

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FOREX = 'F.FOREX'
    F.FOREX = ''
    CALL OPF(FN.FOREX,F.FOREX)

    FN.REDO.L.ALL.FT.TT.FX.IDS = 'F.REDO.L.ALL.FT.TT.FX.IDS'
    F.REDO.L.ALL.FT.TT.FX.IDS = ''
    CALL OPF(FN.REDO.L.ALL.FT.TT.FX.IDS,F.REDO.L.ALL.FT.TT.FX.IDS)

    Y.FT.TXN.TYPE = '' ; Y.TT.TXN.TYPE = '' ; Y.DEAL.TYPE = ''
    Y.DATE = '' ; Y.CCY.SOLD = '' ; Y.CCY.BOUGHT = ''
    Y.RECORD.STATUS = ''
RETURN
*--------------------------------------------------------------------------------------------
PROCESS:
*------

    Y.APPLICATION = APPLICATION
    Y.REDO.L.ALL.FT.TT.FX.IDS = ID.NEW

    BEGIN CASE
        CASE Y.APPLICATION EQ 'FUNDS.TRANSFER'
            GOSUB FT.PROCESS
        CASE Y.APPLICATION EQ 'TELLER'
            GOSUB TT.PROCESS
        CASE Y.APPLICATION EQ 'FOREX'
            GOSUB FX.PROCESS
    END CASE

    IF V$FUNCTION EQ 'R' OR Y.RECORD.STATUS EQ "REV" THEN
        CALL F.DELETE(FN.REDO.L.ALL.FT.TT.FX.IDS,Y.REDO.L.ALL.FT.TT.FX.IDS)
    END ELSE
        R.REDO.L.ALL.FT.TT.FX.IDS = ''
        Y.REDO.L.ALL.FT.TT.FX.IDS.ID = ID.NEW
        R.REDO.L.ALL.FT.TT.FX.IDS<ALL.IDS.DATE> = Y.DATE
        R.REDO.L.ALL.FT.TT.FX.IDS<ALL.IDS.FT.TXN.TYPE> = Y.FT.TXN.TYPE
        R.REDO.L.ALL.FT.TT.FX.IDS<ALL.IDS.TT.TXN.TYPE> = Y.TT.TXN.TYPE
        R.REDO.L.ALL.FT.TT.FX.IDS<ALL.IDS.FX.DEAL.TYPE> = Y.DEAL.TYPE
        R.REDO.L.ALL.FT.TT.FX.IDS<ALL.IDS.FX.CCY.SOLD> = Y.CCY.SOLD
        R.REDO.L.ALL.FT.TT.FX.IDS<ALL.IDS.FX.CCY.BUY> = Y.CCY.BOUGHT

        IF R.REDO.L.ALL.FT.TT.FX.IDS NE '' THEN
            CALL F.WRITE(FN.REDO.L.ALL.FT.TT.FX.IDS,Y.REDO.L.ALL.FT.TT.FX.IDS.ID,R.REDO.L.ALL.FT.TT.FX.IDS)
        END
    END


RETURN
*--------------------------------------------------------------------------------------------
FT.PROCESS:
*----------

    Y.DATE = R.NEW(FT.PROCESSING.DATE)
    Y.FT.TXN.TYPE = R.NEW(FT.TRANSACTION.TYPE)
    Y.RECORD.STATUS = R.NEW(FT.RECORD.STATUS)

RETURN
*------------------------------------------------------------------------------------------
TT.PROCESS:
*----------
    Y.DATE = R.NEW(TT.TE.AUTH.DATE)
    Y.TT.TXN.TYPE = R.NEW(TT.TE.TRANSACTION.CODE)
    Y.RECORD.STATUS = R.NEW(TT.TE.RECORD.STATUS)

RETURN
*------------------------------------------------------------------------------------------
FX.PROCESS:
*----------
    Y.DATE = R.NEW(FX.DEAL.DATE)
    Y.DEAL.TYPE = R.NEW(FX.DEAL.TYPE)
    Y.CCY.BOUGHT = R.NEW(FX.CURRENCY.BOUGHT)
    Y.CCY.SOLD = R.NEW(FX.CURRENCY.SOLD)
    Y.RECORD.STATUS = R.NEW(FX.RECORD.STATUS)

RETURN
*------------------------------------------------------------------------------------------
END
