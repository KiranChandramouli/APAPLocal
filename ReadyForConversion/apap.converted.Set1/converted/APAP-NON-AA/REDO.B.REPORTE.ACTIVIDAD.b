SUBROUTINE REDO.B.REPORTE.ACTIVIDAD(AA.ARR.ID)
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      :
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description:
*-------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*-----------------------------------------------------------------------------------------------------------------
* PACS00363969           Ashokkumar.V.P                 27/11/2014            Replaced the routine to get the value from AA.ARR.TERM.AMOUNT>L.CR.FACILTY.
*                                                                             Excluded the AA loan with status equals to 3.
* PACS00363969           Ashokkumar.V.P                 03/03/2015            Replaced with AA.ARR.ACCOUNT>L.CR.FACILITY field to fetch details and group.
* PACS00466618           Ashokkumar.V.P                 26/06/2015            Fixed the NAB account created on same date for old NAB loans.
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS

    $INSERT I_REDO.B.REPORTE.ACTIVIDAD.COMMON
*   $INSERT I_F.EB.CONTRACT.BALANCES;*/ TUS START/END

*
    GOSUB INIT
RETURN
*-------------------------------------------------------------------------------
INIT:
*----
*
    GOSUB AA.MAIN
    IF STAR.DATE.VAL GT Y.PST.TODAY THEN
        RETURN
    END
    IF YAA.ARR.STAT NE Y.SEL.VAL.1 AND YAA.ARR.STAT NE Y.SEL.VAL.2 THEN
        RETURN
    END
    IF LOAN.STATUS EQ "Write-off" THEN
        RETURN
    END
    GOSUB PROCESS.PARA
    IF NOT(Y.RETURN.FLAG) THEN
        GOSUB MAP.RCL
        GOSUB WRITE.TO.FILE
    END
RETURN

AA.MAIN:
********
    Y.RETURN.FLAG = ''; C$SPARE(200) = ''; C$SPARE(201) = ''; C$SPARE(203) = ''
    R.AA.ARR = ''; AA.ARR.ERR = ''; LOAN.STATUS = ''; STAR.DATE.VAL = ''
    REQUEST.TYPE = '';  REQUEST.TYPE<4>='ECB'; YAA.ARR.STAT = ''
    CALL F.READ(FN.AA.ARRANGEMENT,AA.ARR.ID,R.AA.ARR,F.AA.ARRANGEMENT,AA.ARR.ERR)
    Y.LINKED.APPL = R.AA.ARR<AA.ARR.LINKED.APPL>
    STAR.DATE.VAL = R.AA.ARR<AA.ARR.START.DATE>
    YAA.ARR.STAT = R.AA.ARR<AA.ARR.ARR.STATUS>

    ArrangementID = AA.ARR.ID
    effectiveDate = ''
    idPropertyClass = 'OVERDUE'
    idProperty = ''; returnIds = ''; returnConditions = ''; returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.OVERDUE = RAISE(returnConditions)
    LOAN.STATUS = R.AA.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.STATUS.1.POS>
RETURN

PROCESS.PARA:
*------------
*
    Y.LINKED.POS = ''
    LOCATE "ACCOUNT" IN Y.LINKED.APPL<1,1> SETTING Y.LINKED.POS THEN
        Y.ACCT.NO = R.AA.ARR<AA.ARR.LINKED.APPL.ID,Y.LINKED.POS>
    END
    R.ACCOUNT = ''; ERR.ACCOUNT = ''; L.OD.STATUS.VAL = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    L.OD.STATUS.VAL = R.ACCOUNT<AC.LOCAL.REF,L.OD.STATUS.POS>
    GOSUB GET.TERM.AMOUNT

    IF NOT(Y.L.INV.FACILITY) THEN
        Y.RETURN.FLAG = '1'
        RETURN
    END

    C$SPARE(200) = Y.L.INV.FACILITY
    Y.PRIN.INT   = "ACCPRINCIPALINT":@FM:"DUEPRINCIPALINT":@FM:"GRCPRINCIPALINT":@FM:"DE1PRINCIPALINT":@FM:"DE2PRINCIPALINT":@FM:"DE3PRINCIPALINT":@FM:"DELPRINCIPALINT":@FM:"NABPRINCIPALINT"
    Y.LIST.LOOP  = Y.PRIN.INT
    Y.PRIN.AMOUNT = ''
    IF L.OD.STATUS.VAL NE 'NAB' THEN
        GOSUB LOOP.PROCESS
        C$SPARE(201) = ABS(Y.PRIN.AMOUNT)
    END ELSE
        GOSUB ACC.NAB.PROCESS
    END
*
    Y.ACC.INT    = "CURACCOUNT":@FM:"DUEACCOUNT":@FM:"GRCACCOUNT":@FM:"DE1ACCOUNT":@FM:"DE2ACCOUNT":@FM:"DE3ACCOUNT":@FM:"DELACCOUNT":@FM:"NABACCOUNT"
    Y.LIST.LOOP  = Y.ACC.INT
    Y.PRIN.AMOUNT = ''
    GOSUB LOOP.PROCESS
    C$SPARE(203) = ABS(Y.PRIN.AMOUNT)
RETURN

GET.TERM.AMOUNT:
****************
    ArrangementID = AA.ARR.ID; idPropertyClass = 'ACCOUNT'
    idProperty = ''; effectiveDate = ''; returnIds = ''; returnConditions = ''; returnError = ''; Y.L.INV.FACILITY = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.ACCOUNT = RAISE(returnConditions)
    Y.L.INV.FACILITY = R.AA.ACCOUNT<AA.AC.LOCAL.REF,L.CR.FACILITY.POS>
RETURN

ACC.NAB.PROCESS:
****************
    ERR.AA.ACCOUNT.DETAILS = ''; R.AA.ACCOUNT.DETAILS = ''; SUSPEND.VAL = ''; SUSPEND.STAT = ''; SUSPEND.DTE = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,AA.ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ERR.AA.ACCOUNT.DETAILS)
    SUSPEND.VAL = R.AA.ACCOUNT.DETAILS<AA.AD.SUSPENDED>
    SUSPEND.STAT = R.AA.ACCOUNT.DETAILS<AA.AD.SUSP.STATUS,1>
    SUSPEND.DTE = R.AA.ACCOUNT.DETAILS<AA.AD.SUSP.DATE,1>
    IF SUSPEND.VAL AND SUSPEND.VAL EQ 'YES' THEN
        IF SUSPEND.STAT EQ 'SUSPEND' AND SUSPEND.DTE GT Y.PST.TODAY THEN
            RETURN
        END
    END ELSE
        RETURN
    END
    R.REDO.CONCAT.ACC.NAB = ''; NAB.ERR = ''; ERR.ACCOUNT = ''; R.ACCOUNT = ''; OUT.STD.AMT.33 = ''
    CALL F.READ(FN.REDO.CONCAT.ACC.NAB,Y.ACCT.NO,R.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB,NAB.ERR)
    IF NOT(R.REDO.CONCAT.ACC.NAB) THEN
        RETURN
    END
    CALL F.READ(FN.ACCOUNT,R.REDO.CONCAT.ACC.NAB,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    CALL EB.READ.HVT('EB.CONTRACT.BALANCES',R.REDO.CONCAT.ACC.NAB,R.ECB,ERR.ACCOUNT) ;*Tus Start
*YACC.NABB = R.ACCOUNT<AC.WORKING.BALANCE>
    YACC.NABB = R.ECB<ECB.WORKING.BALANCE> ;*Tus End
    YACC.NABB = ABS(YACC.NABB)
*YCR.DTE = R.ACCOUNT<AC.DATE.LAST.CR.BANK,1> ;*Tus Start
    LOCATE 'BANK-CR' IN R.ECB<ECB.INITIATOR.TYPE,1> SETTING BANK.CR.POS THEN
        YCR.DTE = R.ECB<ECB.DATE.LAST,BANK.CR.POS,1>
    END
*YCR.AMT = R.ACCOUNT<AC.AMNT.LAST.CR.BANK,1>
    LOCATE 'BANK-CR' IN R.ECB<ECB.INITIATOR.TYPE,1> SETTING BANK.CR.POS1 THEN
        YCR.AMT = R.ECB<ECB.AMNT.LAST,BANK.CR.POS1,1>
    END ;*Tus End
    YCR.AMT = ABS(YCR.AMT)
    IF YCR.DTE GT Y.PST.TODAY THEN
        YACC.NABBAL = YACC.NABB - YCR.AMT
    END ELSE
        YACC.NABBAL = YACC.NABB
    END
    C$SPARE(201) = YACC.NABBAL
RETURN

MAP.RCL:
*-------
    MAP.FMT = 'MAP'
    ID.RCON.L = "REDO.RPT.RCL.AA.ACTIVIDAD"
    APP = FN.AA.ARRANGEMENT
    ID.APP = AA.ARR.ID
    R.APP = R.AA.ARR
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    IF R.RETURN.MSG THEN
        OUT.ARRAY = R.RETURN.MSG
    END
RETURN

WRITE.TO.FILE:
*--------------
*
    CALL ALLOCATE.UNIQUE.TIME(Y.TIME)
    Y.FILE.NAME = FILE.NAME :'*':Y.TIME
    IF Y.L.INV.FACILITY THEN
        Y.OUT.ARRAY = Y.L.INV.FACILITY:@FM:OUT.ARRAY
        OPEN TEMP.PATH TO TEMP.PATH1 THEN
        END
        WRITE Y.OUT.ARRAY TO TEMP.PATH1,Y.FILE.NAME
    END
RETURN
*
LOOP.PROCESS:
*------------
    LOOP
        REMOVE Y.PRIN.ID FROM Y.LIST.LOOP SETTING Y.PRIN.POS
    WHILE Y.PRIN.ID:Y.PRIN.POS
        START.DATE = STAR.DATE.VAL
        SYSTEM.DATE = Y.PST.TODAY
        CALL AA.GET.PERIOD.BALANCES(Y.ACCT.NO,Y.PRIN.ID,REQUEST.TYPE,START.DATE,SYSTEM.DATE,'',BAL.DETAILS,ERR.MSG)
        Y.BAL.AMT = BAL.DETAILS<4>
        Y.PRIN.AMOUNT += Y.BAL.AMT
    REPEAT
*
RETURN
END
