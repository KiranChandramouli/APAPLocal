* @ValidationCode : MjotNzc3NDU3Mjg4OkNwMTI1MjoxNjg1NTM1OTk5NjEzOnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 17:56:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.ORDER.RECEPTION
*----------------------------------------------------------------------------
* Description:
* This routine will be attached to the version REDO.ORDER.DETAIL,ORDER.DELEVIRY as
* a auth routine
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.AUTH.ORDER.RECEPTION
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE                    DESCRIPTION
* 12.04.2010  MARIMUTHU S         ODR-2009-11-0200              INITIAL CREATION
*05-04-2023  Conversion Tool      R22 Auto Code conversion      FM TO @FM, VM TO @VM, Y.CNT.FM + 1 TO +=1 , T.NO TO C$T24.SESSION.NO
*05-04-2023   Samaran T           Manual R22 Code Conversion    No Changes
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.ORDER.DETAILS
    $INSERT I_F.REDO.H.PASSBOOK.INVENTORY
    $INSERT I_F.REDO.H.ADMIN.CHEQUES
    $INSERT I_F.REDO.H.BANK.DRAFTS
    $INSERT I_F.REDO.H.DEPOSIT.RECEIPTS
    $INSERT I_F.REDO.ITEM.STOCK
    $INSERT I_F.REDO.H.PIGGY.BANKS
    $INSERT I_F.REDO.ITEM.STOCK.BY.DATE
    $USING APAP.TAM
*-----------------------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------------------

    GOSUB INIT
    GOSUB OPENFILES

    GOSUB PROCESS
    IF NOT(Y.PIGGY.FLAG) THEN
        GOSUB UPDATE.PASSBOOK.INVENTORY
    END
    GOSUB PROGRAM.END
RETURN
*-----------------------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------------------
    Y.BAL = ''
    FN.REDO.ITEM.STOCK = 'F.REDO.ITEM.STOCK'
    F.REDO.ITEM.STOCK = ''
    FN.REDO.ITEM.STOCK.BY.DATE = 'F.REDO.ITEM.STOCK.BY.DATE'
    F.REDO.ITEM.STOCK.BY.DATE = ''
    R.REDO.ITEM.STOCK.BY.DATE = ''
RETURN
*-----------------------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------------------

    IF R.NEW(RE.ORD.BRANCH.CODE) THEN
        Y.ITEM.STOCK.ID = ID.COMPANY:'-':R.NEW(RE.ORD.BRANCH.CODE)
    END ELSE
        Y.ITEM.STOCK.ID = ID.COMPANY
    END

    IF R.NEW(RE.ORD.BRANCH.CODE) THEN
        Y.ITEM.STOCK.RPT.ID = ID.COMPANY:'-':R.NEW(RE.ORD.BRANCH.CODE):".":R.NEW(RE.ORD.ITEM.CODE)
    END ELSE
        Y.ITEM.STOCK.RPT.ID = ID.COMPANY:".":R.NEW(RE.ORD.ITEM.CODE)
    END

    R.REDO.ITEM.STOCK = ''
    FN.REDO.H.ORDER.DETAILS = 'F.REDO.H.ORDER.DETAILS'
    F.REDO.H.ORDER.DETAILS =''
    FN.REDO.H.PIGGY.BANKS = 'F.REDO.H.PIGGY.BANKS'
    F.REDO.H.PIGGY.BANKS = ''
    CALL OPF(FN.REDO.H.PIGGY.BANKS,F.REDO.H.PIGGY.BANKS)
    CALL OPF(FN.REDO.H.ORDER.DETAILS,F.REDO.H.ORDER.DETAILS)
    CALL OPF(FN.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK)
    CALL OPF(FN.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE)
    CALL F.READ(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK,Y.ITME.ERR)
    CALL F.READ(FN.REDO.ITEM.STOCK.BY.DATE,Y.ITEM.STOCK.RPT.ID,R.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE,Y.ERR.DATE)
RETURN
*-----------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------
    Y.INV.MNT.ID = R.NEW(RE.ORD.ITEM.CODE)
    Y.SEQ.FROM = R.NEW(RE.ORD.SERIES.FROM)
    Y.SEQ.TO = R.NEW(RE.ORD.SERIES.TO)
    Y.DELIVER.QUANTITY = R.NEW(RE.ORD.DELEVIRY.QUANTITY)
    Y.REQ.COMP = R.NEW(RE.ORD.REQUEST.COMPANY)
    Y.DESC = R.NEW(RE.ORD.DESCRIPTION)
    Y.REJ.ORDER = R.NEW(RE.ORD.REJECTED.ORDER)
    Y.PIGGY.FLAG = ''

    APAP.TAM.redoCheckApplication(Y.INV.MNT.ID,APPL.NAME,APPL.PATH) ;*R22 MANUAL CODE CONVERSION
    DUP.APPL.NAME = APPL.NAME
    CALL OPF(APPL.NAME,APPL.PATH)

    IF DUP.APPL.NAME EQ 'F.REDO.H.PIGGY.BANKS' THEN
        Y.REQ.QNTY = R.NEW(RE.ORD.DELEVIRY.QUANTITY)
        Y.DELIVER.QUANTITY = Y.REQ.QNTY
        GOSUB REC.PIGGY
        GOSUB UPD.ITEM.STOCK
        GOSUB UPD.ITEM.STOCK.RPT
        Y.PIGGY.FLAG = '1'
    END
RETURN
*-------------------------------------------------------------------------------------------


*-----------------------------------------------------------------------------------------
UPDATE.PASSBOOK.INVENTORY:
*------------------------------------------------------------------------------------------

    IF (Y.REJ.ORDER EQ 'NO' OR Y.REJ.ORDER EQ '') THEN
        R.REC = ''
        CHANGE @VM TO @FM IN Y.SEQ.FROM
        CHANGE @VM TO @FM IN Y.SEQ.TO
        Y.DCOUNT.FM = DCOUNT(Y.SEQ.FROM,@FM)
        Y.CNT.FM = 1

        LOOP
        WHILE Y.CNT.FM LE Y.DCOUNT.FM

            Y.FRM = Y.SEQ.FROM<Y.CNT.FM>
            Y.LENGTH = LEN(Y.FRM)
            Y.FMT.VAL = "R%":Y.LENGTH

            Y.FRM = FMT(Y.FRM,Y.FMT.VAL)
            LOOP

            WHILE Y.FRM LE Y.SEQ.TO<Y.CNT.FM>
                IF Y.FRM LT Y.SEQ.TO<Y.CNT.FM> THEN
                    GOSUB CASE.UPT.VAL
                    GOSUB OFS.FOR.PASSBOOK.INVENTORY
                    Y.FRM += 1
                    Y.LENGTH = LEN(Y.SEQ.FROM<Y.CNT.FM>)
                    Y.FMT.VAL = "R%":Y.LENGTH

                    Y.FRM.LEN = LEN(Y.FRM)
                    IF Y.FRM.LEN GT Y.LENGTH THEN
                        Y.FMT.VAL = "R%":Y.FRM.LEN
                    END
                    Y.FRM = FMT(Y.FRM,Y.FMT.VAL)
                    CONTINUE
                END
                IF Y.FRM EQ Y.SEQ.TO<Y.CNT.FM> THEN
                    Y.FRM = Y.SEQ.TO<Y.CNT.FM>
                    GOSUB CASE.UPT.VAL
                    GOSUB OFS.FOR.PASSBOOK.INVENTORY
                    Y.FRM += 1
                    Y.LENGTH = LEN(Y.SEQ.TO<Y.CNT.FM>)
                    Y.FMT.VAL = "R%":Y.LENGTH

                    Y.FRM.LEN = LEN(Y.FRM)
                    IF Y.FRM.LEN GT Y.LENGTH THEN
                        Y.FMT.VAL = "R%":Y.FRM.LEN
                    END
                    Y.FRM = FMT(Y.FRM,Y.FMT.VAL)
                    CONTINUE
                END
            REPEAT
            Y.CNT.FM += 1  ;*R22 AUTO CODE CONVERSION
        REPEAT

        CALL OFS.POST.MESSAGE(OFSSTRING.LIST,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
        GOSUB UPD.ITEM.STOCK
        GOSUB UPD.ITEM.STOCK.RPT
    END

    IF Y.REJ.ORDER EQ 'YES' THEN
        R.NEW(RE.ORD.ORDER.STATUS) = "Solicitud Rechazada"
        IF PGM.VERSION EQ ',ORDER.REJECT' THEN
            R.NEW(RE.ORD.ORDER.STATUS) = "Orden Rechazada"
        END
    END


RETURN
*-------------------------------
CASE.UPT.VAL:
*-------------------------------
    BEGIN CASE
        CASE DUP.APPL.NAME EQ 'F.REDO.H.PASSBOOK.INVENTORY'
            GOSUB REC.PASSBOOK
            APP.NAME = 'REDO.H.PASSBOOK.INVENTORY'
        CASE DUP.APPL.NAME EQ 'F.REDO.H.BANK.DRAFTS'
            GOSUB REC.BANK
            APP.NAME = 'REDO.H.BANK.DRAFTS'
        CASE DUP.APPL.NAME EQ 'F.REDO.H.ADMIN.CHEQUES'
            GOSUB REC.ADMIN
            APP.NAME = 'REDO.H.ADMIN.CHEQUES'
        CASE DUP.APPL.NAME EQ 'F.REDO.H.DEPOSIT.RECEIPTS'
            GOSUB REC.DEPOSITS
            APP.NAME = 'REDO.H.DEPOSIT.RECEIPTS'
        CASE DUP.APPL.NAME EQ 'F.REDO.H.DEPOSIT.RECEIPTS'
            GOSUB REC.DEPOSITS
            APP.NAME = 'REDO.H.DEPOSIT.RECEIPTS'
    END CASE
RETURN
*-------------------------------
REC.PIGGY:
*-------------------------------

    Y.UPD.FLAG = ''
    Y.SYSTEM = 'SYSTEM'
    Y.DES.DEPT = R.NEW(RE.ORD.BRANCH.CODE)
    IF Y.DES.DEPT THEN
        Y.BRANCH = ID.COMPANY:"-":Y.DES.DEPT
    END ELSE
        Y.BRANCH = ID.COMPANY
    END
    CALL CACHE.READ(FN.REDO.H.PIGGY.BANKS,Y.SYSTEM,R.REDO.H.PIGGY.BANKS,Y.ERRR)
    IF R.REDO.H.PIGGY.BANKS THEN
        Y.BRANCH = R.REDO.H.PIGGY.BANKS<REDO.PIG.BRANCH.DEPT>
        Y.COUNT.BRAN = DCOUNT(Y.BRANCH,@VM)
        Y.CNT.BR = 1
        LOOP
        WHILE Y.CNT.BR LE Y.COUNT.BRAN
            IF ID.COMPANY EQ R.REDO.H.PIGGY.BANKS<REDO.PIG.BRANCH.DEPT,Y.CNT.BR> THEN
                Y.CODE.VAL.1 = R.REDO.H.PIGGY.BANKS<REDO.PIG.BRANCH.DEPT,Y.CNT.BR>
                IF Y.DES.DEPT AND Y.DES.DEPT EQ R.REDO.H.PIGGY.BANKS<REDO.PIG.DEPT,Y.CNT.BR> THEN
                    R.REDO.H.PIGGY.BANKS<REDO.PIG.NO.AVBL,Y.CNT.BR> = R.REDO.H.PIGGY.BANKS<REDO.PIG.NO.AVBL,Y.CNT.BR> + Y.REQ.QNTY
                    Y.UPD.FLAG = '1'
                END
            END
            Y.CNT.BR += 1
        REPEAT
        IF NOT(Y.UPD.FLAG) THEN
            R.REDO.H.PIGGY.BANKS<REDO.PIG.BRANCH.DEPT> := @VM:ID.COMPANY
            R.REDO.H.PIGGY.BANKS<REDO.PIG.ITEM.CODE> := @VM:Y.INV.MNT.ID
            R.REDO.H.PIGGY.BANKS<REDO.PIG.NO.AVBL> := @VM:Y.DELIVER.QUANTITY
            R.REDO.H.PIGGY.BANKS<REDO.PIG.DEPT> := @VM:Y.DES.DEPT
        END
    END ELSE

        R.REDO.H.PIGGY.BANKS<REDO.PIG.BRANCH.DEPT> = ID.COMPANY
        R.REDO.H.PIGGY.BANKS<REDO.PIG.ITEM.CODE> = Y.INV.MNT.ID
        R.REDO.H.PIGGY.BANKS<REDO.PIG.NO.AVBL> = Y.DELIVER.QUANTITY
        R.REDO.H.PIGGY.BANKS<REDO.PIG.DEPT> := Y.DES.DEPT
    END


    CURR.NO.VALUE = R.REDO.H.PIGGY.BANKS<REDO.PIG.CURR.NO>
    R.REDO.H.PIGGY.BANKS<REDO.PIG.CURR.NO> = CURR.NO.VALUE + 1
    INPUTTER = C$T24.SESSION.NO:'_':OPERATOR   ;*R22 AUTO CODE CONVERSION
    AUTHORISER = C$T24.SESSION.NO:'_':OPERATOR   ;*R22 AUTO CODE CONVERSION
    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME = TEMPTIME[1,5]
    CHANGE ':' TO '' IN TEMPTIME
    CHECK.DATE = DATE()
    DATE.TIME = OCONV(CHECK.DATE,"DY2"):OCONV(CHECK.DATE,"DM"):OCONV(CHECK.DATE,"DD"):TEMPTIME
    R.REDO.H.PIGGY.BANKS<REDO.PIG.INPUTTER> = INPUTTER
    R.REDO.H.PIGGY.BANKS<REDO.PIG.DATE.TIME> = DATE.TIME
    R.REDO.H.PIGGY.BANKS<REDO.PIG.AUTHORISER> = AUTHORISER

    CALL F.WRITE(FN.REDO.H.PIGGY.BANKS,Y.SYSTEM,R.REDO.H.PIGGY.BANKS)

RETURN
*-------------------------------
UPD.ITEM.STOCK:
*-------------------------------
    IF R.REDO.ITEM.STOCK THEN
        LOCATE Y.INV.MNT.ID IN R.REDO.ITEM.STOCK<ITEM.REG.ITEM.CODE,1> SETTING POS THEN
            Y.BAL = R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS>
            R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> = Y.BAL + Y.DELIVER.QUANTITY
        END ELSE
            R.REDO.ITEM.STOCK<ITEM.REG.ITEM.CODE> := @VM:Y.INV.MNT.ID
            R.REDO.ITEM.STOCK<ITEM.REG.DESC> := @VM:Y.DESC
            R.REDO.ITEM.STOCK<ITEM.REG.BAL> := @VM:Y.DELIVER.QUANTITY
        END
    END ELSE

        R.REDO.ITEM.STOCK<ITEM.REG.ITEM.CODE> = Y.INV.MNT.ID
        R.REDO.ITEM.STOCK<ITEM.REG.DESC> = Y.DESC
        R.REDO.ITEM.STOCK<ITEM.REG.BAL> = Y.DELIVER.QUANTITY
    END

    CALL F.WRITE(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK)
RETURN

*-------------------------------
UPD.ITEM.STOCK.RPT:
*-------------------------------

    Y.DATE.RPT = R.NEW(RE.ORD.RECEIPT.DATE)
    IF R.REDO.ITEM.STOCK.BY.DATE THEN
        LOCATE Y.DATE.RPT IN R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,1> SETTING POS.RPT THEN

            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,POS.RPT>                =   Y.DATE.RPT
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ITEM.CODE,POS.RPT>           =   R.NEW(RE.ORD.ITEM.CODE)
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.INITIAL.STOCK,POS.RPT>       =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT>
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.RECEIVED,POS.RPT>            =   R.NEW(RE.ORD.DELEVIRY.QUANTITY)
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT>           =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT> + R.NEW(RE.ORD.DELEVIRY.QUANTITY)

        END ELSE
            Y.DATE.COUNT1 = DCOUNT(R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE>,@VM)
            Y.DATE.COUNT = Y.DATE.COUNT1 + 1
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,Y.DATE.COUNT>                =   Y.DATE.RPT
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ITEM.CODE,Y.DATE.COUNT>           =   R.NEW(RE.ORD.ITEM.CODE)
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.INITIAL.STOCK,Y.DATE.COUNT>       =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT1>
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.RECEIVED,Y.DATE.COUNT>            =   R.NEW(RE.ORD.DELEVIRY.QUANTITY)
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT>           =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT1> + R.NEW(RE.ORD.DELEVIRY.QUANTITY)

        END
    END ELSE

        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE>           =   Y.DATE.RPT
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ITEM.CODE>      =   R.NEW(RE.ORD.ITEM.CODE)
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.INITIAL.STOCK>  =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE>
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.RECEIVED>       =   R.NEW(RE.ORD.DELEVIRY.QUANTITY)
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE>      =   R.NEW(RE.ORD.DELEVIRY.QUANTITY)

    END

    CALL F.WRITE(FN.REDO.ITEM.STOCK.BY.DATE,Y.ITEM.STOCK.RPT.ID,R.REDO.ITEM.STOCK.BY.DATE)
RETURN

*-------------------------------
REC.PASSBOOK:
*-------------------------------
    R.REC<REDO.PASS.BRANCH.DEPT> = ID.COMPANY
    R.REC<REDO.PASS.ITEM.CODE> = Y.INV.MNT.ID
    R.REC<REDO.PASS.DESCRIPTION> = Y.DESC
    R.REC<REDO.PASS.SERIAL.NO> = Y.FRM
    R.REC<REDO.PASS.STATUS> = 'AVAILABLE'
    R.REC<REDO.PASS.DATE.UPDATED> = TODAY
    R.REC<REDO.PASS.USER> = OPERATOR
    IF R.NEW(RE.ORD.BRANCH.CODE) THEN
        R.REC<REDO.PASS.CODE> = R.NEW(RE.ORD.BRANCH.CODE)
    END


RETURN
*-------------------------------
REC.BANK:
*-------------------------------
    R.REC<REDO.BANK.BRANCH.DEPT> = ID.COMPANY
    R.REC<REDO.BANK.ITEM.CODE> = Y.INV.MNT.ID
    R.REC<REDO.BANK.DESCRIPTION> = Y.DESC
    R.REC<REDO.BANK.SERIAL.NO> = Y.FRM
    R.REC<REDO.BANK.STATUS> = 'AVAILABLE'
    R.REC<REDO.BANK.DATE.UPDATED> = TODAY
    R.REC<REDO.BANK.USER> = OPERATOR

    IF R.NEW(RE.ORD.BRANCH.CODE) THEN
        R.REC<REDO.BANK.CODE> = R.NEW(RE.ORD.BRANCH.CODE)
    END
RETURN
*-------------------------------
REC.ADMIN:
*-------------------------------
    R.REC<REDO.ADMIN.BRANCH.DEPT> = ID.COMPANY
    R.REC<REDO.ADMIN.ITEM.CODE> = Y.INV.MNT.ID
    R.REC<REDO.ADMIN.DESCRIPTION> = Y.DESC
    R.REC<REDO.ADMIN.SERIAL.NO> = Y.FRM
    R.REC<REDO.ADMIN.STATUS> = 'AVAILABLE'
    R.REC<REDO.ADMIN.DATE.UPDATED> = TODAY
    R.REC<REDO.ADMIN.USER> = OPERATOR

    IF R.NEW(RE.ORD.BRANCH.CODE) THEN
        R.REC<REDO.ADMIN.CODE> = R.NEW(RE.ORD.BRANCH.CODE)
    END

RETURN
*-------------------------------
REC.DEPOSITS:
*-------------------------------
    R.REC<REDO.DEP.BRANCH.DEPT> = ID.COMPANY
    R.REC<REDO.DEP.ITEM.CODE> = Y.INV.MNT.ID
    R.REC<REDO.DEP.DESCRIPTION> = Y.DESC
    R.REC<REDO.DEP.SERIAL.NO> = Y.FRM
    R.REC<REDO.DEP.STATUS> = 'AVAILABLE'
    R.REC<REDO.DEP.DATE.UPDATED> = TODAY
    R.REC<REDO.DEP.USER> = OPERATOR

    IF R.NEW(RE.ORD.BRANCH.CODE) THEN
        R.REC<REDO.DEP.CODE> = R.NEW(RE.ORD.BRANCH.CODE)
    END

RETURN

*-------------------------------------------------------------------------------------------
OFS.FOR.PASSBOOK.INVENTORY:
*--------------------------------------------------------------------------------------------

    OFSFUNCTION = 'I'
    PROCESS = 'PROCESS'
    OFS.SOURCE.ID = 'UPDATE.PASSBOOK'
    OFSVERSION = APP.NAME:','
    GTS.MODE = ''
    NO.OF.AUTH = '0'
*    TRANSACTION.ID = Y.FRM
    TRANSACTION.ID = ''
    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.REC,OFSSTRING)
    OFSSTRING.LIST<-1> = OFSSTRING
*    CALL OFS.POST.MESSAGE(OFSSTRING,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

RETURN
*-----------------------------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------------------------
END
