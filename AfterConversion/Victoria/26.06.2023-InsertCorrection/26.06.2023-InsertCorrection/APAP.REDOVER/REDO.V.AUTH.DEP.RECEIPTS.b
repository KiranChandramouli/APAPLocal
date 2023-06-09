* @ValidationCode : MjoxNDk4MzkxNTI3OkNwMTI1MjoxNjg3Nzc0NjQ5ODU2OnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Jun 2023 15:47:29
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
SUBROUTINE REDO.V.AUTH.DEP.RECEIPTS
*-----------------------------------------------------------------------------
* Description:
* This routine will be attached to the VERSION.CONTROL of AZ.ACCOUNT Application as
* a auth routine
*----------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*----------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.V.AUTH.DEP.RECEIPTS
*----------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 17.04.2010  MARIMUTHU S     ODR-2009-11-0200  INITIAL CREATION
* 07.11.2011 Sudharsanan S        CR.18        Modify the code for read param table and change the conditon for finding category code in param table
*26-06-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,FM TO @FM,SM TO @SM, ++1 TO +=1, TNO TO C$T24.SESSION.NO
*26-06-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.H.INVENTORY.PARAMETER
    $INSERT I_F.REDO.H.ORDER.DETAILS
    $INSERT I_F.REDO.H.DEPOSIT.RECEIPTS
    $INSERT I_F.REDO.ITEM.STOCK.BY.DATE
    $INSERT I_F.REDO.ITEM.STOCK
    $INSERT I_F.REDO.H.REORDER.LEVEL
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_F.USER
    $INSERT I_F.REDO.L.SERIES.CHANGE.DETS
    $INSERT I_F.VERSION
*----------------------------------------------------------------------------------------
MAIN:
*----------------------------------------------------------------------------------------
    Y.CURR.NO = ''
    Y.CURR.NO = R.OLD(AZ.CURR.NO)
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB MIN.LEVEL.CHECK
    GOSUB PROGRAM.END
RETURN
*----------------------------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------------------------
    FN.REDO.H.INVENTORY.PARAMETER = 'F.REDO.H.INVENTORY.PARAMETER'
    F.REDO.H.INVENTORY.PARAMETER = ''
    CALL OPF(FN.REDO.H.INVENTORY.PARAMETER,F.REDO.H.INVENTORY.PARAMETER)

    FN.REDO.H.DEPOSIT.RECEIPTS = 'F.REDO.H.DEPOSIT.RECEIPTS'
    F.REDO.H.DEPOSIT.RECEIPTS = ''
    CALL OPF(FN.REDO.H.DEPOSIT.RECEIPTS,F.REDO.H.DEPOSIT.RECEIPTS)

    FN.REDO.ITEM.STOCK.BY.DATE = 'F.REDO.ITEM.STOCK.BY.DATE'
    F.REDO.ITEM.STOCK.BY.DATE = ''
    CALL OPF(FN.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE)

    FN.REDO.ITEM.SERIES = 'F.REDO.ITEM.SERIES'
    F.REDO.ITEM.SERIES = ''
    CALL OPF(FN.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES)

    FN.REDO.ITEM.STOCK = 'F.REDO.ITEM.STOCK'
    F.REDO.ITEM.STOCK = ''
    CALL OPF(FN.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.REDO.H.REORDER.LEVEL = 'F.REDO.H.REORDER.LEVEL'
    F.REDO.H.REORDER.LEVEL =''
    CALL OPF(FN.REDO.H.REORDER.LEVEL,F.REDO.H.REORDER.LEVEL)

    ITEM.CODE = ''
    REORDER.LEVEL = ''
    Y.COUNT.FMT = ''
    Y.CODE.DEPT = ''
    R.REDO.ITEM.STOCK.BK = ''
    R.REDO.ITEM.STOCK = ''
    R.REDO.ITEM.STOCK  = ''
    Y.VALU = V$FUNCTION
    R.PASS.INV = ''

    GOSUB GET.USER.DETIALS

RETURN
*----------------------------------------------------------------------------------------
GET.USER.DETIALS:
*----------------------------------------------------------------------------------------
    LOC.REF.APPLICATION="AZ.ACCOUNT":@FM:"USER" ;*R22 AUTO CONVERSION
    LOC.REF.FIELDS='L.AZ.RECEIPT.NO':@FM:'L.US.IDC.BR':@VM:'L.US.IDC.CODE' ;*R22 AUTO CONVERSION
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.AC = LOC.REF.POS<1,1>
    POS.BR.VAL =LOC.REF.POS<2,1>
    POS.DETP.VAL = LOC.REF.POS<2,2>
    Y.CODE.DEPT = ''
    Y.BRANCH.LIST = R.USER<EB.USE.LOCAL.REF,POS.BR.VAL>
    Y.DEPT.LIST = R.USER<EB.USE.LOCAL.REF,POS.DETP.VAL>
    R.REDO.ACCT.ITEM = ''

    LOCATE ID.COMPANY IN Y.BRANCH.LIST<1,1,1> SETTING POS.BR THEN
        Y.CODE.DEPT = Y.DEPT.LIST<1,1,POS.BR>
    END

RETURN
*----------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------

    Y.ACCOUNT.ID = APPLICATION
    CALL F.READ(FN.REDO.ITEM.SERIES,Y.ACCOUNT.ID,R.REDO.ACCT.ITEM,F.REDO.ITEM.SERIES,Y.ER.SER)
    Y.ACCOUNT.ID.LIST = FIELDS(R.REDO.ACCT.ITEM,'-',1,1)
    Y.DEP.ID.LIST = FIELDS(R.REDO.ACCT.ITEM,'-',2,1)
    LOCATE ID.NEW IN Y.ACCOUNT.ID.LIST SETTING POS.AC.LIS THEN
        Y.DEP.ID = Y.DEP.ID.LIST<POS.AC.LIS>
        CALL F.READ(FN.REDO.H.DEPOSIT.RECEIPTS,Y.DEP.ID,R.PASS.INV,F.REDO.H.DEPOSIT.RECEIPTS,Y.ERR)
        R.PASS.INV<REDO.DEP.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSION
        CALL F.WRITE(FN.REDO.H.DEPOSIT.RECEIPTS,Y.DEP.ID,R.PASS.INV)
    END ELSE
        Y.CATEG.ID = R.NEW(AZ.CATEGORY)
***********CR.18-S*********
        CALL CACHE.READ(FN.REDO.H.INVENTORY.PARAMETER,"SYSTEM",R.INV.PARAM,PARM.ERR)

        Y.CATEG.ID.PARAM = R.INV.PARAM<IN.PR.PROD.CATEG>
        Y.CATEG.ID.PARAM = CHANGE(Y.CATEG.ID.PARAM,@VM,@FM) ;*R22 AUTO CONVERSION
        Y.CATEG.ID.PARAM = CHANGE(Y.CATEG.ID.PARAM,@SM,@FM) ;*R22 AUTO CONVERSION

        Y.INV.MAIN = R.INV.PARAM<IN.PR.INV.MAINT.TYPE>
        Y.INV.MAIN = CHANGE(Y.INV.MAIN,@VM,@FM) ;*R22 AUTO CONVERSION
        Y.INV.MAIN = CHANGE(Y.INV.MAIN,@SM,@FM) ;*R22 AUTO CONVERSION

        IF R.INV.PARAM THEN
            MAINT.TYPE.CNT = 1   ; MAINT.TYPE.FOUND = 1
            GOSUB GET.LOOP.ITEM.CODE
        END
*************CR.18-E**************
        IF Y.CODE.DEPT THEN
            Y.ITEM.STOCK.ID = ID.COMPANY:"-":Y.CODE.DEPT
            Y.ITEM.STOCK.ID1 = ID.COMPANY:"-":Y.CODE.DEPT:".":ITEM.CODE
            Y.ID.SERIES = ID.COMPANY:'-':Y.CODE.DEPT:'.':ITEM.CODE
        END ELSE
            Y.ITEM.STOCK.ID = ID.COMPANY
            Y.ITEM.STOCK.ID1 = ID.COMPANY:".":ITEM.CODE
            Y.ID.SERIES = ID.COMPANY:'.':ITEM.CODE
        END
        Y.OFS.VAL = OFS$OPERATION
        Y.LOCK.VAL = 1
        IF Y.OFS.VAL EQ 'PROCESS' THEN
            GOSUB CHECK.FOR.NEXT.AVALIABLE
            IF NOT(Y.SERIAL.CHK) AND NOT(Y.CURR.NO) THEN
                AF = AZ.LOCAL.REF
                AV = POS.AC
                ETEXT = "EB-REDO.NO.SERIAL"
                CALL STORE.END.ERROR
            END
        END
    END
RETURN
*-------------------------------------------------------------------------------------
CHECK.FOR.NEXT.AVALIABLE:
*-------------------------------------------------------------------------------------
    CALL F.READU(FN.REDO.ITEM.SERIES,Y.ID.SERIES,R.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES,ERR,'')
    IF R.REDO.ITEM.SERIES THEN
        Y.SERIES.LIST = FIELDS(R.REDO.ITEM.SERIES,'*',1,1)
        Y.DATE.UPD.LIST = FIELDS(R.REDO.ITEM.SERIES,'*',4,1)
        GOSUB GET.ALL.SERIES

        Y.SORT.VAL = SORT(Y.DATE.VAL.NEW.LIST)

        Y.FINAL.VAL.CH = Y.SORT.VAL<Y.LOCK.VAL>

        LOCATE Y.FINAL.VAL.CH IN Y.SERIES.NEW.LIST SETTING POS.SORT THEN
            Y.SEL.LIST = FIELDS(R.REDO.ITEM.SERIES,'*',3,1)
            Y.DEP.ID = Y.SEL.LIST<POS.SORT>
            DEL R.REDO.ITEM.SERIES<POS.SORT>
        END
        R.PASS.INV = ''
        GOSUB UPDATE.RECEIPT.TABLE
    END
RETURN
*-------------------------------------------------------------------------------------
UPDATE.RECEIPT.TABLE:
*-------------------------------------------------------------------------------------
    CALL F.READ(FN.REDO.H.DEPOSIT.RECEIPTS,Y.DEP.ID,R.PASS.INV,F.REDO.H.DEPOSIT.RECEIPTS,INV.ERR)

    R.PASS.INV<REDO.DEP.ACCOUNT> = ID.NEW
    R.PASS.INV<REDO.DEP.STATUS> = 'Asignada'
*    R.PASS.INV<REDO.DEP.CATEGORY> = R.NEW(AZ.CATEGORY)

*R22 MANUAL CONVERSION START
*R.PASS.INV<REDO.DEP.STATUS.CHG,1> = 'Asignada'
*R.PASS.INV<REDO.DEP.STATUS.DATE,1> = TODAY
*R.PASS.INV<REDO.DEP.NEW.CREATED> = 'YES'
*R22 MANUAL CONVERSION END

    CURR.NO.VALUE = R.PASS.INV<REDO.DEP.CURR.NO>
    R.PASS.INV<REDO.DEP.CURR.NO>  = CURR.NO.VALUE + 1
    INPUTTER = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSION
    AUTHORISER = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSION
    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME = TEMPTIME[1,5]
    CHANGE ':' TO '' IN TEMPTIME
    CHECK.DATE = DATE()
    DATE.TIME = OCONV(CHECK.DATE,"DY2"):OCONV(CHECK.DATE,"DM"):OCONV(CHECK.DATE,"DD"):TEMPTIME
    R.PASS.INV<REDO.DEP.INPUTTER> = INPUTTER
    R.PASS.INV<REDO.DEP.DATE.TIME> = DATE.TIME
    R.PASS.INV<REDO.DEP.DATE.UPDATED> = TODAY
    R.PASS.INV<REDO.DEP.USER> = OPERATOR
    IF NOT(R.NEW(AZ.LOCAL.REF)<1,POS.AC>) OR ( R.REDO.ITEM.STOCK.BK EQ R.REDO.ITEM.STOCK ) THEN
        R.NEW(AZ.LOCAL.REF)<1,POS.AC> = R.PASS.INV<REDO.DEP.SERIAL.NO>
        Y.SERIAL.CHK = ''
        Y.SERIAL.CHK = R.NEW(AZ.LOCAL.REF)<1,POS.AC>
        GOSUB INV.STOCK.UPDT
        GOSUB INV.STOCK.UPDT.VAL
        Y.ACCOUNT.ID = APPLICATION
        CALL F.WRITE(FN.REDO.H.DEPOSIT.RECEIPTS,Y.DEP.ID,R.PASS.INV)
        CALL F.WRITE(FN.REDO.ITEM.SERIES,Y.ITEM.STOCK.ID1,R.REDO.ITEM.SERIES)
        R.REDO.ACCT.ITEM<-1> =ID.NEW:'-':Y.DEP.ID
        CALL F.WRITE(FN.REDO.ITEM.SERIES,Y.ACCOUNT.ID,R.REDO.ACCT.ITEM)
    END

*    GOSUB UPDATE.SERIAL.DETAILS

RETURN
*-------------------------------------------------------------------------------------
GET.LOOP.ITEM.CODE:
*-------------------------------------------------------------------------------------
    LOOP
    WHILE MAINT.TYPE.FOUND EQ 1
        FIND 'DEPOSIT.RECEIPTS' IN Y.INV.MAIN,MAINT.TYPE.CNT SETTING POS THEN
            MAINT.TYPE.CNT += 1 ;*R22 AUTO CONVERSION
            GOSUB GET.ITEM.CODE.VAL
        END ELSE
            MAINT.TYPE.FOUND = 0
        END
    REPEAT
RETURN
*-------------------------------------------------------------------------------------
GET.ITEM.CODE.VAL:
*-------------------------------------------------------------------------------------
    VAR.CATEG.ID =  R.INV.PARAM<IN.PR.PROD.CATEG,POS>
    CHANGE @SM TO @FM IN VAR.CATEG.ID ;*R22 AUTO CONVERSION
    LOCATE Y.CATEG.ID IN VAR.CATEG.ID SETTING CAT.POS THEN
        ITEM.CODE = R.INV.PARAM<IN.PR.ITEM.CODE,POS>
        DESCRIPTION = R.INV.PARAM<IN.PR.ITEM.DESC,POS>
        REORDER.LEVEL = R.INV.PARAM<IN.PR.REORDER.LEVEL,POS>
        QTY.TO.ORDER = R.INV.PARAM<IN.PR.QTY.TO.REQ,POS>
        MAINT.TYPE.FOUND = 0
    END
RETURN
*-------------------------------------------------------------------------------------
INV.STOCK.UPDT:
*-------------------------------------------------------------------------------------
    R.REDO.ITEM.STOCK = ''
    CALL F.READ(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK,Y.ERR)

    R.REDO.ITEM.STOCK.BK = R.REDO.ITEM.STOCK

    Y.LIST.ITM = R.REDO.ITEM.STOCK<ITEM.REG.ITEM.CODE>

    LOCATE ITEM.CODE IN Y.LIST.ITM<1,1> SETTING POS THEN
        R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> = R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> - 1
    END
    IF R.REDO.ITEM.STOCK THEN
        CALL F.WRITE(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK)
    END

RETURN
*-------------------------------------------------------------------------------------
INV.STOCK.UPDT.VAL:
*-------------------------------------------------------------------------------------
    Y.DATE.RPT = TODAY
    CALL F.READ(FN.REDO.ITEM.STOCK.BY.DATE,Y.ITEM.STOCK.ID1,R.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE,Y.ERR.FLA)
    IF R.REDO.ITEM.STOCK.BY.DATE THEN
        LOCATE Y.DATE.RPT IN R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,1> SETTING POS.RPT THEN
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,POS.RPT>            =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,POS.RPT> + 1
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT>           =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT> - 1
        END ELSE
            Y.DATE.COUNT1 = DCOUNT(R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE>,@VM) ;*R22 AUTO CONVERSION
            Y.DATE.COUNT = Y.DATE.COUNT1 + 1

            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,Y.DATE.COUNT>                = Y.DATE.RPT
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ITEM.CODE,Y.DATE.COUNT>           = ITEM.CODE
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.INITIAL.STOCK,Y.DATE.COUNT>       = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT1>
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,Y.DATE.COUNT>            = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,Y.DATE.COUNT> + 1
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT>           = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT1> - 1
        END
        CALL F.WRITE(FN.REDO.ITEM.STOCK.BY.DATE,Y.ITEM.STOCK.ID1,R.REDO.ITEM.STOCK.BY.DATE)
    END
RETURN
*-------------------------------------------------------------------------------------
GET.ALL.SERIES:
*-------------------------------------------------------------------------------------

    Y.VAL.CK = ''
    Y.MAX = MAXIMUM(Y.SERIES.LIST)
    Y.LEN = LEN(Y.MAX)
    Y.FMT = 'R%':Y.LEN
    Y.CNT.FMT = 1
    Y.COUNT.FMT = DCOUNT(Y.SERIES.LIST,@FM) ;*R22 AUTO CONVERSION
    LOOP
    WHILE Y.CNT.FMT LE Y.COUNT.FMT
        Y.VAL.CK = Y.SERIES.LIST<Y.CNT.FMT>
        Y.SERIES.NEW.LIST<-1> = Y.DATE.UPD.LIST<Y.CNT.FMT>:FMT(Y.SERIES.LIST<Y.CNT.FMT>,Y.FMT)
        IF Y.VAL.CK THEN
            Y.FMT.CHCK.VAL = FMT(Y.SERIES.LIST<Y.CNT.FMT>,Y.FMT)
            Y.DATE.VAL.NEW.LIST<-1> = Y.DATE.UPD.LIST<Y.CNT.FMT>:Y.FMT.CHCK.VAL
        END
        Y.CNT.FMT += 1 ;*R22 AUTO CONVERSION
    REPEAT
    Y.SORT.VALUE.NEW  = Y.DATE.VAL.NEW.LIST
RETURN
*-------------------------------------------------------------------------------------
MIN.LEVEL.CHECK:
    CALL F.READ(FN.REDO.H.REORDER.LEVEL,ID.COMPANY,R.REDO.H.REORDER.LEVEL,F.REDO.H.REORDER.LEVEL,Y.INV.ERR)
    Y.REORDER.LEVEL = R.REDO.H.REORDER.LEVEL<RE.ORD.REORDER.LEVEL>
    Y.ITEM.LIST = R.REDO.H.REORDER.LEVEL<RE.ORD.ITEM.VALUE>
    Y.ORD.CODE  = R.REDO.H.REORDER.LEVEL<RE.ORD.CODE>
    Y.CODE.CNT  = DCOUNT(Y.ORD.CODE,@VM) ;*R22 AUTO CONVERSION
    Y.GOT.FLAG = ''
    Y.CODE.INIT = 1
    LOOP
        REMOVE Y.CODE.ID FROM Y.ORD.CODE SETTING Y.COD.POS
    WHILE Y.CODE.INIT LE Y.CODE.CNT
        IF Y.CODE.ID EQ Y.CODE.DEPT AND NOT(Y.GOT.FLAG) THEN
            LOCATE ITEM.CODE IN Y.ITEM.LIST<1,Y.CODE.INIT,1> SETTING Y.ITEM.POS THEN
                Y.REORDER.VAL = Y.REORDER.LEVEL<1,Y.CODE.INIT,Y.ITEM.POS>
                Y.GOT.FLAG = 1
            END
        END
        Y.CODE.INIT += 1 ;*R22 AUTO CONVERSION
    REPEAT
    R.REC = DCOUNT(Y.SORT.VALUE.NEW,@FM) ;*R22 AUTO CONVERSION
    IF DCOUNT(Y.SORT.VALUE.NEW,@FM) LE Y.REORDER.VAL AND NOT(Y.CURR.NO) THEN ;*R22 AUTO CONVERSION
        TEXT = 'REDO.MIN.INVENT.LEVEL'
        Y.CURR.CNT = DCOUNT(R.NEW(AZ.LOCAL.REF),@VM) ;*R22 AUTO CONVERSION
        CALL STORE.OVERRIDE(Y.CURR.CNT+1)
    END
RETURN
*---------------------------------------------------------------------------------------
PROGRAM.END:
*---------------------------------------------------------------------------------------
UPDATE.SERIAL.DETAILS:
*---------------------

    IF R.NEW(AZ.LOCAL.REF)<1,POS.AC> AND Y.DEP.ID THEN
        FN.REDO.L.SERIES.CHANGE.DETS = 'F.REDO.L.SERIES.CHANGE.DETS'
        F.REDO.L.SERIES.CHANGE.DETS = ''
        CALL OPF(FN.REDO.L.SERIES.CHANGE.DETS, F.REDO.L.SERIES.CHANGE.DETS)

        Y.SERIAL.DET.ID = TODAY:'.':Y.DEP.ID

        Y.READ.ERR = ''
        CALL F.READ(FN.REDO.L.SERIES.CHANGE.DETS, Y.SERIAL.DET.ID, R.SERIAL.DETS, F.REDO.L.SERIES.CHANGE.DETS, Y.READ.ERR)

        IF R.SERIAL.DETS ELSE
            R.SERIAL.DETS<AZ.CH.DETS.STATUS> = 'Asignada'
            R.SERIAL.DETS<AZ.CH.DETS.CATEGORY> = Y.CATEG.ID
            R.SERIAL.DETS<AZ.CH.DETS.DATE> = TODAY
            CALL F.WRITE(FN.REDO.L.SERIES.CHANGE.DETS, Y.SERIAL.DET.ID, R.SERIAL.DETS)
        END

        Y.NO.AUTH = R.VERSION(EB.VER.NO.OF.AUTH)

        IF V$FUNCTION EQ 'A' OR (Y.NO.AUTH EQ 0 AND V$FUNCTION EQ 'I') THEN
            Y.READ.ERR = ''
            Y.FILE.ID = 'AZ':R.NEW(AZ.LOCAL.REF)<1,POS.AC>
            CALL F.READ(FN.REDO.L.SERIES.CHANGE.DETS, Y.FILE.ID, R.SERIES.CONCAT, F.REDO.L.SERIES.CHANGE.DETS, Y.READ.ERR)

            IF R.SERIES.CONCAT ELSE
                R.SERIES.CONCAT<AZ.CH.DETS.AZ.ID> = ID.NEW
                R.SERIES.CONCAT<AZ.CH.DETS.DEP.ID> = Y.DEP.ID
            END
            CALL F.WRITE(FN.REDO.L.SERIES.CHANGE.DETS, Y.FILE.ID, R.SERIES.CONCAT)
        END

    END

RETURN
*---------------------------------------------------------------------------------------
END
