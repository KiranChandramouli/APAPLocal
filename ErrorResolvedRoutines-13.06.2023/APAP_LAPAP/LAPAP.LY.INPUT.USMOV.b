* @ValidationCode : MjoxMzQ3ODU3MDE1OkNwMTI1MjoxNjg2NjQ3MzI1NTM0OklUU1MxOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jun 2023 14:38:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.LY.INPUT.USMOV
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to make the proper points movements during usage
* Basada en la logica de la rutina : REDO.LY.INPUT.USMOV
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN : -NA-
* OUT : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : LAPAP.LY.INPUT.USMOV
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*15.06.2012 RMONDRAGON ODR-2011-06-0243 FIRST VERSION
*15.07.2012 RMONDRAGON ODR-2011-06-0243 SECOND VERSION
* -----------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*12-06-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED , VM TO @VM, ++ TO +=1
*12-06-2023       Samaran T               R22 Manual Code Conversion       CALL RTN FORMAT MODIFIED
*-------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON  ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.LY.POINTS.US
    $INSERT I_F.REDO.LY.POINTS.TOT
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_F.REDO.LY.MASTERPRGDR
    $INSERT I_GTS.COMMON   ;*R22 AUTO CODE CONVERSION.END
    $USING APAP.REDOVER

    IF (V$FUNCTION EQ 'R' OR V$FUNCTION EQ 'D') THEN
        RETURN
    END

    GOSUB INIT
    GOSUB PROCESS

RETURN

*----
INIT:
*----

    FN.REDO.LY.POINTS.US = 'F.REDO.LY.POINTS.US'
    F.REDO.LY.POINTS.US = ''
    CALL OPF(FN.REDO.LY.POINTS.US,F.REDO.LY.POINTS.US)

    FN.REDO.LY.POINTS.TOT = 'F.REDO.LY.POINTS.TOT'
    F.REDO.LY.POINTS.TOT = ''
    CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

    FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM = ''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

    FN.REDO.LY.MASTERPRGDR= 'F.REDO.LY.MASTERPRGDR'
    F.REDO.LY.MASTERPRGDR = ''
    CALL OPF(FN.REDO.LY.MASTERPRGDR,F.REDO.LY.MASTERPRGDR)

    G.DATE = ''
    I.DATE = DATE()
    CALL DIETER.DATE(G.DATE,I.DATE,'')

    CUR.DAY = TODAY[7,2]
    CUR.MONTH = TODAY[5,2]
    CUR.YEAR = TODAY[1,4]

    CALL GET.LOC.REF('FUNDS.TRANSFER','L.CU.TXN.REF',L.CU.TXN.REF.POS)

RETURN

*-------
PROCESS:
*-------

    CUS.ID = R.NEW(REDO.PT.US.CUSTOMER.NO)
    PRG.ID = R.NEW(REDO.PT.US.PROGRAM)
    Y.US.TYPE = R.NEW(REDO.PT.US.TYPE.US)
    Y.US.QUANTITY = R.NEW(REDO.PT.US.QUANTITY)
    Y.US.QTY.VALUE = R.NEW(REDO.PT.US.QTY.VALUE)
    Y.US.MOV = R.NEW(REDO.PT.US.MOV.US)
    Y.US.ACCT.CUS = R.NEW(REDO.PT.US.CUS.ACCT.MOV.US)
    Y.US.ACCT.INT = R.NEW(REDO.PT.US.INT.ACCT.MOV.US)
    Y.US.STATUS = R.OLD(REDO.PT.US.STATUS.US)

    GOSUB READ.PROGRAM

    IF PRG.ID NE '' AND Y.US.TYPE EQ 'Normal' THEN
        Y.REST.TO.AV = 'Y'
        GOSUB UPD.PTS.MMYY
        GOSUB UPD.PTS.PGM.YY
        GOSUB UPD.PTS.YYYY
        GOSUB UPD.PTS.ALL.PGM
        GOSUB UPD.PTS.ALL.PGM.MMYY
        GOSUB UPD.PTS.ALL.PGM.YY
        GOSUB UPD.PTS.ALL.YYYY
        GOSUB CHECK.MASTER.PRG
        IF Y.UPD.ONLINE EQ 1 THEN
            GOSUB UPD.PTS.ONLINE
        END
        IF Y.US.MOV EQ 'Cuenta.Ahorro.Cliente' THEN
            GOSUB CREATE.MOV.FOR.REV
            GOSUB CREATE.MOV.FOR.CUST
            R.NEW(REDO.PT.US.DESC.US) = 'Credito a Cuenta de Ahorros No. ':Y.US.ACCT.CUS
        END
        IF Y.US.MOV EQ 'Interno' THEN
            GOSUB CREATE.MOV.FOR.REV
            GOSUB CREATE.MOV.FOR.INT
            R.NEW(REDO.PT.US.DESC.US) = 'Credito a Cuenta No. ':Y.US.ACCT.INT
        END
        GOSUB UPD.PTS.FOR.ACCT
        IF PT.USE EQ 4 THEN
            GOSUB UPD.PTS.CUS
        END
        IF PT.USE EQ 3 THEN
            GOSUB UPD.PTS.BUS
        END
* R.NEW(REDO.PT.US.STATUS.US) = '1'
    END

    IF PRG.ID NE '' AND Y.US.TYPE EQ 'Por.TDebito' THEN
        Y.REST.TO.AV = 'Y'
        IF Y.US.STATUS NE '2' THEN
            GOSUB UPD.PTS.ONLINE
        END
        GOSUB UPD.PTS.MMYY
        GOSUB UPD.PTS.PGM.YY
        GOSUB UPD.PTS.YYYY
        GOSUB UPD.PTS.ALL.PGM
        GOSUB UPD.PTS.ALL.PGM.MMYY
        GOSUB UPD.PTS.ALL.PGM.YY
        GOSUB UPD.PTS.ALL.YYYY
        GOSUB UPD.PTS.FOR.ACCT
        IF PT.USE EQ 4 THEN
            GOSUB UPD.PTS.CUS
        END
        IF PT.USE EQ 3 THEN
            GOSUB UPD.PTS.BUS
        END
        R.NEW(REDO.PT.US.STATUS.US) = '3'
    END

*CALL REDO.LY.UPDATE.USE(CUS.ID,PRG.ID,ID.NEW,Y.US.QUANTITY,Y.US.QTY.VALUE)
    APAP.REDOVER.redoLyUpdateUse(CUS.ID,PRG.ID,ID.NEW,Y.US.QUANTITY,Y.US.QTY.VALUE)  ;*R22 MANUAL CODE CONVERSION
    APAP.REDOVER.redoLyUpdateUse(customerId, prog, useId, points, ptValue)

RETURN

*------------
READ.PROGRAM:
*------------

    R.REDO.LY.PROGRAM = '' ; PRG.ERR = ''
    CALL F.READ(FN.REDO.LY.PROGRAM,PRG.ID,R.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM,PRG.ERR)
    IF R.REDO.LY.PROGRAM THEN
        PT.USE = R.REDO.LY.PROGRAM<REDO.PROG.POINT.USE>
        Y.TXN.TYPE.FOR.DEB = R.REDO.LY.PROGRAM<REDO.PROG.TXN.TYPE.US>
        Y.ACCTS.FOR.DEB = R.REDO.LY.PROGRAM<REDO.PROG.DR.ACCT.US>
        Y.ACCTS.FOR.CRE = R.REDO.LY.PROGRAM<REDO.PROG.CR.ACCT.US>
        Y.ACCTS.FOR.DEB.REV = R.REDO.LY.PROGRAM<REDO.PROG.CR.ACCT.GEN>
        Y.ACCTS.FOR.CRE.REV = R.REDO.LY.PROGRAM<REDO.PROG.DR.ACCT.GEN>
    END

RETURN

*----------------
CHECK.MASTER.PRG:
*----------------

    Y.UPD.ONLINE = ''
    Y.MASTER.PRG = ''
    Y.SLAVES.PRG = ''
    R.REDO.LY.MASTERPRGDR = '' ; MAS.ERR = ''

* CALL F.READ(FN.REDO.LY.MASTERPRGDR,'SYSTEM',R.REDO.LY.MASTERPRGDR,F.REDO.LY.MASTERPRGDR,MAS.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.LY.MASTERPRGDR,'SYSTEM',R.REDO.LY.MASTERPRGDR,MAS.ERR)        ;* Tus End
    IF R.REDO.LY.MASTERPRGDR THEN
        Y.MASTER.PRG = R.REDO.LY.MASTERPRGDR<REDO.MASPRG.MASTER.PRG>
        Y.SLAVES.PRG = R.REDO.LY.MASTERPRGDR<REDO.MASPRG.SLAVE.PRG>
    END

    Y.SLAVES.PRG.CNT = DCOUNT(Y.SLAVES.PRG,@VM)   ;*R22 AUTO CODE CONVERSION

    IF Y.SLAVES.PRG.CNT EQ 0 AND Y.MASTER.PRG NE '' THEN
        IF PRG.ID EQ Y.MASTER.PRG THEN
            PRG.ID = Y.MASTER.PRG
            Y.UPD.ONLINE = 1
            RETURN
        END
    END

    Y.SLAVE.CNT = 1
    LOOP
    WHILE Y.SLAVE.CNT LE Y.SLAVES.PRG.CNT
        Y.SLAVE.PRG = FIELD(Y.SLAVES.PRG,@VM,Y.SLAVE.CNT)  ;*R22 AUTO CODE CONVERSION
        IF PRG.ID EQ Y.MASTER.PRG OR PRG.ID EQ Y.SLAVE.PRG THEN
            PRG.ID.OLD = PRG.ID
            PRG.ID = Y.MASTER.PRG
            Y.UPD.ONLINE = 1
            Y.SLAVE.CNT = Y.SLAVES.PRG.CNT
        END
        Y.SLAVE.CNT += 1  ;*R22 AUTO CODE CONVERSION
    REPEAT

RETURN

*--------------
UPD.PTS.ONLINE:
*--------------

    TOT.POINTS.ID = CUS.ID:'ONLINEDEB'
    R.REDO.LY.POINTS.TOT =''
    CALL F.READ(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR)
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT.TOT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)

RETURN

*------------
UPD.PTS.MMYY:
*------------

    TOT.POINTS.ID = CUS.ID:PRG.ID:CUR.MONTH:CUR.YEAR
    R.REDO.LY.POINTS.TOT =''
    CALL F.READ(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR)
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT.TOT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)

RETURN

*--------------
UPD.PTS.PGM.YY:
*--------------

    TOT.POINTS.ID = CUS.ID:PRG.ID:'ALL':CUR.YEAR
    R.REDO.LY.POINTS.TOT =''
    CALL F.READ(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR)
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT.TOT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)

RETURN

*------------
UPD.PTS.YYYY:
*------------

    TOT.POINTS.ID = CUS.ID:'ALL':CUR.YEAR
    R.REDO.LY.POINTS.TOT =''
    CALL F.READ(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR)
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT.TOT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)

RETURN

*---------------
UPD.PTS.ALL.PGM:
*---------------

    TOT.POINTS.ID = 'ALL':PRG.ID
    R.REDO.LY.POINTS.TOT =''
    CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT.TOT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)

RETURN

*--------------------
UPD.PTS.ALL.PGM.MMYY:
*--------------------

    TOT.POINTS.ID = 'ALL':PRG.ID:CUR.MONTH:CUR.YEAR
    R.REDO.LY.POINTS.TOT =''
    CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT.TOT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)

RETURN

*------------------
UPD.PTS.ALL.PGM.YY:
*------------------

    TOT.POINTS.ID = 'ALL':PRG.ID:CUR.YEAR
    R.REDO.LY.POINTS.TOT =''
    CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT.TOT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)

RETURN

*----------------
UPD.PTS.ALL.YYYY:
*----------------

    TOT.POINTS.ID = 'ALL':CUR.YEAR
    R.REDO.LY.POINTS.TOT =''
    CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT.TOT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)

RETURN

*-----------
UPD.PTS.CUS:
*-----------

    TOT.POINTS.ID = CUS.ID:'C'
    R.REDO.LY.POINTS.TOT =''
    CALL F.READ(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR)
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT.TOT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)

RETURN

*-----------
UPD.PTS.BUS:
*-----------

    TOT.POINTS.ID = CUS.ID:'B'
    R.REDO.LY.POINTS.TOT =''
    CALL F.READ(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR)
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT.TOT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)

RETURN

*----------------
UPD.PTS.FOR.ACCT:
*----------------

    TOT.POINTS.ID = 'ALL':PRG.ID:CUR.DAY:CUR.MONTH:CUR.YEAR
    R.REDO.LY.POINTS.TOT =''
    CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
    Y.REST.TO.AV = 'N'
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT.TOT
    Y.REST.TO.AV = 'Y'
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)

RETURN

*-----------
UPD.PROCESS:
*-----------

    VAR.AVAIL = 0 ; VAR.AVAIL.VALUE = 0
    VAR.USED = 0 ; VAR.USED.VALUE = 0

    IF R.REDO.LY.POINTS.TOT EQ '' THEN
        VAR.AVAIL = 0
        VAR.AVAIL.VALUE = 0
        VAR.USED = 0
        VAR.USED.VALUE = 0
    END ELSE
        VAR.AVAIL = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS>
        VAR.AVAIL.VALUE = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.VALUE>
        VAR.USED = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.POINTS>
        VAR.USED.VALUE = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.VALUE>
    END

    VAR.USED += Y.US.QUANTITY
    VAR.USED.VALUE += Y.US.QTY.VALUE

    IF Y.REST.TO.AV EQ 'Y' THEN
        VAR.AVAIL -= Y.US.QUANTITY
        VAR.AVAIL.VALUE -= Y.US.QTY.VALUE
        R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS> = VAR.AVAIL
        R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.VALUE> = VAR.AVAIL.VALUE
    END

    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.POINTS> = VAR.USED
    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.VALUE> = VAR.USED.VALUE

RETURN

*----------------
ASSIGN.AUDIT.TOT:
*----------------

    CURR.NO = ''
    CUR.TIME = OCONV(TIME(), "MT")

    CHANGE ':' TO '' IN CUR.TIME
    CURR.NO = R.REDO.LY.POINTS.TOT<REDO.PT.T.CURR.NO>
    IF CURR.NO EQ '' THEN
        CURR.NO = 1
    END ELSE
        CURR.NO += 1   ;*R22 AUTO CODE CONVERSION
    END
    R.REDO.LY.POINTS.TOT<REDO.PT.T.RECORD.STATUS> = ''
    R.REDO.LY.POINTS.TOT<REDO.PT.T.CURR.NO> = CURR.NO
    R.REDO.LY.POINTS.TOT<REDO.PT.T.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR   ;*R22 AUTO CODE CONVERSION
    R.REDO.LY.POINTS.TOT<REDO.PT.T.DATE.TIME> = G.DATE[3,6]:CUR.TIME
    R.REDO.LY.POINTS.TOT<REDO.PT.T.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR   ;*R22 AUTO CODE CONVERSION
    R.REDO.LY.POINTS.TOT<REDO.PT.T.CO.CODE> = ID.COMPANY
    R.REDO.LY.POINTS.TOT<REDO.PT.T.DEPT.CODE> = 1

RETURN

*-------------------
CREATE.MOV.FOR.CUST:
*-------------------

    Y.ACCT.FOR.DEB.SET = Y.ACCTS.FOR.DEB
    Y.ACCT.FOR.DEB = ''
    Y.ACCT.FOR.CRE.SET = Y.ACCTS.FOR.CRE
    Y.ACCT.FOR.DEB.TOT = DCOUNT(Y.ACCT.FOR.DEB.SET,@VM) ;*R22 AUTO CODE CONVERSION
    Y.ACCT.FOR.DEB.CNT = 1
    LOOP
    WHILE Y.ACCT.FOR.DEB.CNT LE Y.ACCT.FOR.DEB.TOT
        Y.ACCT.TO.CR = FIELD(Y.ACCT.FOR.CRE.SET,@VM,Y.ACCT.FOR.DEB.CNT)  ;*R22 AUTO CODE CONVERSION
        IF Y.ACCT.TO.CR EQ 'CUST.ACCT' THEN
            Y.ACCT.FOR.DEB = FIELD(Y.ACCT.FOR.DEB.SET,@VM,Y.ACCT.FOR.DEB.CNT)  ;*R22 AUTO CODE CONVERSION
            Y.ACCT.FOR.DEB.CNT = Y.ACCT.FOR.DEB.TOT
        END
        Y.ACCT.FOR.DEB.CNT += 1
    REPEAT

    IF Y.ACCT.FOR.DEB EQ '' THEN
        RETURN
    END

RETURN

*------------------
CREATE.MOV.FOR.INT:
*------------------

    Y.ACCT.FOR.DEB.SET = Y.ACCTS.FOR.DEB
    Y.ACCT.FOR.DEB = ''
    Y.ACCT.FOR.CRE.SET = Y.ACCTS.FOR.CRE
    Y.ACCT.FOR.DEB.TOT = DCOUNT(Y.ACCT.FOR.DEB.SET,@VM)  ;*R22 AUTO CODE CONVERSION
    Y.ACCT.FOR.DEB.CNT = 1
    LOOP
    WHILE Y.ACCT.FOR.DEB.CNT LE Y.ACCT.FOR.DEB.TOT
        Y.ACCT.TO.CR = FIELD(Y.ACCT.FOR.CRE.SET,@VM,Y.ACCT.FOR.DEB.CNT)  ;*R22 AUTO CODE CONVERSION
        IF Y.ACCT.TO.CR NE 'CUST.ACCT' THEN
            Y.ACCT.FOR.DEB = FIELD(Y.ACCT.FOR.DEB.SET,@VM,Y.ACCT.FOR.DEB.CNT)   ;*R22 AUTO CODE CONVERSION
            Y.ACCT.FOR.DEB.CNT = Y.ACCT.FOR.DEB.TOT
        END
        Y.ACCT.FOR.DEB.CNT += 1  ;*R22 AUTO CODE CONVERSION
    REPEAT

    IF Y.ACCT.FOR.DEB EQ '' THEN
        RETURN
    END

    R.REC.FT = ''
    R.REC.FT<FT.TRANSACTION.TYPE> = Y.TXN.TYPE.FOR.DEB
    R.REC.FT<FT.DEBIT.ACCT.NO> = Y.ACCT.FOR.DEB
    R.REC.FT<FT.DEBIT.CURRENCY> = LCCY
    R.REC.FT<FT.DEBIT.VALUE.DATE> = TODAY
    R.REC.FT<FT.CREDIT.ACCT.NO> = Y.US.ACCT.INT
    R.REC.FT<FT.CREDIT.CURRENCY> = LCCY
    R.REC.FT<FT.CREDIT.AMOUNT> = Y.US.QTY.VALUE
    R.REC.FT<FT.CREDIT.VALUE.DATE> = TODAY
    R.REC.FT<FT.ORDERING.CUST> = CUS.ID
    R.REC.FT<FT.PROFIT.CENTRE.CUST> = CUS.ID
    R.REC.FT<FT.LOCAL.REF,L.CU.TXN.REF.POS> = ID.NEW

RETURN

*------------------
CREATE.MOV.FOR.REV:
*------------------

    Y.ACCT.FOR.DEB.REV = FIELD(Y.ACCTS.FOR.DEB.REV,@VM,1)  ;*R22 AUTO CODE CONVERSION
    Y.ACCT.FOR.CRE.REV = FIELD(Y.ACCTS.FOR.CRE.REV,@VM,1)   ;*R22 AUTO CODE CONVERSION

    IF Y.ACCT.FOR.DEB.REV EQ '' THEN
        RETURN
    END

    R.REC.FT = ''
    R.REC.FT<FT.TRANSACTION.TYPE> = Y.TXN.TYPE.FOR.DEB
    R.REC.FT<FT.DEBIT.ACCT.NO> = Y.ACCT.FOR.DEB.REV
    R.REC.FT<FT.DEBIT.CURRENCY> = LCCY
    R.REC.FT<FT.DEBIT.VALUE.DATE> = TODAY
    R.REC.FT<FT.CREDIT.ACCT.NO> = Y.ACCT.FOR.CRE.REV
    R.REC.FT<FT.CREDIT.CURRENCY> = LCCY
    R.REC.FT<FT.CREDIT.AMOUNT> = Y.US.QTY.VALUE
    R.REC.FT<FT.CREDIT.VALUE.DATE> = TODAY
    R.REC.FT<FT.ORDERING.CUST> = CUS.ID
    R.REC.FT<FT.PROFIT.CENTRE.CUST> = CUS.ID
    R.REC.FT<FT.LOCAL.REF,L.CU.TXN.REF.POS> = ID.NEW


RETURN

*----------------------------------------------------------------------------------
END
