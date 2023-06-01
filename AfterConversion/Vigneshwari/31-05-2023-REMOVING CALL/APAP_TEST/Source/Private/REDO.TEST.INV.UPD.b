* @ValidationCode : Mjo2NjIzOTk2OTU6Q3AxMjUyOjE2ODU1MzQzNTE4NjU6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 17:29:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TEST
PROGRAM REDO.TEST.INV.UPD
*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.TEST.INV.UPD
* MODIFICATION HISTORY
*-------------------------------
*-----------------------------------------------------------------------------------
*    NAME                 DATE                ODR              DESCRIPTION
* JEEVA T              27-02-2012           TEST ROUTINE      Routine is for updating the old records in the local template REDO.ITEM.SERIES.
** Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*19-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*19-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION        CALL method format changed
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.H.PASSBOOK.INVENTORY
    $INSERT I_F.REDO.H.ADMIN.CHEQUES
    $INSERT I_F.REDO.H.BANK.DRAFTS
    $INSERT I_F.REDO.H.DEPOSIT.RECEIPTS
    $INSERT I_F.REDO.ITEM.STOCK
    $INSERT I_F.REDO.H.PIGGY.BANKS
    $INSERT I_F.REDO.ITEM.STOCK.BY.DATE
    $USING APAP.TAM


    FN.REDO.ITEM.SERIES = 'F.REDO.ITEM.SERIES'
    F.REDO.ITEM.SERIES = ''
    CALL OPF(FN.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES)


    FN.REDO.ITEM.STOCK.BY.DATE = 'F.REDO.ITEM.STOCK.BY.DATE'
    F.REDO.ITEM.STOCK.BY.DATE  = ''
    CALL OPF(FN.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE)

    R.REDO.ITEM.STOCK.BY.DATE = ''
    R.REDO.ITEM.SERIES = ''
    R.REC = ''
    SEL.CMD = 'SELECT ':FN.REDO.ITEM.STOCK.BY.DATE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOF,Y.ERR)

    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS
    WHILE Y.ID:POS
        Y.INV.MNT.ID = ''
        Y.BRANCH = ''
        Y.INV.MNT.ID = FIELD(Y.ID,".",2)
        Y.BRANCH     = FIELD(Y.ID,".",1)
        Y.BRANCH     = FIELD(Y.BRANCH,"-",1)
        Y.DEPT = ''
        Y.DEPT = FIELD(Y.ID,'-',2)
        Y.DEPT = FIELD(Y.DEPT,'.',1)
        R.REDO.ITEM.SERIES = ''
        IF Y.INV.MNT.ID THEN
            Y.ITEM.VALUE = Y.INV.MNT.ID
            CALL F.READ(FN.REDO.ITEM.STOCK.BY.DATE,Y.ID,R.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE,Y.ERR)
            IF R.REDO.ITEM.STOCK.BY.DATE THEN
                APPL.NAME = ''
                APPL.PATH = ''
                APAP.TAM.redoCheckApplication(Y.INV.MNT.ID,APPL.NAME,APPL.PATH);* R22 Manual conversion - CALL method format changed
                DUP.APPL.NAME = ''
                DUP.APPL.PATH = ''
                DUP.APPL.NAME = APPL.NAME
                DUP.APPL.PATH = APPL.PATH
                IF DUP.APPL.NAME THEN
                    CALL OPF(APPL.NAME,APPL.PATH)
                    GOSUB CASE.FILE.VAL
                    CALL F.WRITE (FN.REDO.ITEM.SERIES,Y.ID,R.REDO.ITEM.SERIES)
                END
            END
        END
    REPEAT
    CALL JOURNAL.UPDATE('')
RETURN
*-------------------------------------------------------------------------
CASE.FILE.VAL:
*-------------------------------------------------------------------------
    Y.DATE.LIST = ''
    Y.DATE.LIST = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE>
    CHANGE @VM TO @FM IN Y.DATE.LIST
    IF Y.DEPT THEN
        SEL.CMD.1 = 'SELECT ':APPL.NAME:' WITH ITEM.CODE EQ ':Y.ITEM.VALUE: ' AND STATUS EQ AVAILABLE ': ' AND WITH BRANCH.DEPT EQ ':Y.BRANCH:" AND WITH CODE EQ ":Y.DEPT:" BY SERIAL.NO "
    END ELSE
        SEL.CMD.1 = 'SELECT ':APPL.NAME:' WITH ITEM.CODE EQ ':Y.ITEM.VALUE: ' AND STATUS EQ AVAILABLE ': ' AND WITH BRANCH.DEPT EQ ':Y.BRANCH:" BY SERIAL.NO "
    END
    CALL EB.READLIST(SEL.CMD.1,SEL.LIST.1,'',NO.OF.RECS,DEP.ERR)
    LOOP
        REMOVE Y.INV.ID FROM SEL.LIST.1 SETTING POS.INV
    WHILE Y.INV.ID:POS.INV
        CALL F.READ(APPL.NAME,Y.INV.ID,R.REC,APPL.PATH,Y.ERR.INV)
        BEGIN CASE
            CASE DUP.APPL.NAME EQ 'F.REDO.H.PASSBOOK.INVENTORY'
                GOSUB REC.PASSBOOK
            CASE DUP.APPL.NAME EQ 'F.REDO.H.BANK.DRAFTS'
                GOSUB REC.BANK
            CASE DUP.APPL.NAME EQ 'F.REDO.H.ADMIN.CHEQUES'
                GOSUB REC.ADMIN
            CASE DUP.APPL.NAME EQ 'F.REDO.H.DEPOSIT.RECEIPTS'
                GOSUB REC.DEPOSITS
        END CASE
    REPEAT

RETURN
*-------------------------------------------------------------------------
REC.PASSBOOK:
*-------------------------------------------------------------------------
    Y.DATE = R.REC<REDO.PASS.DATE.UPDATED>
    LOCATE Y.DATE IN Y.DATE.LIST SETTING POS.DATE THEN
        R.REDO.ITEM.SERIES<-1> = R.REC<REDO.PASS.SERIAL.NO>:"*AVAILABLE*":Y.INV.ID:"*":Y.DATE
    END
RETURN

*-------------------------------------------------------------------------
REC.BANK:
*-------------------------------
    Y.DATE = R.REC<REDO.BANK.DATE.UPDATED>
    LOCATE Y.DATE IN Y.DATE.LIST SETTING POS.DATE THEN
        R.REDO.ITEM.SERIES<-1> = R.REC<REDO.BANK.SERIAL.NO>:"*AVAILABLE*":Y.INV.ID:"*":Y.DATE
    END
RETURN
*-------------------------------
REC.ADMIN:
*-------------------------------
    Y.DATE = R.REC<REDO.ADMIN.DATE.UPDATED>
    LOCATE Y.DATE IN Y.DATE.LIST SETTING POS.DATE THEN
        R.REDO.ITEM.SERIES<-1> = R.REC<REDO.ADMIN.SERIAL.NO>:"*AVAILABLE*":Y.INV.ID:"*":Y.DATE
    END
RETURN
*-------------------------------
REC.DEPOSITS:
*-------------------------------
    Y.DATE = R.REC<REDO.DEP.DATE.UPDATED>
    LOCATE Y.DATE IN Y.DATE.LIST SETTING POS.DATE THEN
        R.REDO.ITEM.SERIES<-1> = R.REC<REDO.DEP.SERIAL.NO>:"*AVAILABLE*":Y.INV.ID:"*":Y.DATE
    END
RETURN
END
