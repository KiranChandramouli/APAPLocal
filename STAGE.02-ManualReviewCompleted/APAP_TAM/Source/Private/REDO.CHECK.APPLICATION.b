* @ValidationCode : MjoxMTYxNDY5NDcyOkNwMTI1MjoxNjgwNjc5OTM1NjY1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:02:15
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
SUBROUTINE REDO.CHECK.APPLICATION(Y.ITEM.CODE,APPL.NAME,APPL.PATH)
*-----------------------------------------------------------------------------
* Description:
* This routine will be used with the subroutines like REDO.V.INP.SERIES.CHECK, REDO.AUTH.ORDER.RECEPTION etc
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.CHECK.APPLICATION
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 12.04.2010  MARIMUTHU S     ODR-2009-11-0200  INITIAL CREATION

* Date             Who                   Reference      Description
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, FM TO @FM, SM TO @SM, $INCLUDE TO $INSERT
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*------------------------------------------------------------------------------------------
    $INSERT I_EQUATE        ;** R22 Auto conversion - $INCLUDE TO $INSERT
    $INSERT I_COMMON         ;** R22 Auto conversion - $INCLUDE TO $INSERT
    $INSERT I_F.REDO.H.ORDER.DETAILS     ;** R22 Auto conversion - $INCLUDE TO $INSERT
    $INSERT I_F.REDO.H.INVENTORY.PARAMETER
*-----------------------------------------------------------------------------
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PROGRAM.END
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.REDO.H.INVENTORY.PARAMETER = 'F.REDO.H.INVENTORY.PARAMETER'
    F.REDO.H.INVENTORY.PARAMETER = ''
    CALL OPF(FN.REDO.H.INVENTORY.PARAMETER,F.REDO.H.INVENTORY.PARAMETER)
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.ID = 'SYSTEM'

    CALL CACHE.READ(FN.REDO.H.INVENTORY.PARAMETER,Y.ID,R.REC.PARAMETER,Y.ERR)
    Y.PARAM.ITEM = R.REC.PARAMETER<IN.PR.ITEM.CODE>
    Y.PARAM.ITEM = CHANGE(Y.PARAM.ITEM,@VM,@FM)
    Y.PARAM.ITEM = CHANGE(Y.PARAM.ITEM,@SM,@FM)

    LOCATE Y.ITEM.CODE IN Y.PARAM.ITEM SETTING POS THEN
        Y.APPLN = R.REC.PARAMETER<IN.PR.INV.MAINT.TYPE,POS>
        BEGIN CASE
            CASE Y.APPLN EQ 'ADMIN.CHEQUES'
                APPL.NAME = 'F.REDO.H.ADMIN.CHEQUES'
                APPL.PATH = ''

            CASE Y.APPLN EQ 'BANK.DRAFTS'
                APPL.NAME = 'F.REDO.H.BANK.DRAFTS'
                APPL.PATH = ''

            CASE Y.APPLN EQ 'DEBIT.CARDS'
                APPL.NAME = 'F.REDO.H.DEBIT.CARDS'
                APPL.PATH = ''

            CASE Y.APPLN EQ 'DEPOSIT.RECEIPTS'
                APPL.NAME = 'F.REDO.H.DEPOSIT.RECEIPTS'
                APPL.PATH = ''

            CASE Y.APPLN EQ 'PASSBOOKS'
                APPL.NAME = 'F.REDO.H.PASSBOOK.INVENTORY'
                APPL.PATH = ''

            CASE Y.APPLN EQ 'PIGGY.BANK'
                APPL.NAME = 'F.REDO.H.PIGGY.BANKS'
                APPL.PATH = ''
        END CASE
    END

RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------
END
