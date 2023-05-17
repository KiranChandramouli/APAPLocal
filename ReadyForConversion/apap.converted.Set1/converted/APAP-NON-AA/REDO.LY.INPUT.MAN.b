SUBROUTINE REDO.LY.INPUT.MAN
*-----------------------------------------------------------------------------
*DESCRIPTION: This subis performed in REDO.LY.POINTS,PTMANLOAD version as authorization routine
* The functionality is to apply the maintenance to point record once the maintenance record is authorized
* through maintenance load task and popual values involved automatically and update the application
* REDO.LY.POINTS.TOT

* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 14-Dec-2011 RMONDRAGON ODR-2011-06-0243 Initial Creation
* 06-Jun-2012 RMONDRAGON ODR-2011-06-0243 PACS00188873
* 25-Feb-2013 RMONDRAGON ODR-2011-06-0243 Update
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.LY.POINTS
    $INSERT I_F.REDO.LY.POINTS.TOT
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_F.REDO.LY.MASTERPRGDR

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

**********
OPEN.FILES:
**********

    FN.REDO.LY.PROGRAM='F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM=''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

    FN.REDO.LY.POINTS.TOT='F.REDO.LY.POINTS.TOT'
    F.REDO.LY.POINTS.TOT=''
    CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

    FN.REDO.LY.MASTERPRGDR='F.REDO.LY.MASTERPRGDR'
    F.REDO.LY.MASTERPRGDR=''
    CALL OPF(FN.REDO.LY.MASTERPRGDR,F.REDO.LY.MASTERPRGDR)

    G.DATE = ''
    I.DATE = DATE()
    CALL DIETER.DATE(G.DATE,I.DATE,'')

    Y.UPD.ONLINE = 0

    CALL GET.LOC.REF('FUNDS.TRANSFER','L.CU.TXN.REF',L.CU.TXN.REF.POS)

RETURN

**********
PROCESS:
**********
*Updating the fields Quantity, Quantity Value and Man.Date

    Y.MAN.QTY=R.NEW(REDO.PT.MAN.QTY)
    Y.MAN.QTY.VALUE=R.NEW(REDO.PT.MAN.QTY.VALUE)
    Y.MAN.STATUS=R.NEW(REDO.PT.MAN.STATUS)
    Y.QUANTITY=R.NEW(REDO.PT.QUANTITY)
    Y.PROGRAM=R.NEW(REDO.PT.PROGRAM)
    Y.GEN.DATE=R.NEW(REDO.PT.GEN.DATE)
    Y.AVAIL.DATE=R.NEW(REDO.PT.AVAIL.DATE)
    Y.STATUS=R.NEW(REDO.PT.STATUS)
    Y.PRODUCT=R.NEW(REDO.PT.PRODUCT)
    Y.PRD.CNT=DCOUNT(Y.PRODUCT,@VM)
    Y.MULTI.CNT=DCOUNT(Y.PROGRAM,@VM)
    VAR0=1
    LOOP
    WHILE VAR0 LE Y.PRD.CNT
        VAR1=1
        LOOP
        WHILE VAR1 LE Y.MULTI.CNT
            Y.SUB.PROGRAM=Y.PROGRAM<VAR0,VAR1>
            Y.SUB.PRGM.CNT=DCOUNT(Y.SUB.PROGRAM,@SM)
            GOSUB CHK.PROGRAM
            VAR1 += 1
        REPEAT
        VAR0 += 1
    REPEAT

RETURN

******************
CHK.PROGRAM:
******************
* For each program in points table loops through

    VAR2=1
    LOOP
    WHILE VAR2 LE Y.SUB.PRGM.CNT
        Y.LY.PRGM.ID=Y.PROGRAM<VAR0,VAR1,VAR2>
        CALL F.READ(FN.REDO.LY.PROGRAM,Y.LY.PRGM.ID,R.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM,PRGM.ERR)
        Y.POINTFOR=R.REDO.LY.PROGRAM<REDO.PROG.POINT.USE>
        Y.AIRL.PROG=R.REDO.LY.PROGRAM<REDO.PROG.AIRL.PROG>
        Y.TXN.TYPE.FOR.DEB=R.REDO.LY.PROGRAM<REDO.PROG.TXN.TYPE.MAN>
        Y.ACCT.DR.SET=R.REDO.LY.PROGRAM<REDO.PROG.DR.ACCT.MAN>
        Y.ACCT.CR.SET=R.REDO.LY.PROGRAM<REDO.PROG.CR.ACCT.MAN>
        IF Y.STATUS<VAR0,VAR1,VAR2> EQ "No.Liberada" AND Y.MAN.STATUS<VAR0,VAR1,VAR2> EQ "SI" THEN
            GOSUB UPD.PTS.MMYY
            GOSUB UPD.PTS.PGM.YY
            GOSUB UPD.PTS.YYYY
            GOSUB UPD.PTS.ALL.PGM
            GOSUB UPD.PTS.ALL.PGM.MMYY
            GOSUB UPD.PTS.ALL.PGM.YY
            GOSUB UPD.PTS.ALL.YYYY
            GOSUB FINAL.CHECK
            GOSUB CHECK.MASTER.PRG
            GOSUB UPD.PTS.PGM.DDMMYY
            GOSUB UPD.PTS.ONLINEDEB
        END
        VAR2 += 1
    REPEAT

RETURN

*************
CHECK.PROCESS:
*************
* Depends on type status and man.status and man.qty, Total gen,Total avaiL points gets updated

    Y.TEMP.MAN.QTY=Y.MAN.QTY<VAR0,VAR1,VAR2>
    Y.TEMP.MAN.QTY.VALUE=Y.MAN.QTY.VALUE<VAR0,VAR1,VAR2>
    Y.TEMP.GEN.DATE=Y.GEN.DATE<VAR0,VAR1,VAR2>
    Y.TEMP.AVAIL.DATE=Y.AVAIL.DATE<VAR0,VAR1,VAR2>
    GOSUB CHECK.GEN.AVAIL
    IF Y.AIRL.PROG EQ 'SI' THEN
        R.NEW(REDO.PT.STATUS)<VAR0,VAR1,VAR2>="Pendiente.Someter"
    END ELSE
        R.NEW(REDO.PT.STATUS)<VAR0,VAR1,VAR2>="Liberada"
    END
    GOSUB UPDATE.POINT.TOT

RETURN

****************
CHECK.GEN.AVAIL:
****************

    Y.TOT.GEN.POINTS+=Y.TEMP.MAN.QTY
    Y.TOT.GEN.VALUE+=Y.TEMP.MAN.QTY.VALUE
    Y.TOT.AVAIL.POINTS+=Y.TEMP.MAN.QTY
    Y.TOT.AVAIL.VALUE+=Y.TEMP.MAN.QTY.VALUE
    Y.TOT.MAN.POINTS+=Y.TEMP.MAN.QTY
    Y.TOT.MAN.VALUE+=Y.TEMP.MAN.QTY.VALUE

RETURN

*****************
UPDATE.POINT.TOT:
*****************
* This part updates the REDO.LY.POINTS.TOT template with audit fields

    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.GEN.POINTS>= Y.TOT.GEN.POINTS
    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.GEN.VALUE>= Y.TOT.GEN.VALUE
    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS>= Y.TOT.AVAIL.POINTS
    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.VALUE>= Y.TOT.AVAIL.VALUE
    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.MAN.POINTS>= Y.TOT.MAN.POINTS
    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.MAN.VALUE>= Y.TOT.MAN.VALUE

    CURR.NO = ''
    CUR.TIME = OCONV(TIME(), "MT")
    CHANGE ':' TO '' IN CUR.TIME
    CURR.NO = R.REDO.LY.POINTS.TOT<REDO.PT.T.CURR.NO>
    IF CURR.NO EQ '' THEN
        CURR.NO = 1
    END ELSE
        CURR.NO += 1
    END
    R.REDO.LY.POINTS.TOT<REDO.PT.T.RECORD.STATUS> = ''
    R.REDO.LY.POINTS.TOT<REDO.PT.T.CURR.NO> = CURR.NO
    R.REDO.LY.POINTS.TOT<REDO.PT.T.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR
    R.REDO.LY.POINTS.TOT<REDO.PT.T.DATE.TIME> = G.DATE[3,6]:CUR.TIME
    R.REDO.LY.POINTS.TOT<REDO.PT.T.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR
    R.REDO.LY.POINTS.TOT<REDO.PT.T.CO.CODE> = ID.COMPANY
    R.REDO.LY.POINTS.TOT<REDO.PT.T.DEPT.CODE> = 1
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,Y.POINTS.TOT.ID,R.REDO.LY.POINTS.TOT)

RETURN

*****************
UPD.PTS.MMYY:
*****************

    Y.POINTS.TOT.ID=ID.NEW:Y.LY.PRGM.ID:TODAY[5,2]:TODAY[1,4]
    GOSUB GET.VAL.TO.UPD
    GOSUB CHECK.PROCESS

RETURN

*****************
UPD.PTS.PGM.YY:
*****************

    Y.POINTS.TOT.ID=ID.NEW:Y.LY.PRGM.ID:'ALL':TODAY[1,4]
    GOSUB GET.VAL.TO.UPD
    GOSUB CHECK.PROCESS

RETURN

*************
UPD.PTS.YYYY:
*************

    Y.POINTS.TOT.ID=ID.NEW:'ALL':TODAY[1,4]
    GOSUB GET.VAL.TO.UPD
    GOSUB CHECK.PROCESS

RETURN

****************
UPD.PTS.ALL.PGM:
****************

    Y.POINTS.TOT.ID='ALL':Y.LY.PRGM.ID
    GOSUB GET.VAL.TO.UPD2
    GOSUB CHECK.PROCESS

RETURN

*********************
UPD.PTS.ALL.PGM.MMYY:
*********************

    Y.POINTS.TOT.ID='ALL':Y.LY.PRGM.ID:TODAY[5,2]:TODAY[1,4]
    GOSUB GET.VAL.TO.UPD2
    GOSUB CHECK.PROCESS

RETURN

*******************
UPD.PTS.ALL.PGM.YY:
*******************

    Y.POINTS.TOT.ID='ALL':Y.LY.PRGM.ID:TODAY[1,4]
    GOSUB GET.VAL.TO.UPD2
    GOSUB CHECK.PROCESS

RETURN

*****************
UPD.PTS.ALL.YYYY:
*****************

    Y.POINTS.TOT.ID='ALL':TODAY[1,4]
    GOSUB GET.VAL.TO.UPD2
    GOSUB CHECK.PROCESS

RETURN

*******************
UPD.PTS.PGM.DDMMYY:
*******************

    Y.POINTS.TOT.ID='ALL':Y.LY.PRGM.ID:TODAY[7,2]:TODAY[5,2]:TODAY[1,4]
    GOSUB GET.VAL.TO.UPD2
    GOSUB CHECK.PROCESS
    GOSUB CREATE.MOV.FOR.ACCT

RETURN

******************
UPD.PTS.ONLINEDEB:
******************

    IF Y.UPD.ONLINE EQ 1 THEN
        Y.POINTS.TOT.ID=ID.NEW:'ONLINEDEB'
        GOSUB GET.VAL.TO.UPD
        GOSUB CHECK.PROCESS
    END

RETURN

***************
GET.VAL.TO.UPD:
***************

    Y.TOT.GEN.POINTS = 0 ; Y.TOT.GEN.VALUE = 0
    Y.TOT.AVAIL.POINTS = 0 ; Y.TOT.AVAIL.VALUE = 0
    Y.TOT.MAN.POINTS = 0 ; Y.TOT.MAN.VALUE = 0

    R.REDO.LY.POINTS.TOT=''; TOT.ERR=''
    CALL F.READ(FN.REDO.LY.POINTS.TOT,Y.POINTS.TOT.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR)
    IF R.REDO.LY.POINTS.TOT THEN
        Y.TOT.GEN.POINTS=R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.GEN.POINTS>
        Y.TOT.GEN.VALUE=R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.GEN.VALUE>
        Y.TOT.AVAIL.POINTS=R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS>
        Y.TOT.AVAIL.VALUE=R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.VALUE>
        Y.TOT.MAN.POINTS=R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.MAN.POINTS>
        Y.TOT.MAN.VALUE=R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.MAN.VALUE>
    END

RETURN

****************
GET.VAL.TO.UPD2:
****************

    Y.TOT.GEN.POINTS = 0 ; Y.TOT.GEN.VALUE = 0
    Y.TOT.AVAIL.POINTS = 0 ; Y.TOT.AVAIL.VALUE = 0
    Y.TOT.MAN.POINTS = 0 ; Y.TOT.MAN.VALUE = 0

    R.REDO.LY.POINTS.TOT=''; TOT.ERR=''
    CALL F.READU(FN.REDO.LY.POINTS.TOT,Y.POINTS.TOT.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
    IF R.REDO.LY.POINTS.TOT THEN
        Y.TOT.GEN.POINTS=R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.GEN.POINTS>
        Y.TOT.GEN.VALUE=R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.GEN.VALUE>
        Y.TOT.AVAIL.POINTS=R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS>
        Y.TOT.AVAIL.VALUE=R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.VALUE>
        Y.TOT.MAN.POINTS=R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.MAN.POINTS>
        Y.TOT.MAN.VALUE=R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.MAN.VALUE>
    END

RETURN

*****************
FINAL.CHECK:
*****************

    IF Y.POINTFOR EQ '4' THEN
        Y.POINTS.TOT.ID=ID.NEW:'C'
        GOSUB GET.VAL.TO.UPD
        GOSUB CHECK.PROCESS

    END
    IF Y.POINTFOR EQ '3' THEN
        Y.POINTS.TOT.ID=ID.NEW:'B'
        GOSUB GET.VAL.TO.UPD
        GOSUB CHECK.PROCESS
    END

RETURN

*****************
CHECK.MASTER.PRG:
*****************

    R.REDO.LY.MASTERPRGDR = '' ; MAS.ERR = ''

* CALL F.READ(FN.REDO.LY.MASTERPRGDR,'SYSTEM',R.REDO.LY.MASTERPRGDR,F.REDO.LY.MASTERPRGDR,MAS.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.LY.MASTERPRGDR,'SYSTEM',R.REDO.LY.MASTERPRGDR,MAS.ERR) ; * Tus End
    IF R.REDO.LY.MASTERPRGDR THEN
        Y.MASTER.PRG = R.REDO.LY.MASTERPRGDR<REDO.MASPRG.MASTER.PRG>
        Y.SLAVES.PRG = R.REDO.LY.MASTERPRGDR<REDO.MASPRG.SLAVE.PRG>
    END

    Y.SLAVES.PRG.CNT = DCOUNT(Y.SLAVES.PRG,@VM)

    IF Y.SLAVES.PRG.CNT EQ 0 AND Y.MASTER.PRG NE '' THEN
        IF Y.LY.PRGM.ID EQ Y.MASTER.PRG THEN
            Y.LY.PRGM.ID = Y.MASTER.PRG
            Y.UPD.ONLINE = 1
            RETURN
        END
    END

    Y.SLAVE.CNT = 1
    LOOP
    WHILE Y.SLAVE.CNT LE Y.SLAVES.PRG.CNT
        Y.SLAVE.PRG = FIELD(Y.SLAVES.PRG,@VM,Y.SLAVE.CNT)
        IF Y.LY.PRGM.ID EQ Y.MASTER.PRG OR Y.LY.PRGM.ID EQ Y.SLAVE.PRG THEN
            Y.LY.PRGM.ID = Y.MASTER.PRG
            Y.UPD.ONLINE = 1
            Y.SLAVE.CNT = Y.SLAVES.PRG.CNT
        END
        Y.SLAVE.CNT += 1
    REPEAT

RETURN

********************
CREATE.MOV.FOR.ACCT:
********************

    Y.AMOUNT = Y.TEMP.MAN.QTY.VALUE

    IF Y.AMOUNT GT 0 THEN
        Y.ACCT.FOR.DEB = FIELD(Y.ACCT.DR.SET,@VM,1)
        Y.ACCT.FOR.CRE = FIELD(Y.ACCT.CR.SET,@VM,1)
    END ELSE
        Y.ACCT.FOR.DEB = FIELD(Y.ACCT.CR.SET,@VM,1)
        Y.ACCT.FOR.CRE = FIELD(Y.ACCT.DR.SET,@VM,1)
        Y.AMOUNT = NEG(Y.AMOUNT)
    END

    IF Y.ACCT.FOR.DEB EQ '' THEN
        RETURN
    END

    R.REC.FT = ''
    R.REC.FT<FT.TRANSACTION.TYPE> = Y.TXN.TYPE.FOR.DEB
    R.REC.FT<FT.DEBIT.ACCT.NO> = Y.ACCT.FOR.DEB
    R.REC.FT<FT.DEBIT.CURRENCY> = LCCY
    R.REC.FT<FT.DEBIT.VALUE.DATE> = TODAY
    R.REC.FT<FT.CREDIT.ACCT.NO> = Y.ACCT.FOR.CRE
    R.REC.FT<FT.CREDIT.CURRENCY> = LCCY
    R.REC.FT<FT.CREDIT.AMOUNT> = Y.AMOUNT
    R.REC.FT<FT.CREDIT.VALUE.DATE> = TODAY
    R.REC.FT<FT.ORDERING.CUST> = ID.NEW
    R.REC.FT<FT.PROFIT.CENTRE.CUST> = ID.NEW
    R.REC.FT<FT.LOCAL.REF,L.CU.TXN.REF.POS> = 'LYMAN':ID.NEW

    APP.NAME = 'FUNDS.TRANSFER'
    OFSFUNCTION = 'I'
    PROCESS = 'PROCESS'
    OFS.SOURCE.ID = 'LY.ACCMOV'
    OFSVERSION = 'FUNDS.TRANSFER,REDO.LY.ACCMOV.MAN'
    GTS.MODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = ''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.REC.FT,OFSSTRING)

    CALL OFS.POST.MESSAGE(OFSSTRING,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

RETURN

END
