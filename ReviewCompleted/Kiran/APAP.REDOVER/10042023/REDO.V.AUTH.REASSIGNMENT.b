* @ValidationCode : MjotMTUxMjE4MDMzMzpDcDEyNTI6MTY4MTEyMDUyMjMwMjpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 15:25:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUTH.REASSIGNMENT
*-----------------------------------------------------------------------------
* Description:
* This routine will be attached to the version REDO.H.REASSIGNMENT, as
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
* PROGRAM NAME : REDO.V.AUTH.REASSIGNMENT
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 12.04.2010  MARIMUTHU S     ODR-2009-11-0200  INITIAL CREATION
* -----------------------------------------------------------------------------------------

*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM,TNO TO C$T24.SESSION.NO
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.PASSBOOK.INVENTORY
    $INSERT I_F.REDO.ITEM.STOCK.BY.DATE
    $INSERT I_F.REDO.H.INVENTORY.PARAMETER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.H.ORDER.DETAILS
    $INSERT I_F.REDO.ITEM.STOCK
    $INSERT I_F.REDO.H.REASSIGNMENT
*   $INSERT I_F.REDO.ITEM.STOCK.BY.DATE    ;*R22 AUTO CODE CONVERSION
    $INSERT I_REDO.INV.REASSIGN.COMMON
* -----------------------------------------------------------------------------

    GOSUB OPENFILE
    GOSUB PROCESS
    GOSUB PROGRAM.END
RETURN
*-----------------------------------------------------------------------------
OPENFILE:
*-----------------------------------------------------------------------------
    FN.REDO.H.PASSBOOK.INVENTORY = 'F.REDO.H.PASSBOOK.INVENTORY'
    F.REDO.H.PASSBOOK.INVENTORY = ''
    CALL OPF(FN.REDO.H.PASSBOOK.INVENTORY,F.REDO.H.PASSBOOK.INVENTORY)

    FN.REDO.H.INVENTORY.PARAMETER = 'F.REDO.H.INVENTORY.PARAMETER'
    F.REDO.H.INVENTORY.PARAMETER = ''
    CALL OPF(FN.REDO.H.INVENTORY.PARAMETER,F.REDO.H.INVENTORY.PARAMETER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.ITEM.STOCK.BY.DATE ='F.REDO.ITEM.STOCK.BY.DATE'
    F.REDO.ITEM.STOCK.BY.DATE =''
    CALL OPF(FN.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE)

    FN.REDO.ITEM.STOCK ='F.REDO.ITEM.STOCK'
    F.REDO.ITEM.STOCK = ''
    CALL OPF(FN.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK)

    Y.ITEM.CODE = Y.NEWSER.ITEM.CODE
    IF R.NEW(RE.ASS.CODE) THEN
        Y.ITEM.STOCK.ID = ID.COMPANY:'-':R.NEW(RE.ASS.CODE)
        Y.ITEM.STOCK.ID1 = ID.COMPANY:"-":R.NEW(RE.ASS.CODE):".":Y.ITEM.CODE

    END ELSE
        Y.ITEM.STOCK.ID = ID.COMPANY
        Y.ITEM.STOCK.ID1 = ID.COMPANY:".":Y.ITEM.CODE
    END

    FN.REDO.ITEM.SERIES = 'F.REDO.ITEM.SERIES'
    F.REDO.ITEM.SERIES = ''
    CALL OPF(FN.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES)

    CALL F.READ(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK,E.RR.ITEM)
    CALL F.READ(FN.REDO.ITEM.STOCK.BY.DATE,Y.ITEM.STOCK.ID1,R.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE,Y.ER.DAT)
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.NEW.SERIES = R.NEW(RE.ASS.NEW.SERIES)

    Y.ACCT.NO = R.NEW(RE.ASS.ACCOUNT.NUMBER)

    CALL F.READ(FN.REDO.ITEM.SERIES,Y.ITEM.STOCK.ID1,R.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES,Y.ERR)
*    Y.SERIES.LIST = FIELDS(R.REDO.ITEM.SERIES,'-',1,1)
    Y.SERIES.LIST = FIELDS(R.REDO.ITEM.SERIES,'*',1,1)
*   Y.PASS.LIST =    FIELDS(R.REDO.ITEM.SERIES,'-',3,1)
    Y.PASS.LIST =    FIELDS(R.REDO.ITEM.SERIES,'*',3,1)
    LOCATE Y.NEW.SERIES IN Y.SERIES.LIST SETTING POS THEN
        SEL.LIST = Y.PASS.LIST<POS>
        R.REDO.ITEM.SERIES<POS> = ''
    END
    CALL F.READ(FN.REDO.ITEM.SERIES,Y.ITEM.STOCK.ID1,R.REDO.ITEM.SER,F.REDO.ITEM.SERIES,Y.ERR)
    CALL F.READ(FN.REDO.H.PASSBOOK.INVENTORY,SEL.LIST,R.PASS.INV,F.REDO.H.PASSBOOK.INVENTORY,PASS.ERR)
    R.PASS.INV<REDO.PASS.ACCOUNT> = Y.ACCT.NO
    R.PASS.INV<REDO.PASS.STATUS> = 'Asignada'

    CURR.NO.VALUE = R.PASS.INV<REDO.PASS.CURR.NO>
    R.PASS.INV<REDO.PASS.CURR.NO>  = CURR.NO.VALUE + 1
    INPUTTER = R.NEW(RE.ASS.INPUTTER)
    AUTHORISER = C$T24.SESSION.NO:'_':OPERATOR   ;*R22 AUTO CODE CONVERSION

    SYS.TIME.NOW = OCONV(DATE(),"D-")
    SYS.TIME.NOW = SYS.TIME.NOW[9,2]:SYS.TIME.NOW[1,2]:SYS.TIME.NOW[4,2]
    SYS.TIME.NOW := TIMEDATE()[1,2]:TIMEDATE()[4,2]

    R.PASS.INV<REDO.PASS.INPUTTER> = INPUTTER
    R.PASS.INV<REDO.PASS.DATE.TIME> = SYS.TIME.NOW
    R.PASS.INV<REDO.PASS.AUTHORISER> = AUTHORISER
    R.PASS.INV<REDO.PASS.USER> = OPERATOR
    R.PASS.INV<REDO.PASS.CO.CODE> = ID.COMPANY
    R.PASS.INV<REDO.PASS.DATE.UPDATED> = TODAY

    CALL F.WRITE(FN.REDO.H.PASSBOOK.INVENTORY,SEL.LIST,R.PASS.INV)
    CALL F.WRITE(FN.REDO.ITEM.SERIES,Y.ITEM.STOCK.ID1,R.REDO.ITEM.SERIES)

    Y.LIST.ITM = R.REDO.ITEM.STOCK<ITEM.REG.ITEM.CODE>

    LOCATE Y.ITEM.CODE IN Y.LIST.ITM<1,1> SETTING POS THEN
        R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> = R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> - 1
    END
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACC,F.ACCOUNT,ACC.ERR)
    TOTAL.DIGIT=''
    LOC.REF.APPLICATION="ACCOUNT"
    LOC.REF.FIELDS='L.SERIES.ID'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.AC.1 =LOC.REF.POS<1,1>
    Y.SERIES.LIST.VAL = R.ACC<AC.LOCAL.REF,POS.AC.1>
    CHANGE @SM TO @FM IN Y.SERIES.LIST.VAL
    CHANGE @VM TO @FM IN Y.SERIES.LIST.VAL
    Y.SERIES.LIST.VAL<-1> = Y.NEW.SERIES
    CHANGE @FM TO @SM IN Y.SERIES.LIST.VAL
    R.ACC<AC.LOCAL.REF,POS.AC.1> = Y.SERIES.LIST.VAL
    CALL F.WRITE(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK)
    GOSUB INV.STOCK.UPDT.VAL
    CALL F.WRITE(FN.ACCOUNT,Y.ACCT.NO,R.ACC)
*PACS00260041-S
    R.REDO.ITEM.SERIES = ''
    CALL F.READ(FN.REDO.ITEM.SERIES,Y.ACCT.NO,R.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES,Y.ERR)

    R.REDO.ITEM.SERIES<-1> = Y.ACCT.NO:"-":SEL.LIST

    CALL F.WRITE(FN.REDO.ITEM.SERIES,Y.ACCT.NO,R.REDO.ITEM.SERIES)
*PACS00260041-E

    GOSUB UPDATE.OLD.SERIAL

RETURN
*-----------------------------------------------------------------------------
INV.STOCK.UPDT.VAL:
*-----------------------------------------------------------------------------

    Y.DATE.RPT = TODAY
    CALL F.READ(FN.REDO.ITEM.STOCK.BY.DATE,Y.ITEM.STOCK.ID1,R.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE,Y.ERR.FLA)
    LOCATE Y.DATE.RPT IN R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,1> SETTING POS.RPT THEN
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,POS.RPT>            =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,POS.RPT> + 1
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT>           =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT> - 1
    END ELSE
        Y.DATE.COUNT1 = DCOUNT(R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE>,@VM)
        Y.DATE.COUNT = Y.DATE.COUNT1 + 1

        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,Y.DATE.COUNT>                = Y.DATE.RPT
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ITEM.CODE,Y.DATE.COUNT>           = Y.ITEM.CODE
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.INITIAL.STOCK,Y.DATE.COUNT>       = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT1>
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,Y.DATE.COUNT>            = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,Y.DATE.COUNT1> + 1
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT>           = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT1> - 1
    END
    CALL F.WRITE(FN.REDO.ITEM.STOCK.BY.DATE,Y.ITEM.STOCK.ID1,R.REDO.ITEM.STOCK.BY.DATE)
RETURN
*-----------------------------------------------------------------------------
UPDATE.OLD.SERIAL:
*----------------

    Y.OLD.SERIAL = R.NEW(RE.ASS.SERIES)
    Y.SEL.CMD = 'SELECT ':FN.REDO.H.PASSBOOK.INVENTORY:' WITH SERIAL.NO EQ ':Y.OLD.SERIAL   ;* Indexed Column
    CALL EB.READLIST(Y.SEL.CMD, R.SEL.ID, '', '','')

    IF R.SEL.ID THEN
        Y.OLD.INV.ID = R.SEL.ID
        CALL F.READ(FN.REDO.H.PASSBOOK.INVENTORY, Y.OLD.INV.ID, R.OLD.INV.REC, F.REDO.H.PASSBOOK.INVENTORY, Y.READ.ERR )
        R.OLD.INV.REC<REDO.PASS.STATUS> = 'Cancelada'
        R.OLD.INV.REC<REDO.PASS.DATE.UPDATED> = TODAY
        R.OLD.INV.REC<REDO.PASS.USER> = OPERATOR
        R.OLD.INV.REC<REDO.PASS.STATUS.CHG, -1> = 'Cancelada'
        R.OLD.INV.REC<REDO.PASS.STATUS.DATE, -1> = TODAY
        R.OLD.INV.REC<REDO.PASS.USER.MOD,-1> = OPERATOR
        R.OLD.INV.REC<REDO.PASS.USER.AUTH, -1> = OPERATOR
        R.OLD.INV.REC<REDO.PASS.NEW.CREATED> = 'YES'

        SYS.TIME.NOW = OCONV(DATE(),"D-")
        SYS.TIME.NOW = SYS.TIME.NOW[9,2]:SYS.TIME.NOW[1,2]:SYS.TIME.NOW[4,2]
        SYS.TIME.NOW := TIMEDATE()[1,2]:TIMEDATE()[4,2]

        R.OLD.INV.REC<REDO.PASS.INPUTTER> = INPUTTER
        R.OLD.INV.REC<REDO.PASS.DATE.TIME> = SYS.TIME.NOW
        R.OLD.INV.REC<REDO.PASS.AUTHORISER> = AUTHORISER
        R.OLD.INV.REC<REDO.PASS.USER> = OPERATOR
        R.OLD.INV.REC<REDO.PASS.CO.CODE> = ID.COMPANY
        R.OLD.INV.REC<REDO.PASS.DATE.UPDATED> = TODAY

        CALL F.WRITE(FN.REDO.H.PASSBOOK.INVENTORY, Y.OLD.INV.ID, R.OLD.INV.REC)

        GOSUB CHECK.OTHER.TABLE


    END

RETURN

*-----------------------------------------------------------------------------
CHECK.OTHER.TABLE:
*----------------

    Y.ITEM.CODE = R.NEW(RE.ASS.ITEM.CODE)

    IF R.NEW(RE.ASS.CODE) THEN
        Y.ITEM.STOCK.ID = ID.COMPANY:'-':R.NEW(RE.ASS.CODE)
        Y.ITEM.STOCK.ID1 = ID.COMPANY:"-":R.NEW(RE.ASS.CODE):".":Y.ITEM.CODE

    END ELSE
        Y.ITEM.STOCK.ID = ID.COMPANY
        Y.ITEM.STOCK.ID1 = ID.COMPANY:".":Y.ITEM.CODE
    END

    Y.DATE.RPT = TODAY
    CALL F.READ(FN.REDO.ITEM.STOCK.BY.DATE,Y.ITEM.STOCK.ID1,R.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE,Y.ERR.FLA)
    LOCATE Y.DATE.RPT IN R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,1> SETTING POS.RPT THEN
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.CANCELLED,POS.RPT>            =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.CANCELLED,POS.RPT> + 1
    END ELSE
        Y.DATE.COUNT1 = DCOUNT(R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE>,@VM)
        Y.DATE.COUNT = Y.DATE.COUNT1 + 1

        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,Y.DATE.COUNT>                = Y.DATE.RPT
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ITEM.CODE,Y.DATE.COUNT>           = Y.ITEM.CODE
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.INITIAL.STOCK,Y.DATE.COUNT>       = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT1>
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,Y.DATE.COUNT>            = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,Y.DATE.COUNT1>
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT>           = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT1>
        R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.CANCELLED,Y.DATE.COUNT>           =  R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.CANCELLED,Y.DATE.COUNT1> + 1

    END
    CALL F.WRITE(FN.REDO.ITEM.STOCK.BY.DATE,Y.ITEM.STOCK.ID1,R.REDO.ITEM.STOCK.BY.DATE)


RETURN
PROGRAM.END:
*-----------------------------------------------------------------------------
END
